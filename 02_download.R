
# remotes::install_github("bnosac/audio.whisper")
# install.packages("av")
library(dplyr)
library(purrr)
library(readr)




df <- read_csv("df.csv")




################################################################################
## Download MP3 Files
################################################################################


df |> 
  select(guids, urls, destfile) |> 
  pmap(\(guids, urls){
    download.file(urls, mode = "wb",destfile = destfile)
    Sys.sleep(1)
  }, .progress = TRUE)

################################################################################
## Convert to WAV Files
################################################################################


library(av)


map2(df$destfile, df$wav, \(x,y) av_audio_convert(audio = x,output = y, sample_rate = 16000, channels = 1, format = "wav"))


