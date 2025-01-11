


library(dplyr)
library(readr)
library(purrr)
library(stringr)
df <- read_csv("df.csv")




library(httr)
library(jsonlite)

# Define the endpoint
url <- "http://localhost:1234/api/v0/chat/completions"


df$trans_2 <- file.path("trans_2",paste0(df$guids, ".json"))


df


df |> 
  select(guids, transkript, trans_2) |> 
  # head(2) |> 
  pmap(\(guids, transkript, trans_2){
    
  
  

# Define the payload
payload <- list(
  model = "phi-4",
  messages = list(
    list(role = "system", content = "Clean, rephrase and reformat format the following Podcast transcript, which is written in German."),
    list(role = "user", content = transkript)
  ),
  temperature = 0.8,
  max_tokens = -1,
  stream = FALSE
)

# Make the POST request
response <- POST(
  url,
  add_headers(`Content-Type` = "application/json"),
  body = toJSON(payload, auto_unbox = TRUE)
)

# Parse the response
content <- content(response, "text", encoding = "UTF-8")
cat(content)

content2 <- jsonlite::fromJSON(content)

jsonlite::write_json(content2, trans_2)


  }, .progress = TRUE)
