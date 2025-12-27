# 在下载好R和RStudio之后，还需要下载Rtools45以及相关的工具包
# Instal  Rtools45 installer from https://cran.rstudio.com/bin/windows/Rtools/rtools45/rtools.html
# Install packages
 install.packages(
  c("SemNetDictionaries", "SemNetCleaner", "SemNeT"),
  dependencies = c("Imports", "Suggests")
 )
# Additional packages for Shiny GUI
 install.packages(
  c(
    "shiny", "shinyjs", "shinyalert",
    "shinyMatrix", "shinyBS"
  )
  )
 
 
 # 数据处理代码
 rm(list=ls(all=TRUE))  ##清空现有环境
 
 setwd("C:/Users/23157/Desktop/data/test/pre_test")
 library(readr)
 physics <- read_csv("pre_test_woseco_physics.csv")
 View(physics)
 
 # Structure of the data
 head(physics)
 
 # Run 'textcleaner'
 # Documentation for `textcleaner` function
 ?textcleaner
 getwd()
 
 # Load packages
 ## SemNetCleaner automatically loads SemNetDictionaries
 library(SemNetCleaner)
 library(SemNeT)
 library(SemNetDictionaries)
 
 #在括号内输入词库内的单词组成词典
 physicsterms.dictionary<-append.dictionary(
   "RefSys", "OverWe", "InitVel", "SpringConst", "SpringTF", "SpringElong", 
   "SpringComp", "ElasForce", "ElasDeform", "gravitation", "electrics", 
   "BalancedPair", "NonEqState", "ForceComp", "decimeter", "minute", "buoyancy", 
   "inertia", "millimetre", "ResForce", "HookeLaw", "SlideFric", "acceleration", 
   "StaticFric", "AtRest", "AbsWeightless", "AirResist", "tension", "centimeter", 
   "force", "ForceDecomp", "ForceSynth", "mechanics", "journey", "metre", "density", 
   "second", "friction", "FricCoeff", "FinalVel", "Newton", "NSL", "NTL", "NFL", 
   "ProjMotion", "BalancedF", "EqState", "AvgVel", "AvgSpeed", "HorizProj", 
   "ParalLaw", "kilogram", "kilometer", "traction", "WeLess", "time", 
   "BalancedForces", "InstantaneousSpeed", "velocity", "VelChange", "speed", 
   "volume", "UniversalGravitation", "displacement", "RelDist", "RelMotion", 
   "PotRelMotion", "InteractF", "hour", "stress", "pressure", "CircMotion", 
   "NonUniCircMotion", "UniAccMotion", "UniAccLinMotion", "UniAccel", 
   "UniVarLinMotion", "UniDecel", "UniLinDecel", "UniLinMotion","UniLinAccel", "length", "NormF", 
   "particle", "mass", "gravity", "GravAcc", "GravPE", "FreeFall", "ActionF", "distance",
   save.location = "envir"
 )
 # Dictionary can now be found
 find.dictionaries("physicsterms")
 # Load 'physicsterms' dictionary
 load.dictionaries("physicsterms")
 
 
 clean <- textcleaner(data = physics[,-c(1:3)], miss = 99,
                      partBY = "row", dictionary = "physicsterms")
 
 # Accessing and changing 'Group' variable
 group <- ifelse(physics$Group == 1, "Novice", "Expert")
 
 #-------------------------------------------#
 # 2.1.1. Preparation for network estimation #
 #-------------------------------------------#
 # Attach 'Group' variable to the binary response matrix
 behav <- cbind(physics$Group, clean$responses$binary)
 # Create Novice and Expert openness to experience response matrices
 Novice <- behav[which(behav[,1]==1),-1]
 Expert <- behav[which(behav[,1]==2),-1]
 
 # Save binary response matrices
 write.csv(Novice, "novice_BRM.csv", row.names = TRUE)
 write.csv(Expert, "expert_BRM.csv", row.names = TRUE)
 
 # SemNeT Shiny Application
 SemNeTShiny()