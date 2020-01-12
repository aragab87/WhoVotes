cat("\014")
# code4policy

# CHANGE DIRECTORY HERE
setwd("C:/Users/HP/Dropbox/code4policy_data/raw_data")
# As we are not allowed to make the data public, we keep the data
# on a private Dropbox

library(tidyverse)
library(haven)

# input Stata file
df18 <- read_dta("18_germany.dta") #Last election:2017 
df14 <- read_dta("14_germany.dta") #Last election:2013 
df10 <- read_dta("10_germany.dta") #Last election:2009 
df06 <- read_dta("06_germany.dta") #Last election:2005 
df04 <- read_dta("04_germany.dta") #Last election:2002 

# renaming variables
df14<-df14%>%rename(eduade2=edude2)
df10<-df10%>%rename(eduade2=edude2)
df06<-df06%>%rename(eduade2=edlvbe)
df04<-df04%>%rename(eduade2=edlvbe)
df06<-df06%>%rename(hinctnta=hinctnt)
df04<-df04%>%rename(hinctnta=hinctnt)

# creating a year variable and selecting demographic variables
df18<-df18%>% mutate(year=2018)%>%select(c(year,vote,hinctnta,agea,eduade2,domicil,rlgdgr,brncntr,facntr,mocntr))
df14<-df14%>% mutate(year=2014)%>%select(c(year,vote,hinctnta,agea,eduade2,domicil,rlgdgr,brncntr,facntr,mocntr))
df10<-df10%>% mutate(year=2010)%>%select(c(year,vote,hinctnta,agea,eduade2,domicil,rlgdgr,brncntr,facntr,mocntr))
df06<-df06%>% mutate(year=2006)%>%select(c(year,vote,hinctnta,agea,eduade2,domicil,rlgdgr,brncntr,facntr,mocntr))
df04<-df04%>% mutate(year=2004)%>%select(c(year,vote,hinctnta,agea,eduade2,domicil,rlgdgr,brncntr,facntr,mocntr))

#appending dataset
time_trend_data<-bind_rows(df18,df14,df10,df06,df04)
write_csv(time_trend_data,path="C:/Users/HP/Dropbox/code4policy_data/clean_data/germany_timetrend.csv")

#check
dim(time_trend_data)[1]==dim(df18)[1]+dim(df14)[1]+dim(df10)[1]+dim(df06)[1]+dim(df04)[1]








  
  

