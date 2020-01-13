cat("\014")
# code4policy

# CHANGE DIRECTORY HERE
setwd("C:/Users/HP/Dropbox/code4policy_data/clean_data")
# As we are not allowed to make the data public, we keep the data
# on a private Dropbox

library(tidyverse)
library(haven)
library(readr)
library(ggthemes)


# input Stata file
df<- read_csv("germany_timetrend.csv")

#Share of educated voters over time
share_of_educated_voters<-df%>%
  mutate(educated=ifelse(eduade2>0,1,0))%>%
  mutate(voted=ifelse(vote==1,1,0))%>%
  mutate(voter_educated=ifelse(voted==1 & educated==1,1,0))%>%
  group_by(year)%>%
  summarise(share_of_educated_voters=sum(voter_educated,na.rm = TRUE)/sum(voted,na.rm = TRUE))

share_of_educated_voters[1,2]=NA
share_of_educated_voters[2,2]=NA


share_of_educated_voters%>%
  ggplot(aes(y = share_of_educated_voters,x=year))+
  geom_point(colour="red",
             size=2 )+
  geom_line(color="navy", size=0.8)+
  labs(y="Share of College Educated Voters", x = "Years" , caption ="Source: European Social Survey")+
  scale_x_continuous(breaks = c(2010,2014,2018), limits = c(2010,2018) )+
  theme_minimal()

ggsave("C:/Users/HP/Google Drive/1. Work/github/WhoVotes/output/share_of_educated_voters.pdf", width =7.7, height =4,dpi = 120)


#Share of migrant voters over time
share_of_voters_mig<-df%>%
  mutate(mig=ifelse(brncntr==2,1,0))%>%
  mutate(voted=ifelse(vote==1,1,0))%>%
  mutate(voter_mig=ifelse(voted==1 & mig==1,1,0))%>%
  group_by(year)%>%
  summarise(share_of_mig_voters=sum(voter_mig,na.rm = TRUE)/sum(voted,na.rm = TRUE))

share_of_voters_mig%>%
  ggplot(aes(y = share_of_mig_voters,x=year))+
  geom_point(colour="red",
             size=2 )+
  geom_line(color="navy", size=0.8)+
  labs(y="Share of Migrant Voters", x = "Years" , caption ="Source: European Social Survey")+
  scale_x_continuous(breaks = c(2004,2006,2010,2014,2018))+
  theme_minimal()

ggsave("C:/Users/HP/Google Drive/1. Work/github/WhoVotes/output/share_of_mig_voters.pdf", width =7.7, height =4,dpi = 120)


#Share of male voters over time
share_of_voters_ismale<-df%>%
  mutate(ismale=ifelse(gndr==1,1,0))%>%
  mutate(voted=ifelse(vote==1,1,0))%>%
  mutate(voter_male=ifelse(voted==1 & ismale==1,1,0))%>%
  group_by(year)%>%
  summarise(share_of_male_voters=sum(voter_male,na.rm = TRUE)/sum(voted,na.rm = TRUE))

share_of_voters_ismale%>%
  ggplot(aes(y = share_of_male_voters,x=year))+
  geom_point(colour="red",
             size=2 )+
  geom_line(color="navy", size=0.8)+
  labs(y="Share of Male Voters", x = "Years" , caption ="Source: European Social Survey")+
  scale_x_continuous(breaks = c(2004,2006,2010,2014,2018))+
  theme_minimal()

ggsave("C:/Users/HP/Google Drive/1. Work/github/WhoVotes/output/share_of_male_voters.pdf", width =7.7, height =4,dpi = 120)


#Share of religious voters over time
share_of_voters_relig<-df%>%
  mutate(relig=ifelse(rlgdgr>4,1,0))%>%
  mutate(voted=ifelse(vote==1,1,0))%>%
  mutate(voter_relig=ifelse(voted==1 & relig==1,1,0))%>%
  group_by(year)%>%
  summarise(share_of_relig_voters=sum(voter_relig,na.rm = TRUE)/sum(voted,na.rm = TRUE))

share_of_voters_relig%>%
  ggplot(aes(y = share_of_relig_voters,x=year))+
  geom_point(colour="red",
             size=2 )+
  geom_line(color="navy", size=0.8)+
  labs(y="Share of Religious Voters", x = "Years" , caption ="Source: European Social Survey")+
  scale_x_continuous(breaks = c(2004,2006,2010,2014,2018))+
  theme_minimal()

ggsave("C:/Users/HP/Google Drive/1. Work/github/WhoVotes/output/share_of_religious_voters.pdf", width =7.7, height =4,dpi = 120)


#Share of voters above 35 over time
share_of_voters_above35<-df%>%
  mutate(above35=ifelse(agea>35,1,0))%>%
  mutate(voted=ifelse(vote==1,1,0))%>%
  mutate(voter_above35=ifelse(voted==1 & above35==1,1,0))%>%
  group_by(year)%>%
  summarise(share_of_above35_voters=sum(voter_above35,na.rm = TRUE)/sum(voted,na.rm = TRUE))

share_of_voters_above35%>%
  ggplot(aes(y = share_of_above35_voters,x=year))+
  geom_point(colour="red",
             size=2 )+
  geom_line(color="navy", size=0.8)+
  labs(y="Share of Voters Above35", x = "Years" , caption ="Source: European Social Survey")+
  scale_x_continuous(breaks = c(2004,2006,2010,2014,2018))+
  theme_minimal()

ggsave("C:/Users/HP/Google Drive/1. Work/github/WhoVotes/output/share_of_above35_voters.pdf", width =7.7, height =4,dpi = 120)

#Combining all 
a<-merge(share_of_voters_above35,share_of_educated_voters, by="year")
a<-merge(a,share_of_voters_mig,by="year")
a<-merge(a,share_of_voters_ismale,by="year")
data<-merge(a,share_of_voters_relig,by="year")

data<-pivot_longer(data, cols = -c(year))
write_csv(data,path="C:/Users/HP/Dropbox/code4policy_data/clean_data/germany_timetrend_graphs_data.csv")


data%>%
  ggplot(aes(x=year,y=value,group=name, color=name))+
  geom_line()+
  labs(y="Shares of Voters", x = "Years" , caption ="Source: European Social Survey", color="Shares")+
  scale_color_manual(labels = c("Share of Above 35 Voters", 
                                "Share of Educated Voters",
                                "Share of Male Voters",
                                "Share of Migrant Voters",
                                "Share of Religious Voters"), 
                     values = c("deepskyblue",
                                "firebrick1",
                                "blueviolet",
                                "seagreen",
                                "darkorange"))+
  scale_x_continuous(breaks = c(2004,2006,2010,2014,2018))+
  scale_y_continuous(breaks = seq(0,0.85,0.05))+
  theme_minimal()


ggsave("C:/Users/HP/Google Drive/1. Work/github/WhoVotes/output/share_of_voters_combined.pdf", width =6, height =6,dpi = 120)










  
  

