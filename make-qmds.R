

library(dplyr)
library(readr)
library(purrr)
library(stringr)
df <- read_csv("df.csv")




################################################################################
## Clean transcriptions
################################################################################


df$transkript <- map_chr(df$trans, \(x){
  paste(readRDS(x)$data$text, collapse = "")
})

df$qmd <- file.path(paste0(df$guids, ".qmd"))



df |> 
  transmute(titles = str_remove_all(titles, ":"), pubDates, guids, description, transkript, qmd) |> 
  pmap(\(titles, pubDates, guids, description, transkript, qmd){
    quarto::quarto_render(
      "template.qmd",
      output_file = qmd, 
      metadata = list(title = titles, date = pubDates),
      output_format = "markdown",
      execute_params = NULL #list(transkript = transkript
      )
    
    destfile <- file.path("qmds",qmd)
    if(file.exists(destfile))file.remove(destfile)
    file.copy(qmd, destfile)
    file.remove(qmd)
    
    cat(transkript, file=destfile, append=TRUE)
  }, .progress = TRUE)


