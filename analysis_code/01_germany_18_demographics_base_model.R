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
  
# Calculate prediction based on coefficients and averages

  coeffs <- base_model$coefficients # save coefficients

  means <- colMeans(df) # save averages
  means <- means[-length(means)] # remove dweight
  
  #merge means and coeffs into one frame
  means_coeffs <- bind_rows(means, coeffs)
  means_coeffs <- t(means_coeffs) # transpose
  means_coeffs <- as_tibble(means_coeffs, rownames = NA)
  # View(means_coeffs)
  
  # get rid of outcome variable
  means_coeffs <- means_coeffs[-1,]
  
  # make "avg of intercept" 1
  means_coeffs[nrow(means_coeffs),1] <- 1

  # Multiply
  means_coeffs <- means_coeffs %>% mutate(multiple = V1 * V2)
  
  # Lower bound
  means_coeffs$low_bound <- NA
    
  for (i in 1:nrow(means_coeffs)) {
    print(i)
    before <- (i -1 )
    after <- (i + 1)
    print(before)
    print(after)
    means_coeffs$low_bound[i] <- sum(means_coeffs[1:before,3],means_coeffs[after:9,3])
  }
  
    
  

  
  
  
  avgs <- df %>%
    summarise(mean_attended_college = mean(attended_college),
              mean_religious = mean(religious)
              )
  
  
  
  
# testing a tree
  library(tree)
  
  df$right_wing_voter <- as.factor(df$right_wing_voter)
  
  tree_model       <- tree(f, 
                    data = df[,0:10],
                    weights = dweight)
  summary(tree_model)
  plot(tree_model)
  text(tree_model, pretty = 0)
  
