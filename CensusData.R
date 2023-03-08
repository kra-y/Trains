library(tidycensus)
library(tidyverse)
# must recieve API Key from website
# census_api_key("c17fb3951852779e8175245f8e672c30c56185cd", install = TRUE)

# load a variable dictionary for census data

V12<-load_variables(2012, "acs5", cache = TRUE)
V13<-load_variables(2013, "acs5", cache = TRUE)
V14<-load_variables(2014, "acs5", cache = TRUE)
V15<-load_variables(2015, "acs5", cache = TRUE)
V17<-load_variables(2016, "acs5", cache = TRUE)
V18<-load_variables(2017, "acs5", cache = TRUE)
V19<-load_variables(2018, "acs5", cache = TRUE)
V20<-load_variables(2019, "acs5", cache = TRUE)
V21<-load_variables(2020, "acs5", cache = TRUE)
V22<-load_variables(2021, "acs5", cache = TRUE)
V23<-load_variables(2022, "acs5", cache = TRUE)

INCZIP2020<-get_acs(geography = "zcta", variables = "B06011_001", geometry = TRUE, year = 2020)
 #sweet. now I need a function that will select the right variable name from the corresponding year so I can create a median income series.
