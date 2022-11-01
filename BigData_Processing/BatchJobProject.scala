package proyecto.batch

import java.sql.Timestamp
import java.time.OffsetDateTime
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration.Duration
import scala.concurrent.{Await, Future}

import org.apache.spark.sql.{DataFrame, SparkSession}

case class MobileData(year: Int, month: Int, day: Int, hour: Int, seconds: Int, timestamp: Long, id: String, antenna_id: String, bytes: Long, app: String )

trait BatchJob {

  val spark: SparkSession

  def readFromStorage(storagePath: String, filterDate: OffsetDateTime): DataFrame

  def readUserMetadata(id: Text, name: Text, email: Text, quota: Bigint): DataFrame

  def enrichAntennaWithMetadata(antennaDF: DataFrame, metadataDF: DataFrame): DataFrame

  def computeDevicesCountByCoordinates(dataFrame: DataFrame): DataFrame

  def computeErrorAntennaByModelAndVersion(dataFrame: DataFrame): DataFrame

  def computePercentStatusByID(dataFrame: DataFrame): DataFrame

  def writeToJob(jobid: Text, jobname: Text, jobemail: Text, jobquota: Bigint): Unit

  def writeToStorage(dataFrame: DataFrame, storageRootPath: String): Unit

  def run(args: Array[String]): Unit = {
    val Array(filterDate, storagePath, jobid, jobname, jobemail, jobquota, aggJdbcTable, aggJdbcErrorTable, aggJdbcPercentTable) = args
    println(s"Running with: ${args.toSeq}")

    val usersDF = readFromStorage(storagePath, OffsetDateTime.parse(filterDate))
    val metadataDF = readUserMetadata(jobid, jobname, jobemail, jobquota)
    val userMetadataDF = enrichUserWithMetadata(antennaDF, metadataDF).cache()
    val aggByCoordinatesDF = computeDevicesCountByCoordinates(userMetadataDF)
    val aggPercentStatusDF = computePercentStatusByID(userMetadataDF)
    val aggErroAntennaDF = computeErrorAntennaByModelAndVersion(userMetadataDF)

    writeToJdbc(aggByCoordinatesDF, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword)
    writeToJdbc(aggPercentStatusDF, jdbcUri, aggJdbcPercentTable, jdbcUser, jdbcPassword)
    writeToJdbc(aggErroAntennaDF, jdbcUri, aggJdbcErrorTable, jdbcUser, jdbcPassword)

    writeToStorage(antennaDF, storagePath)

    spark.close()
  }

}
