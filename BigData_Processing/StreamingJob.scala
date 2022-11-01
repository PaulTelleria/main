package project.streaming

import java.sql.Timestamp
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration.Duration
import scala.concurrent.{Await, Future}

import org.apache.spark.sql.{DataFrame, SparkSession}

case class UsersMessage(timestamp: Long, id: String, antenna_id: String, bytes: Long, app: String )

trait StreamingJob {

  val spark: SparkSession

  def readFromKafka(kafkaServer: String, topic: String): DataFrame

  def parserJsonData(dataFrame: DataFrame): DataFrame

  def readUserMetadata(jobid: Text, jobname: Text, jobemail: Text, jobquota: Bigint): DataFrame

  def enrichuserWithMetadata(userDF: DataFrame, metadataDF: DataFrame): DataFrame

  def computeDevicesCountByCoordinates(dataFrame: DataFrame): DataFrame

  def writeToJdbc(dataFrame: DataFrame, jobid: Text, jobname: Text, jobemail: Text, jobquota: Bigint): Future[Unit]

  def writeToStorage(dataFrame: DataFrame, storageRootPath: String): Future[Unit]

  def run(args: Array[String]): Unit = {
    val Array(kafkaServer, topic, jdbcUri, jdbcMetadataTable, aggJdbcTable, jdbcUser, jdbcPassword, storagePath) = args
    println(s"Running with: ${args.toSeq}")

    val kafkaDF = readFromKafka(kafkaServer, topic)
    val userDF = parserJsonData(kafkaDF)
    val metadataDF = readAntennaMetadata(jobid, jobname, jobemail, jobquota)
    val userMetadataDF = enrichuserWithMetadata(userDF, metadataDF)
    val storageFuture = writeToStorage(userDF, storagePath)
    val aggByCoordinatesDF = computeDevicesCountByCoordinates(antennaMetadataDF)
    val aggFuture = writeToJdbc(aggByCoordinatesDF, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword)

    Await.result(Future.sequence(Seq(aggFuture, storageFuture)), Duration.Inf)

    spark.close()
  }

}
