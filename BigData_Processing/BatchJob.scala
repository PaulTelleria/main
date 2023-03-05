package practica.batch

import java.time.OffsetDateTime
import org.apache.spark.sql.{DataFrame, SparkSession}

trait BatchJob {

  val spark: SparkSession
  def readFromStorage(storagePath: String, filterDate: OffsetDateTime): DataFrame
  def readUserMetadata(jdbcURI: String, jdbcTable: String, user: String, password: String): DataFrame

  def writeToJdbc(dataFrame: DataFrame, jdbcURI: String, jdbcTable: String, user: String, password: String): Unit
  def writeToStorage(dataFrame: DataFrame, storageRootPath: String): Unit

  def computeTotalBytesAgg(devicesDataDF: DataFrame, columnName: String, metricName: String, filterDate: OffsetDateTime): DataFrame
  def calculateUserQuotaLimit(userTotalBytesDF: DataFrame, userMetadataDF: DataFrame): DataFrame



  def run(args: Array[String]): Unit = {
    val Array(filterDate, storagePath, jdbcUri, jdbcMetadataTable, aggJdbcTable, quotaJdbcTable, jdbcUser, jdbcPassword) = args
    println(s"Running with: ${args.toSeq}")

    val offsetDateTime = OffsetDateTime.parse(filterDate)

    val devicesDF = readFromStorage(storagePath, offsetDateTime)
    val userMetadataDF = readUserMetadata(jdbcUri, jdbcMetadataTable, jdbcUser, jdbcPassword)

    val userTotalBytesDF = computeTotalBytesAgg(devicesDF, "id", "user_bytes_total", offsetDateTime).persist()
    val antennaTotalBytesDF = computeTotalBytesAgg(devicesDF, "antenna_id", "antenna_bytes_total", offsetDateTime).persist()
    val appTotalBytesDF = computeTotalBytesAgg(devicesDF, "app", "app_bytes_total", offsetDateTime).persist()

    val userQuotaLimit = calculateUserQuotaLimit(userTotalBytesDF, userMetadataDF)

    writeToJdbc(userTotalBytesDF, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword)
    writeToJdbc(antennaTotalBytesDF, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword)
    writeToJdbc(appTotalBytesDF, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword)
    writeToJdbc(userQuotaLimit, jdbcUri, quotaJdbcTable, jdbcUser, jdbcPassword)

    spark.close()
  }

}
