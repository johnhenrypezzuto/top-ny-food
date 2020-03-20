library(tidyverse)
library(rvest)
library(glue)
1:57
restaurant_list <- list()
page_number = 1
the_infatuation_restaurants <- function(page_number){
  s <- read_html(glue("https://www.theinfatuation.com/new-york/reviews?sort=rating-htl&page={page_number}"))

  page_info <- 
    tibble(
        name =
          s %>% 
          html_nodes("div.review-table__title") %>% 
          html_text(trim = T),
        
        rating =
        s %>% 
          html_nodes("#pagination-container .rating") %>% 
          html_text(trim = T) %>% 
          .[c(TRUE, FALSE)],
        
        price =
        s %>% 
          html_nodes(".large") %>% 
          html_attr("data-price")
        )

  restaurant_list[page_number] <- page_info
}

output <- map(1:57, the_infatuation_restaurants)
output_df <- bind_rows(output) %>% distinct(name, .keep_all = T) %>%  mutate(rating = as.numeric(rating))

output_df %>% write_csv("the-infatuation-restaurants.csv")


output_df %>%
  mutate(perc = percent_rank(rating)) %>% 
  ggplot(aes(rating)) +
  geom_histogram() +
  facet_wrap(~price)

