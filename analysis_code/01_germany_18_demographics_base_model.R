cat("\014")
# code4policy

# This script estimates the model of voting for the AfD on demographics.

# CHANGE DIRECTORY HERE
setwd("/Users/lucaskitzmueller/Dropbox/code4policy_data/")
# As we are not allowed to make the data public, we keep the data
# on a private Dropbox

# libraries
library(readr)
library(tidyverse)

# load data
df <- read_csv("clean_data/18_germany_demographics.csv")

# Specify model

  outcome <- "right_wing_voter"
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
  
# Ouput model into csv
  # The following code is not efficient as we went through iterations
  # For example, we first add mean values to the output table and then delete it again
  # However, it does the job and I think is still understandable
  
  coeffs <- base_model$coefficients # save coefficients
  
  means <- colMeans(df) # save averages
  means <- means[-length(means)] # remove dweight
  
  #merge means and coeffs into one frame
  means_coeffs <- bind_rows(means, coeffs)
  means_coeffs <- t(means_coeffs) # transpose
  means_coeffs <- as_tibble(means_coeffs, rownames = NA)
  # View(means_coeffs)
  
  # rename columns
  names(means_coeffs) <- c("average", "coefficient")
  
  # multiply with 100 to get percentage points
  means_coeffs$coefficient <- means_coeffs$coefficient * 100
  
  # add a rounded value for displaying in text
  means_coeffs$coefficient_percent <- round(means_coeffs$coefficient, digits = 1)
  
  # Now follows some deactivated code as we decided to not work with averages multiplied with coefficients
    
  # get rid of outcome variable
  # means_coeffs <- means_coeffs[-1,]
  
  # make "avg of intercept" 1
  # eans_coeffs[nrow(means_coeffs),1] <- 1
  
  # Multiply
  # means_coeffs <- means_coeffs %>% mutate(multiple = V1 * V2)
  
  # ...
  
  # At this point I decided to make further changes in Excel
  # given our user stories
  # and that means_coeffs is such a small data frame 
  # and I will not replicate this analysis for other years or countries
  
  write.csv(means_coeffs, file = "~/Development/WhoVotes/output/18_germany_demographics_coefficients_and_average.csv",row.names=TRUE)
  
# testing a regression tree model
  
  library(tree)
  
  df$right_wing_voter <- as.factor(df$right_wing_voter)
  
  tree_model       <- tree(f, 
                           data = df[,0:10],
                           weights = dweight)
  summary(tree_model)
  plot(tree_model)
  text(tree_model, pretty = 0)
  
# End of Script
  
  

  
