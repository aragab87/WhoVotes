cat("\014")
# code4policy

# CHANGE DIRECTORY HERE
setwd("")
# As we are not allowed to make the data public, we keep the data
# on a private Dropbox

library(tidyverse)
library(foreign)

# input Stata file
df <- read.dta("18_germany.dta")

