package com.treasuredata.util

import xerial.lens.cui.{DefaultCommand, option, Launcher}
import xerial.core.log.Logger
import java.io.{PrintWriter, FileWriter, BufferedWriter, File}
import scala.io.Source
;


object Converter {

  def main(args:Array[String]) {
    val launcher = Launcher.of[Converter]
    launcher.execute(args)
  }
}

class Converter(@option(prefix = "-i", description = "data set input directory (e.g., target/dataset/1)")
                inputDir:File = new File("."),
                @option(prefix="-h,--help", description = "display help message", isHelp = true)
                displayHelp:Boolean = false) extends Logger with DefaultCommand {

  private def splitAtWS(line:String) = line.split("\\s+")

  case class Schema(name:String, colNames:Seq[String], colTypes:Seq[String], timeColumns:Seq[String]) {
    val timeColumnIndexes = {
      val indexes = for((c, i) <- colNames.zipWithIndex if timeColumns.contains(c)) yield i
      indexes.toSet[Int]
    }
  }

  private val schemas = Seq(
    Schema(
      "orders",
      splitAtWS("orderkey custkey orderstatus totalprice orderdate orderpriority clerk  shippriority comment"),
      splitAtWS("long     long    string      double     long      string        string int          string"),
      Seq("orderdate")
    ),
    Schema(
      "lineitem",
      splitAtWS("orderkey partkey suppkey linenumber quantity extendedprice discount tax returnflag linestatus shipdate commitdate receiptdate shipinstruct shipmode comment"),
      splitAtWS("long     long    long    long       double   double        double   double string  string     long     long       long        string       string   string"),
      Seq("shipdate", "commitdate", "receiptdate")
    )
  )
  private val schemaTable = schemas.map(s => s.name -> s).toMap

  override def default {
    info("Converting date columns in TPC-H dataset")

    val format = new java.text.SimpleDateFormat("yyyy-MM-dd")

    for(sc <- schemas) {
      val tblFile = new File(inputDir, s"${sc.name}.tbl")
      if(!tblFile.exists())
        warn(s"Table file ${tblFile} is not found. Specify the input directory with -i option")
      else {
        val outputFile = new File(inputDir, s"${sc.name}.converted.tbl")
        val out = new PrintWriter(new BufferedWriter(new FileWriter(outputFile)))
        try {
          info(s"Convert table file: ${tblFile} to ${outputFile}")
          for(line <- Source.fromFile(tblFile).getLines()) {
            val cols = line.split("\\|")
            val convertedCols = for((c, i) <- cols.zipWithIndex) yield {
              if(sc.timeColumnIndexes.contains(i)) {
                val date = format.parse(c)
                (date.getTime / 1000).toString
              }
              else
                c
            }
            out.print(convertedCols.mkString("|"))
            out.println("|") // append dummy column
          }
        }
        finally {
          out.close()
        }
      }
    }
  }


}
