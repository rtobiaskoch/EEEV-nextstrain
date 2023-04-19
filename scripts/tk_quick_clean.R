#quick clean for nextstrain

pacman::p_load("dplyr", "stringr", "tidyr", "readr")

d = read.csv('data/study_dataset.csv')



#code below currently not necessary Verity did this
d2 = d %>%
  mutate(state = stringr::str_replace(state,"_", " ")) %>% # remove _ for geo matching in nextstrain
  mutate(date = dplyr::if_else(str_count(date) == 0, #if date is blank
                               paste0(year, "-XX-XX"), #combine yera plus -XX-XX for nextstrain
                               date))                   # else keep the same

#write.csv(d2, "study_dataset2.csv")



#countries 
gps = read.csv("data/statelatlong.csv") %>% #pull in lat long to sort by north to south
  rename(state = City) #make merging easier

color = read.csv("data/palette.csv")

state = d %>% distinct(state) %>%
  left_join(gps, by = "state") %>%
  drop_na() %>%
  arrange(Latitude) %>%
  cbind(color) %>%
  mutate(x = "state") %>%
  select(x, state, colors)

write_delim(state, "config/colors.tsv", delim = "\t", col_names = F)
  


