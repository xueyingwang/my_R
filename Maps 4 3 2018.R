

# Making a Map with a Clean Backgroud

To remove the background elements from a ggplot graph, we will be using a new theme. 

```{r}

# add theme

theme_clean <- function(base_size = 12){
  require(grid) #needed for unit() function
  theme_grey(base_size) %+replace%
    theme(
      axis.title = element_blank(),
      axis.text = element_blank(),
      panel.background = element_blank(),
      panel.grid = element_blank(),
      axis.ticks.length = unit(0, "cm"),
      axis.ticks.margin =  unit(0, "cm"), 
      panel.margin =  unit(0, "lines"), 
      plot.margin =  unit(c(0,0,0,0), "lines"),
      complete = TRUE
    )
}

# Case Study: Crime Data in Houston

We will look at the `crime` dataset which is part of the `ggmap` R package. It has Houston crime from January 2010 to August 2010. Note that the original data that was compiled by the Houston Police Department was messy and then cleaned used `dplyr` R package and geocoded using Google Maps.

Let's plot Houston's map: 
  
  ```{r}

qmap("Houston", zoom = 14)

```

### Focusing on violent crimes in downtown area

Let's focus on the violent crimes ("aggravated assault", "murder", "rape", "robbery") in the downtown area in Houston. First let's define the area using the `gglocator()` function to determine a bounding box. This is an interactive function, and you have to click on the plot to get output. 

```{r}

# find a reasonable spatial extent for the downtown

## notice that i did not want to evalute gglocator() becuase it is interactive
#gglocator(2)

#lonlat <- gglocator(2)

# focus on downtown area
library(dplyr)
dt_crimes <- filter(crime, 
                    lon >= -95.39681 & lon <= -95.34188 &
                      lat >= 29.73631 & lat <= 29.78400)

```

Next, let's subset the dataset to include only the violent crimes: 

```{r}

# only violent crimes
violent_crimes <- filter(dt_crimes, 
offense %in% c("aggravated assault", "murder", "rape", "robbery"))

levels(violent_crimes$offense)

#reorder levels of violent crimes by violence level

violent_crimes$offense <- factor(violent_crimes$offense, 
levels = c("robbery", "aggravated assault", "rape", "murder"))

```

### Look at how the crimes are distributed in Houston 

First, we can have a bubble chart on top of the map. 

```{r}

## save the map in a variable, so we don't have to download it everytime!
  
  HoustonMap <- qmap("Houston", zoom = 14, color = "bw", legend = "topleft")

## add the bubble plot layer using geom_point()

HoustonMap + 
  geom_point(data = violent_crimes, 
             aes(x = lon, y = lat, color = offense, size = offense))

```

One of the main problems in bubble charts is overplotting. One way around this, is to bin the points and drop the bins which don't have any samples in them: 

```{r}

HoustonMap + 
stat_bin2d(data = violent_crimes, 
aes(x = lon, y = lat, fill = offense), 
bins = 30, alpha = 0.5) 

#bins: the number of horizontal and vertical bins

```

### Looking at the violent crimes during the week

If we neglect the type of offense, we can get a good idea of the spatial distribution of violent crimes by using contour plots. Notice the use of `..level..`. This is because `.. ..` is used because the aesthetic (in this case, the levels of the contours) is not present in the original dataset, but instead is calculated by the contour statistic.

```{r}

houston <- get_map(location = "houston", zoom = 14, color = "bw")
HoustonMap <- ggmap(houston)


HoustonMap + 
stat_density2d(data = violent_crimes, 
aes(x= lon, y = lat, fill = ..level.., alpha = ..level..),
geom = "polygon") + 
scale_fill_gradient(low= "white", high = "#bd0026") + 
facet_wrap(~day, nrow = 2) +   
theme(plot.title = element_text(hjust = 0.5),
legend.position = 'none',
plot.margin = unit(c(.5,0,0,0),"cm"))

```




























