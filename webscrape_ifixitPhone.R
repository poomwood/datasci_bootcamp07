library(rvest)
library(tidyverse)

# Select url
ifixit_phone_url <- "https://www.ifixit.com/smartphone-repairability"

# Pull all data from the table. Shitty format. To be used to extract phone's brand name because there is no html_elements to pull from. 
phone_all <- ifixit_phone_url %>%
  read_html() %>%
  html_elements("div.row") %>%
  html_text2() # Text = pull uncleaned data, text2 = remove unnecessary characters 

glimpse(phone_all) # the list has 264 rows! (duplicates)

# Create a dataframe. Insert row id for the dataframe.
phone_all <- data.frame(
  id = 1:264,
  phone_all) %>%
  rename(all_string = phone_all) #change column name
  

# Extract rows with phone's brand name value (Odd rows)
phone_all_brandrow <- phone_all %>%
  filter(id %% 2 != 0)

view(phone_all_brandrow)

# Extract phone's brand name only and put it in a new column >> using word() function
phone_all_brandrow$brand <- word(phone_all_brandrow$all_string, 1)

# Create a new dataframe that remove the messy string
phone_brand <- phone_all_brandrow[,c("brand")] #remove messy string (2nd column) and useless id (1st column) ~ it does not give id in order

# Pull phone model
phone_model <- ifixit_phone_url %>%
  read_html() %>%
  html_elements("span.selected") %>%
  html_text2() #text = pull uncleaned data, text2 = remove unnecessary characters 

# Pull ifixit score
phone_score <- ifixit_phone_url %>%
  read_html() %>%
  html_elements("h3") %>%
  html_text2() #text = pull uncleaned data, text2 = remove unnecessary characters 

# PUll ifixit's assessment result (1st one ONLY)
phone_assess <- ifixit_phone_url %>%
  read_html() %>%
  html_elements("ul") %>%
  html_text2() #text = pull uncleaned data, text2 = remove unnecessary characters 

glimpse(phone_assess) # the list has 264 rows! (duplicates)

# Remove duplicates the same way as phone_brand
phone_assess <- data.frame(
  id = 1:264,
  phone_assess) %>%
  filter(id %% 2 != 0)

# Create a new dataframe that remove the messy string
phone_assess <- phone_assess[,c("phone_assess")] #remove messy string (2nd column) and useless id (1st column) ~ it does not give id in order

# Check for same amount of rows and compare if the order of data is correct with the website >> Same!
glimpse(phone_assess)
head(phone_assess,10)
tail(phone_assess,10)

# Join 4 data frames together!
ifixit_phone <- data.frame(
  id = 1:132,
  phone_brand, # already a dataframe
  phone_model, # a list
  phone_score, # a list
  phone_assess) %>% # a list
  rename("model" = phone_model,
         "ifixit_score" = phone_score,
         "detail" = phone_assess
  )

view(ifixit_phone) # There are duplicated column; two "id" columns

write.csv(ifixit_phone, "ifixit_phone.csv") #create csv file of the data frame
