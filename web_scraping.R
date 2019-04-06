library(dplyr)
library(stringr)
library(readr)
library(rvest)

# Scraping Data Stok Beras
url_stock <- "http://www.foodstation.co.id/beras/stockberas/inc/get_stock_beras.php?idbulan=04"

stock_pg <- url_stock %>% 
  read_html()

stock_pg %>% glimpse() # or str(stock_pg)
stock_pg

stock_pg <- url_stock %>% 
  read_html() %>% 
  html_table()

stock_pg %>% glimpse()

stock_pg <- url_stock %>% 
  read_html() %>% 
  html_table() %>% 
  .[[1]] %>% 
  glimpse()

View(stock_pg)

stock_tbl <- stock_pg %>% 
  slice(3:n())

stock_tbl[,2] <- stock_tbl[,2] %>% 
  str_replace(pattern = ",", replacement = "") %>% 
  as.numeric()

stock_tbl[,3] <- stock_tbl[,3] %>% 
  str_replace(pattern = ",", replacement = "") %>% 
  as.numeric()

stock_tbl[,4] <- stock_tbl[,4] %>% 
  str_replace(pattern = ",", replacement = "") %>% 
  as.numeric()

stock_tbl[,5] <- stock_tbl[,5] %>% 
  str_replace(pattern = ",", replacement = "") %>% 
  as.numeric()

stock_tbl[,6] <- stock_tbl[,6] %>% 
  str_replace(pattern = ",", replacement = "") %>% 
  as.numeric()

colnames(stock_tbl)
colnames(stock_tbl) <- str_replace(string = stock_pg[2,], pattern = " ", replacement = "")
str(stock_tbl)

write_csv(stock_tbl, "web_scraping/stock_tbl.csv")


# Scraping Data Harga Beras
url_harga <- "http://www.foodstation.co.id/beras/inc/get_harga_beras.php"
param <- list("tgl" = "01-01-2019",
             "tgl2" = "31-01-2019")

library(httr)
harga_pg <- url_harga %>% 
  POST(body = param) %>% 
  read_html() %>% 
  html_table() %>% 
  .[[1]] %>% 
  glimpse()

head(harga_pg)
glimpse(harga_pg)

harga_tbl <- harga_pg %>% 
  slice(3:n()) %>% 
  glimpse()

for(i in 2:15){
  harga_tbl[,i] <- harga_tbl[,i] %>% 
    str_replace(pattern = ",", replacement = "") %>% 
    as.numeric()
}

colnames(harga_tbl)
colnames(harga_tbl) <- str_replace_all(harga_pg[2,], pattern = "[- ]", replacement = "")
harga_tbl %>% head()
