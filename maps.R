library(ggplot2)
library(dplyr)
library(maps)
library(ggmap)

#2
?map_data
states_map=map_data("state")

#3
class(states_map)

#4
head(states_map,3)

#5
ggplot(states_map,aes(x=long,y=lat))+geom_point()

#6
ggplot(states_map,aes(x=long,y=lat,group=group))+geom_polygon(fill="white",color="black")

#7
world_map=map_data("world")

#8
ggplot(world_map,aes(x=long,y=lat,group=group))+geom_polygon(fill="white",color="black")

#9
Lithuania= map_data("world",region="Lithuania")

ggplot(Lithuania,aes(x=long,y=lat,group=group))+geom_polygon(fill="white",color="black")

#10
head(world_map)
countries=world_map %>% distinct(region) %>% arrange(region)
countries

#11
far_east=map_data("world",region=c("Japan","China","North Korea","South Korea"))
ggplot(far_east,aes(x=long,y=lat,group=group))+geom_polygon(fill="white",color="black")

#####################

#1
head(USArrests)

#2
crimes=data.frame(state=tolower(rownames(USArrests)),USArrests)
head(crimes,3)
?tolower

#3
?full_join
?merge
crime_map=merge(states_map,crimes,by.x="region",by.y = "state", all.x = T)
head(crime_map)

#4
crime_map=arrange(crime_map,group,order)

#5
ggplot(crime_map,aes(x=long,y=lat,group=group,fill=Assault))+geom_polygon(color="black")+scale_fill_gradient2(low="white",high="Darkred")

#6
ggplot(crime_map,aes(x=long,y=lat,group=group,fill=Assault))+geom_polygon(color="black")+scale_fill_gradient2(low="white",high="Darkred")

#7
