cat("\014")
# code4policy

# CHANGE DIRECTORY HERE
setwd("/Users/lucaskitzmueller/Dropbox/code4policy_data/")
# As we are not allowed to make the data public, we keep the data
# on a private Dropbox

# libraries
library(readr)

# load data
df <- read_csv("clean_data/18_germany_demographics.csv")

# Specify model

  outcome <- "right_wing_voter"
  regressors <- colnames(df)
  
  regressors <- variables[-1]
  regressors <- regressors[-length(regressors)]


  f <- as.formula(
    paste(outcome, 
          paste(variables, collapse = " + "), 
          sep = " ~ ")
    )
    print(f)

# fit model
    
  base_model <- lm(f, data = df[,0:10], weights = dweight)

  summary(base_model)


