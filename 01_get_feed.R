library(xml2)
library(rvest)


################################################################################
## Get Feed Data
################################################################################


rss <- xml2::read_xml("https://lisastolzlechner.libsyn.com/rss")


items <- rss |> 
  rvest::xml_node("channel") |> 
  html_elements("item")

titles <- items |> 
  html_elements("title") |> 
  xml_text()

pubDates <- items |> 
  html_elements("pubDate") |> 
  xml_text()

guids <- items |> 
  html_elements("guid") |> 
  xml_text()


urls <- items |> 
  html_elements("enclosure") |> 
  xml_attr("url")

description <- items |> 
  html_elements("description") |> 
  html_text()


df <- tibble(titles, pubDates, guids, urls, description)


df$destfile <- file.path("mp3",paste0(df$guids, ".mp3"))
df$wav <- file.path("wav",paste0(df$guids, ".wav"))
df$trans <- file.path("trans",paste0(df$guids, ".rds"))


write_csv(df, "df.csv")

