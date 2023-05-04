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


#first we'll make a list of all the INCCOUNTY data frames

df_list<-list(
  INCCOUNTY2011,
  INCCOUNTY2012,
  INCCOUNTY2013,
  INCCOUNTY2014,
  INCCOUNTY2015,
  INCCOUNTY2016,
  INCCOUNTY2017,
  INCCOUNTY2018,
  INCCOUNTY2019,
  INCCOUNTY2020,
  INCCOUNTY2021)

inc_county<-bind_rows(df_list,.id = "year")%>% # creating the full county-level income 
                                               # data from the census including the year as an ID
  mutate(year = as.numeric(str_extract(year, "\\d+")) + 2010)

#then we need to import the train accident data and 
# and create a list of counties where train accidents occured

trains<-read.csv(paste0(ROOT,data)) #import the trains data


#We need a list of the unique county, state combos in the train data set so we can pare down 
#the Census data for the merge.

trains<-trains%>%
  mutate(County.Name = str_to_title(str_to_lower(County.Name)),
         State.Name = str_to_title(str_to_lower(State.Name)),
         COUNTY_STATE = paste(County.Name,State.Name,sep = ', '),
         YEAR = as.numeric(year(mdy_hms(Date))))%>%
  mutate(COUNTY_STATE = str_replace_na(COUNTY_STATE,"Unknown"))%>%
  mutate(COUNTY_STATE = str_replace(COUNTY_STATE,","," County,"))

accident_county_income<-inc_county%>%
  dplyr::select(year,
                NAME,
                estimate,
                geometry)%>%
  left_join(trains, by = c("year" = "YEAR",
                            "NAME" = "COUNTY_STATE"))

model_data<-accident_county_income%>%
  dplyr::select(estimate,
                Hazmat.Cars,
                Hazmat.Cars.Damaged,
                Persons.Evacuated,
                Station,
                Milepost,
                NAME,
                Temperature,
                Visibility,
                Weather.Condition,
                Track.Type,
                Track.Density,
                Accident.Number)%>%
  mutate(estimate = as.numeric(estimate))

#specifying logistic model on whether or not an accident occurs in that county based on income

logist_reg<-lm(!is.na(Accident.Number)~estimate,data = model_data,na.rm = T)
  
med_inc_effect<-coef(logist_reg)['estimate']

exp(med_inc_effect)/(1+exp(med_inc_effect))
# ok now we need to bind the rows of our census data and use dplyr's inner_join function to only select census 
# data for the counties in our trains data set

#well that's kind of unsatisfying. it's basically a statistically significant coin flip.

# trying the same model with log coefficients

log_log<-lm(!is.na(Accident.Number)~log(estimate),data = model_data,na.rm = T)
percent_inc_effect<-coef(log_log)["log(estimate)"]
exp(percent_inc_effect)/(1+exp(percent_inc_effect))
