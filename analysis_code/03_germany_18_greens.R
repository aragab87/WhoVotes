cat("\014")
# code4policy


  # to do:
  # add 

# CHANGE DIRECTORY HERE
setwd("/Users/lucaskitzmueller/Dropbox/code4policy_data/")
# As we are not allowed to make the data public, we keep the data
# on a private Dropbox

# libraries
library(readr)
library(tidyverse)

# load data
df <- read_csv("clean_data/18_germany_demographics_greens.csv")

# Specify model

  outcome <- "green_voter"
  regressors <- colnames(df)
  
  regressors <- regressors[-1]
  regressors <- regressors[-length(regressors)]

  f <- as.formula(
    paste(outcome, 
          paste(regressors, collapse = " + "), 
          sep = " ~ ")
    )
    print(f)

# fit model
  base_model <- lm(f, data = df[,0:10], weights = dweight)
  summary(base_model)
  