require("jsonlite")
require("RCurl")
require("extrafont")
require("ggplot2")
require("dplyr")

traffic <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from trafficshort"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_djs3287', PASS='orcl_djs3287', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
cbsa <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from CBSA"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_djs3287', PASS='orcl_djs3287', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

trafficLocal <- read.table("01 Data/traffic-proj3.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)
cbsaLocal <- read.table("01 Data/traffic-proj3.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)

combinedDF<- full_join(traffic,cbsa,by="URBAN_AREA") %>% filter(POP_GROUP %in% c("Sml", "Med", "Lrg"))

ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='title') +
  labs(x="Migration", y=paste("Gas Cost")) +
  layer(data=combinedDF, 
        mapping=aes(x=as.numeric(as.character(NETMIG/POPULATION)), y=as.numeric(as.character(GAS_COST)), color=POP_GROUP), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        position=position_identity()
  )  
