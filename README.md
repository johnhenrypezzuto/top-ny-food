# Top Food in New York
Are you a foodie locked indoors during the pandemic? This is a list of the top rated restaurants rated by the [New York Times](https://www.nytimes.com/reviews/dining) and the (nearly) full list of restaurants rated by the [The Infatuation](https://www.theinfatuation.com/new-york/reviews?sort=rating&page=1). 

Both maps were cross referenced with Google Maps API to find location coordinates and Yelp API to find **whether they deliver**. Analyze the data if you need something to do indoors or just use it to order food! Data is useful for making a list of restaurants to try :)

There are some duplicates / mistakes in the repo particularly in the coordinate data. These are minimal.

## Get the data here
```
nytimes <- readr::read_csv('https://raw.githubusercontent.com/johnhenrypezzuto/top-ny-food/master/nytimes-restaurant-reviews.csv')
the_infatuation <- readr::read_csv('https://raw.githubusercontent.com/johnhenrypezzuto/top-ny-food/master/the-infatuation-restaurants.csv')
```
