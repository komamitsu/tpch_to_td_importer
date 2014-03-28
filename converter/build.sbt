
packSettings 

name := "tpch-converter"

libraryDependencies += "org.xerial" % "xerial-lens" % "3.2.3"

packMain := Map("convert" -> "com.treasuredata.util.Converter")


