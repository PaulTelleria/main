package practica.batch

import java.time.OffsetDateTime
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types.TimestampType
import org.apache.spark.sql.{DataFrame, SaveMode, SparkSession}

object DevicesBatchJob extends BatchJob {

  override val spark: SparkSession = SparkSession
    .builder()
    .master("local[*]")
    .appName("Project Spark Processing Batch")
    .getOrCreate()

  import spark.implicits._

  override def readFromStorage(storagePath: String, filterDate: OffsetDateTime): DataFrame = {
    spark
      .read
      .format("parquet")
      .load(s"${storagePath}/data")
      .filter(
        $"year" === filterDate.getYear &&
          $"month" === filterDate.getMonthValue &&
          $"day" === filterDate.getDayOfMonth &&
          $"hour" === filterDate.getHour
      )
      .cache()
  }

  override def readUserMetadata(jdbcURI: String, jdbcTable: String, user: String, password: String): DataFrame = {
    spark
      .read
      .format("jdbc")
      .option("url", jdbcURI)
      .option("dbtable", jdbcTable)
      .option("user", user)
      .option("password", password)
      .load()
  }

  override def computeTotalBytesAgg(devicesDataDF: DataFrame, columnName: String, metricName: String, filterDate: OffsetDateTime): DataFrame = {
    devicesDataDF
      .select(col(columnName).as("id"), $"bytes")
      .groupBy($"id")
      .agg(sum($"bytes").as("value"))
      .withColumn("type", lit(metricName))
      .withColumn("timestamp", lit(filterDate.toEpochSecond).cast(TimestampType))
  }

  override def calculateUserQuotaLimit(userTotalBytesDF: DataFrame, userMetadataDF: DataFrame): DataFrame = {
    userTotalBytesDF.as("user").select($"id", $"value", $"timestamp")
      .join(
        userMetadataDF.select($"id", $"email", $"quota").as("metadata"),
        $"user.id" === $"metadata.id" && $"user.value" > $"metadata.quota"
      )
      .select($"metadata.email", $"user.value".as("usage"), $"metadata.quota", $"user.timestamp")

  }

  override def writeToJdbc(dataFrame: DataFrame, jdbcURI: String, jdbcTable: String, user: String, password: String): Unit = {
    dataFrame
      .write
      .mode(SaveMode.Append)
      .format("jdbc")
      .option("driver", "org.postgresql.Driver")
      .option("url", jdbcURI)
      .option("dbtable", jdbcTable)
      .option("user", user)
      .option("password", password)
      .save()
  }

  override def writeToStorage(dataFrame: DataFrame, storageRootPath: String): Unit = {
    dataFrame
      .write
      .partitionBy("year", "month", "day", "hour")
      .format("parquet")
      .mode(SaveMode.Overwrite)
      .save(s"${storageRootPath}/historical")
  }

  /**
   * Main for Batch job
   *
   * @param args arguments for execution:
   *             filterDate, storagePath, jdbcUri, jdbcMetadataTable, aggJdbcTable, quotaJdbcTable, jdbcUser, jdbcPassword
   * Example:
   *   2007-01-23T10:15:30Z /tmp/project_devices jdbc:postgresql://XXX.XXX.XXX.XXXX:5432/postgres user_metadata bytes_hourly user_quota_limit postgres keepcoding
   */
  // puedes descomentar este main para pasar parametros a la ejecucion
  //def main(args: Array[String]): Unit = run(args)

  def main(args: Array[String]): Unit = {
    val jdbcUri = "jdbc:postgresql://34.173.65.17:5432/postgres"
    val jdbcUser = "postgres"
    val jdbcPassword = "keepcoding"
    val offsetDateTime = OffsetDateTime.parse("2022-10-27T22:00:00Z")

    val devicesDF = readFromStorage("/tmp/project_devices/", offsetDateTime)
    val userMetadataDF = readUserMetadata(jdbcUri, "user_metadata", jdbcUser, jdbcPassword)

    val userTotalBytesDF = computeTotalBytesAgg(devicesDF, "id", "user_bytes_total", offsetDateTime).cache()
    val antennaTotalBytesDF = computeTotalBytesAgg(devicesDF, "antenna_id", "antenna_bytes_total", offsetDateTime)
    val appTotalBytesDF = computeTotalBytesAgg(devicesDF, "app", "app_bytes_total", offsetDateTime)

    val userQuotaLimit = calculateUserQuotaLimit(userTotalBytesDF, userMetadataDF)

    writeToJdbc(userTotalBytesDF, jdbcUri, "bytes_hourly", jdbcUser, jdbcPassword)
    writeToJdbc(antennaTotalBytesDF, jdbcUri, "bytes_hourly", jdbcUser, jdbcPassword)
    writeToJdbc(appTotalBytesDF, jdbcUri, "bytes_hourly", jdbcUser, jdbcPassword)
    writeToJdbc(userQuotaLimit, jdbcUri, "user_quota_limit", jdbcUser, jdbcPassword)

    spark.close()
  }

}
