#Playing around with train data

library(tidyverse)
library(stats)

trains<-read.csv(paste0(ROOT, data))
trains<-trains%>%
  dplyr::select(Accident.Number,
                Date,
                Time,
                Reporting.Railroad.Class,
                Reporting.Railroad.Code,
                Reporting.Railroad.Name,
                Other.Railroad.Name,
                Hazmat.Cars,
                Hazmat.Cars.Damaged,
                Persons.Evacuated)
  mutate(Date = as.Date(Date))

  
