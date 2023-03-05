package practica.streaming

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.{Await, Future}
import org.apache.spark.sql.{DataFrame, SaveMode, SparkSession}
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types.{LongType, StringType, StructField, StructType, TimestampType}
import scala.concurrent.duration.Duration

object DevicesStreamingJob extends StreamingJob {

  override val spark: SparkSession = SparkSession
    .builder()
    .master("local[20]")
    .appName("Spark Processing Streaming Project ")
    .getOrCreate()

  import spark.implicits._

  override def readFromKafka(kafkaServer: String, topic: String): DataFrame = {
    spark
      .readStream
      .format("kafka")
      .option("kafka.bootstrap.servers", kafkaServer)
      .option("subscribe", topic)
      .load()
  }

  override def parserJsonData(dataFrame: DataFrame): DataFrame = {
    val jsonSchema = StructType(Seq(
      StructField("timestamp", TimestampType, nullable = false),
      StructField("id", StringType, nullable = false),
      StructField("antenna_id", StringType, nullable = false),
      StructField("bytes", LongType, nullable = false),
      StructField("app", StringType, nullable = false)
    ))

    dataFrame
      .select(from_json(col("value").cast(StringType), jsonSchema).as("json"))
      .select("json.*")
  }


  override def writeToJdbc(dataFrame: DataFrame, jdbcURI: String, jdbcTable: String, user: String, password: String): Future[Unit] = Future {
    dataFrame
      .writeStream
      .foreachBatch { (data: DataFrame, batchId: Long) =>
        data
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
      .start()
      .awaitTermination()
  }


  override def writeToStorage(dataFrame: DataFrame, storageRootPath: String): Future[Unit] = Future {
    dataFrame
      .select(
        $"id", $"antenna_id", $"bytes", $"app",
        year($"timestamp").as("year"),
        month($"timestamp").as("month"),
        dayofmonth($"timestamp").as("day"),
        hour($"timestamp").as("hour"),
      )

      .option("path", s"$storageRootPath/data")
      .option("checkpointLocation", s"$storageRootPath/checkpoint")
      .partitionBy("year", "month", "day", "hour")
      .start
      .writeStream
      .awaitTermination()
      .format("parquet")
  }

  def infoTotal(data: DataFrame, aggColumn: String): DataFrame = {
    import data.sparkSession.implicits._

    data
      .select($"timestamp", col(aggColumn), $"bytes")
      .groupBy(window($"timestamp", "3 minutes"), col(aggColumn))
      .agg(sum($"bytes").as("bytes_total"))
      .select(
        $"window.start".cast(TimestampType).as("timestamp"),
        col(aggColumn).as("id"),
        $"total_bytes".as("value"),
              )
  }


  def main(args: Array[String]): Unit = {

    val kafkaServer = "34.125.220.198:9092"
    val kafkaDF = readFromKafka(kafkaServer, "devices")
    val parserDF = parserJsonData(kafkaDF)
    val storageFuture = writeToStorage(parserDF, "/tmp/project_devices/")


    val jdbcURI = "jdbc:postgresql://34.173.65.17:5432/postgres"
    val jdbcUser = "postgres"
    val jdbcPass = "keepcoding"

    val appStream = bytesTotalAgg(parserDF, "app")
    val userStream = bytesTotalAgg(parserDF.withColumnRenamed("id", "user"), "user")
    val antennaStream = bytesTotalAgg(parsedDF.withColumnRenamed("antenna_id", "antenna"), "antenna")

    val appJdbc = writeToJdbc(appStream, jdbcURI, "bytes", jdbcUser, jdbcPass)
    val userJdbc = writeToJdbc(userStream, jdbcURI, "bytes", jdbcUser, jdbcPass)
    val antennaJdbc = writeToJdbc(antennaStream, jdbcURI, "bytes", jdbcUser, jdbcPass)




    Await.result(
      Future.sequence(Seq(storageFuture, appJdbc, userJdbc, antennaJdbc)), Duration.Inf
    )

    spark.close()
  }
}
