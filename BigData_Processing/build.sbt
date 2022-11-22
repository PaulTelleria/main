name := "data-simulator"

version := "0.1"

scalaVersion := "2.12.12"


libraryDependencies ++= Seq(
  "org.apache.kafka" % "kafka-clients" % "2.4.0",
  "io.circe" %% "circe-parser" % "0.13.0"
)