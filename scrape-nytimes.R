library(tidyverse)
library(rvest)
library(RSelenium)
library(glue)
library(beepr)

internet <- RSelenium::rsDriver(browser = 'firefox')
remDr <- internet[["client"]]


restaurant_matrix <- 
  crossing(restaurant_quality = factor(levels = c("EXTRAORDINARY", "EXCELLENT", "VERY_GOOD", "GOOD"), ordered = T),
           restaurant_price = factor(levels = c("INEXPENSIVE", "MODERATE", "EXPENSIVE", "VERY_EXPENSIVE"), ordered = T)
  )


scrape_nytimes <- function(quality, price){
  ## open webpage -----------------------------------
  directory <- glue("https://www.nytimes.com/reviews/dining/rating-{quality}/price-{price}")
  remDr$navigate(directory)
  Sys.sleep(time = 2)
  
  ## loop through "show more" -----------------------------------
  show_more <- try(remDr$findElement(using = 'css selector',"#reviews button"), silent = T)
  
  while(try(show_more$getElementText()[[1]], silent = T) == "SHOW MORE"){
    show_more$clickElement()
    show_more <- try(remDr$findElement(using = 'css selector',"#reviews button"), silent = T)
    Sys.sleep(time = .3)
  }
  beepr::beep(sound = 2)
  
  ## scrape reviews -----------------------------------
  webElem <- remDr$findElement("css", "body")
  webElem$sendKeysToElement(list(key = "end"))
  Sys.sleep(time = .5)
  get_reviews <- remDr$getPageSource()
  
  
  tibble(
    name = read_html(get_reviews[[1]]) %>% 
      html_nodes(css = ".css-8aqwnr") %>% 
      html_text(),
    
    extra_info = read_html(get_reviews[[1]]) %>% 
      html_nodes(css = ".css-o4kdzz") %>% 
      html_text() 
  )
}


good_restaurants <- 
  restaurant_matrix %>% 
  mutate(restaurant_quality = fct_rev(restaurant_quality)) %>%
  mutate(ratings = map2(.x = restaurant_quality, 
                        .y = restaurant_price, 
                        .f = ~scrape_nytimes(quality = .x, price = .y)))



good_restaurants %>% 
  unnest(ratings) %>% 
  mutate(nytimes_critics_pick = str_detect(extra_info, "NYT Critic’s Pick"),
         cuisine = str_match(extra_info, "star(.*?)\\$")[,2],
         location = str_match(extra_info, "\\$(.*?)$")[,2],
         location = str_remove_all(location, "\\$")) %>% 
  write_csv("nytimes-restaurant-reviews.csv")