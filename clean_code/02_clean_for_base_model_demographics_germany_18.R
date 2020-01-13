cat("\014")
# code4policy

# CHANGE DIRECTORY HERE
setwd("/Users/lucaskitzmueller/Dropbox/code4policy_data/")
# As we are not allowed to make the data public, we keep the data
# on a private Dropbox

library(tidyverse)
library(foreign)

# input Stata file
df <- read.dta("raw_data/18_germany.dta")


# 1. keep relevant variables

  # gndr, gender
  # vote - Voted last national election
  # prtvede1, erststimme
  # prtvede2, zweitstimme
  # hinctnta, income, decile
  # mbtru, member of trade union
  # agea, age of respondent
  # edubde1, highest school level
  # eduade2, highest postgraduate degree
  # eduade3, highest vocational training
  # domicil, urban/rural
  # rlgblg, Do you consider yourself as belonging to any particular religion or denomination?
  # rlgdgr, Regardless of whether you belong to a particular religion, how religious would you say you are?
  # brncntr - Born in Germany
  # uempla, uempli - unemployed, not actively looking for job, unemployed, actively looking for job
  # evmar - Are or ever been married

  df_d <- df %>%
   select(gndr, vote, prtvede1, prtvede2, hinctnta, mbtru, agea, edubde1, eduade2, eduade3, domicil, rlgblg, rlgdgr, brncntr, evmar, dweight, mocntr, facntr)

  
# 2. filter out people non-eligible to vote and people who didn't vote
  # Note: filter out non-voters, otherwise right wing share below 6%
  df_d <- df_d %>%
    filter(vote == "Yes")
  
# 3. Analyze missing values
  missing_values <- matrix(nrow = ncol(df_d), ncol = 2) 
  for (i in seq_along(df_d)) {            # 2. sequence
    missing_values[i,1] <- sum(is.na(df_d[i]))
    missing_values[i,2] <- colnames(df_d[i])
  }
  missing_values
  
  
# 4. code dummies to use in regression

  # right-wing populist voster dummy
  df_d <- df_d %>%
    mutate(right_wing_voter = NA,
           right_wing_voter = replace(right_wing_voter, prtvede1 == "Alternative for Germany (AFD)", 1),
           right_wing_voter = replace(right_wing_voter, prtvede2 == "Alternative for Germany (AFD)", 1),
           right_wing_voter = replace(right_wing_voter, is.na(right_wing_voter) == TRUE, 0),
    )
  
  # income below or above median dummy
  df_d <- df_d %>%
    mutate(income_above_median = NA,
           income_above_median = replace(income_above_median, hinctnta == "J - 1st decile", 0),
           income_above_median = replace(income_above_median, hinctnta == "R - 2nd decile", 0),
           income_above_median = replace(income_above_median, hinctnta == "C - 3rd decile", 0),
           income_above_median = replace(income_above_median, hinctnta == "F - 5th decile", 0),
           income_above_median = replace(income_above_median, hinctnta == "M - 4th decile", 0),
           income_above_median = replace(income_above_median, hinctnta == "S - 6th decile", 1),
           income_above_median = replace(income_above_median, hinctnta == "K - 7th decile", 1),
           income_above_median = replace(income_above_median, hinctnta == "P - 8th decile", 1),
           income_above_median = replace(income_above_median, hinctnta == "D - 9th decile", 1),
           income_above_median = replace(income_above_median, hinctnta == "H - 10th decile", 1),
           income_above_median = replace(income_above_median, is.na(income_above_median) == TRUE, 0), # add missing ones to base category
    )
  summary(df_d$income_above_median) # roughly right, missing ones slightly screw it up
  
  # above 35 years old
  df_d <- df_d %>%
    mutate(above_35_yrs = NA,
           above_35_yrs = replace(above_35_yrs, agea >= 35, 1),
           above_35_yrs = replace(above_35_yrs, agea < 35, 0),
           above_35_yrs = replace(above_35_yrs, is.na(above_35_yrs) == TRUE, 0), # add missing to base
    )
  summary(df_d$above_35_yrs) 
  
  # attended college dummy
  df_d <- df_d %>%
    mutate(attended_college = NA,
           attended_college = replace(attended_college, eduade2 == "Kein Studienabschluss", 0),
           attended_college = replace(attended_college, eduade2 != "Kein Studienabschluss", 1),
           attended_college = replace(attended_college, is.na(attended_college) == TRUE, 0), # add missing to base
    )
  summary(df_d$attended_college)
  
  # lives in a village dummy
  df_d <- df_d %>%
    mutate(lives_village = NA,
           lives_village = replace(lives_village, domicil == "Country village", 1),
           lives_village = replace(lives_village, domicil == "Farm or home in countryside", 1),
           lives_village = replace(lives_village, lives_village != 1, 0),
           lives_village = replace(lives_village, is.na(lives_village) == TRUE, 0), # add missing to base
    )
  summary(df_d$lives_village) #
  
  # consider themselves religious dummy
  df_d <- df_d %>%
    mutate(religious = NA,
           religious = replace(religious, rlgdgr == "4" | rlgdgr == "3" | rlgdgr == "2" | rlgdgr == "1" | rlgdgr == "Not at all religious", 0),
           religious = replace(religious, rlgdgr == "6" | rlgdgr == "7" | rlgdgr == "8" | rlgdgr == "9" | rlgdgr == "Very religious", 1),
           religious = replace(religious, is.na(religious) == TRUE, 0), # add missing to base
    )
  summary(df_d$religious) 

  
  # "migration background" self or father or mother born outside germany
  df_d <- df_d %>%
    mutate(migration_background = NA,
           migration_background = replace(migration_background, brncntr == "No" | facntr == "No" | mocntr == "No", 1),
           migration_background = replace(migration_background, is.na(migration_background) == TRUE, 0), # add missing to base
    )
  summary(df_d$migration_background) 
  
  # gender - is male
  df_d <- df_d %>%
    mutate(is_male = NA,
           is_male = replace(is_male, gndr == "Male", 1),
           is_male = replace(is_male, is.na(is_male) == TRUE, 0), # add missing to base
    )
  summary(df_d$is_male) 
   
  # married or ever married - dummy
  df_d <- df_d %>%
    mutate(married = NA,
           married = replace(married, evmar == "Yes", 1),
           married = replace(married, evmar == "No", 0),
           married = replace(married, is.na(married) == TRUE, 1), 
    )
  summary(df_d$married) 
  
  # demographic (d) variablies to keep for regression (r)
  df_d_r <- df_d %>%
    select(right_wing_voter, is_male, income_above_median, above_35_yrs, attended_college, lives_village, religious, migration_background, married, dweight)
  
  # summary stats
  summary(df_d_r)
    
  # save data
  write.csv(df_d_r, file = "clean_data/18_germany_demographics.csv",row.names=FALSE)
  