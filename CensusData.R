# Before we begin you'll want to create an R file with the path to the directory where your train data is stored and then the name of the csv file of train data
# as well as the api key from the US Census

# ROOT<-"Path/to/your/working/directory"
# data<-"name_of_your_csv_file.csv"


library(tidycensus)
library(tidyverse)
library(lubridate)
# must recieve API Key from website
# census_api_key("c17fb3951852779e8175245f8e672c30c56185cd", install = TRUE)

# load a variable dictionary for census data

INCCOUNTY2011<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2011)
INCCOUNTY2012<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2012)
INCCOUNTY2013<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2013)
INCCOUNTY2014<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2014)
INCCOUNTY2015<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2015)
INCCOUNTY2016<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2016)
INCCOUNTY2017<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2017)
INCCOUNTY2018<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2018)
INCCOUNTY2019<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2019)
INCCOUNTY2020<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2020)
INCCOUNTY2021<-get_acs(geography = "county", variables = "B06011_001", geometry = TRUE, year = 2021)
#sweet. now I need a function that will select the right variable name from the corresponding year so I can create a median income series.

trains<-read.csv(paste0(ROOT,data))


#We need a list of the unique county, state combos in the train data set so we can pare down the Census data for the merge.

acc_county_list<-trains%>%
  mutate(County.Name = str_to_title(str_to_lower(County.Name)),
         State.Name = str_to_title(str_to_lower(State.Name)),
         COUNTY_STATE = paste(County.Name,State.Name,sep = ', '),
         YEAR = year(mdy_hms(Date)))%>%
  distinct(COUNTY_STATE)%>%
  mutate(COUNTY_STATE = str_replace_na(COUNTY_STATE,"Unknown"))%>%
  mutate(COUNTY_STATE = str_replace(COUNTY_STATE,","," County,"))

list(acc_county_list$COUNTY_STATE)

# ok now we need to bind the rows of our census data and use dplyr's inner_join function to only select census 
# data for the counties in our trains data set
