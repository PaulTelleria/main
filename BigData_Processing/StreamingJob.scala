package practica.streaming

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration.Duration
import scala.concurrent.{Await, Future}
import org.apache.spark.sql.{DataFrame, SparkSession}

trait StreamingJob {

  def infoTotal(data: DataFrame, aggColumn: String): DataFrame
  def writeToJdbc(dataFrame: DataFrame, jdbcURI: String, jdbcTable: String, user: String, password: String): Future[Unit]

  def writeToStorage(dataFrame: DataFrame, storageRootPath: String): Future[Unit]
  val spark: SparkSession

  def readFromKafka(kafkaServer: String, topic: String): DataFrame
  def parserJsonData(dataFrame: DataFrame): DataFrame



  def run(args: Array[String]): Unit = {
    val Array(kafkaServer, topic, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword, storagePath) = args
    println(s"Running with: ${args.toSeq}")

    val kafkaDF = readFromKafka(kafkaServer, topic)
    val parserDF = parserJsonData(kafkaDF)
    val storageFuture = writeToStorage(parserDF, storagePath)

    val appStream = bytesTotalAgg(parsedDF, "app")
    val userStream = bytesTotalAgg(parsedDF.withColumnRenamed("id", "user"), "user")
    val antennaStream = bytesTotalAgg(parsedDF.withColumnRenamed("antenna_id", "antenna"), "antenna")

    val appJdbc = writeToJdbc(appStream, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword)
    val userJdbc = writeToJdbc(userStream, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword)
    val antennaJdbc = writeToJdbc(antennaStream, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword)

    Await.result(
      Future.sequence(Seq(storageFuture, appJdbc, userJdbc, antennaJdbc)), Duration.Inf
    )

    spark.close()
  }

}
