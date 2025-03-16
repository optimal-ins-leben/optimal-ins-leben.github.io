################################################################################
## Transcribe audio
################################################################################

library(readr)
library(dplyr)
library(audio.whisper)
library(purrr)
df <- read_csv("df.csv")


model <- whisper("medium")


df |> 
  mutate(i = row_number()) |> 
  arrange(desc(i)) |> 
  select(wav, trans) |> 
  pmap(\(wav,trans){
  transkript <- predict(model, newdata = wav, language = "de",n_threads = 16)  
  
  saveRDS(transkript, file = trans)
}, .progress = TRUE)


