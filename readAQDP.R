# A code to read Aquadopp Profiler raw data file using R
# Written by Mostafa Nazarali on 20 April 2020
# You should have these packages installed: oce, dygraphs, xts
# This sample is written for upward looking ADCPs and read all bins and beams!

setwd("E:/Mostafa Nazarali/R sample codes/ReadAquadopp") #You have to specify the path of your file
library(oce)

# Check whether your data file is created by and Aquadopp Profiler
oceMagic("sampledata.prf")								# You have to specify your filename

# Read data from raw data file of Aquadopp profiler instrument (.prf)
aq <- read.aquadoppProfiler("sampledata.prf",from=1,  by = 1,
              tz = getOption("oceTz"),
              longitude = NA,
              latitude = NA,
              orientation = "upward",
              monitor = TRUE,
              despike = FALSE,
              debug = 2)								# You have to specify your filename

# Read Metadata (just the main ones)
CellSize <- oceGetMetadata(aq,'cellSize')
NoCells <- oceGetMetadata(aq,'numberOfCells')
StartTime <- oceGetMetadata(aq,'measurementStart')
EndTime <- oceGetMetadata(aq,'measurementEnd')
Dt <- oceGetMetadata(aq,'measurementDeltat')
t <- seq(StartTime,EndTime,by=600)

# Read Data
velocity <- oceGetData(aq,'v')
distance <- oceGetData(aq,'distance')
plot(t,velocity[,1,1])

# Plot time series of horizontal current veclocity components
library(dygraphs)
library(xts)
data <- data.frame(
  time=t, 
  value1=velocity[,1,1], 
  value2=velocity[,1,2],
)
P=xts( x=data[,-1], order.by=data$time)
dygraph(P)