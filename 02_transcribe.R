################################################################################
## Transcribe audio
################################################################################

library(readr)
library(dplyr)
library(audio.whisper)
library(purrr)
df <- read_csv("df.csv")


model <- whisper("large-v3")




map2(df$wav, df$trans, \(x,y){
  trans <- predict(model, newdata = x, language = "de",n_threads = 30)  
  
  saveRDS(trans, file = y)
}, .progress = TRUE)


