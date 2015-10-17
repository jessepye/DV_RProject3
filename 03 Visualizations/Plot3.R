require("jsonlite")
require("RCurl")
require("extrafont")
require("ggplot2")
require("dplyr")

df1 <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from trafficshort"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_djs3287', PASS='orcl_djs3287', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

df2 <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from cbsa"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_djs3287', PASS='orcl_djs3287', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

df3 <- left_join(df1, df2, by = "URBAN_AREA") %>% filter(POP_GROUP %in% c("Med", "Lrg", "Vlg"))

ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='Commuter Stress and High Growth Cities') +
  labs(x="Births per Capita", y=paste("Commuter Stress Index")) +
  layer(data=df3, 
        mapping=aes(x=as.numeric(as.character(BIRTHS/POPULATION)), y=as.numeric(as.character(COM_STRESS_IND)), color=POP_GROUP), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        position=position_identity()
  )