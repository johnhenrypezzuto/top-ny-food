# Top Food in New York
Top rated restaurants with delivery to eat in during a pandemic. Includes lists scraped from the [New York Times](https://www.nytimes.com/reviews/dining) and [The Infatuation](https://www.theinfatuation.com/new-york/reviews?sort=rating&page=1). 

Cross referenced with Google Maps API to find location coordinates and Yelp api to find delivery status.

There are some duplicates / mistakes in the repo particularly in the coordinate data. These are minimal.

## Get the data here
```
nytimes <- readr::read_csv('https://raw.githubusercontent.com/**.csv')
the_infatuation <- readr::read_csv('https://raw.githubusercontent.com/**.csv')
```
