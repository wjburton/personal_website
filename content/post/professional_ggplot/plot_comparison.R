
library(tidyverse)
library(ggthemes)


#Apply this to the top of your script and all plots use your theme
#theme_set(theme_classic(base_size = 16)) 


# Time Series Plot
df <- read_csv('datatest.csv')
df <- df %>% 
  mutate(time_of_day = lubridate::mdy_hm(date))

#base ggplot
df %>%
ggplot(aes(x = time_of_day, y = Temperature)) + geom_line() + ggtitle('Daily Temperature Fluctuation') + xlab('Time') +ylab('Degrees Celcius')

#Existing Themes
# Theme_bw
df %>%
  ggplot(aes(x = time_of_day, y = Temperature)) +
  geom_line() +
  ggtitle('Daily Temperature Fluctuation') +
  xlab('Time') +
  ylab('Degrees Celcius') +
  theme_bw()

#Theme_classic
df %>%
 ggplot(aes(x = time_of_day, y = Temperature)) +
 geom_line() +
 ggtitle('Daily Temperature Fluctuation') +
 xlab('Time') +
 ylab('Degrees Celcius') +
 theme_classic()


#Theme_minimal
df %>%
  ggplot(aes(x = time_of_day, y = Temperature)) +
  geom_line() +
  ggtitle('Daily Temperature Fluctuation') +
  xlab('Time') +
  ylab('Degrees Celcius') +
  theme_minimal()

#Theme Tufte
df %>%
  ggplot(aes(x = time_of_day, y = Temperature)) +
  geom_line() +
  ggtitle('Daily Temperature Fluctuation') +
  xlab('Time') +
  ylab('Degrees Celcius') +
  theme_tufte()

#Theme Five Thirty Eight
df %>%
  ggplot(aes(x = time_of_day, y = Temperature)) +
  geom_line() +
  ggtitle('Daily Temperature Fluctuation') +
  xlab('Time') +
  ylab('Degrees Celcius') +
  theme_fivethirtyeight()

#CK theme
df %>%
  ggplot(aes(x = time_of_day, y = Temperature)) +
  geom_line() +
  ggtitle('Daily Temperature Fluctuation') +
  xlab('Time') +
  ylab('Degrees Celcius') +
  ck_theme() + scale_color_ck()

ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
  geom_point(size = 4) +
  scale_color_ck()
# Why do none of these by default center the title? Is that an add on within the theme?

scale_x_date(date_labels = "%b/%d")


# Create Credit Karma Color Palette



ck_palettes <- list(
  `main`  = ck_cols("Sky", "Pacific", "Zinfandel", "Electric Violet", "Iris", "Bay Mist")
  #`cool` = ck_cols("blue", "green"),
)

ck_pal <- function(palette = "main", reverse = FALSE, ...) {
  pal <- ck_palettes[[palette]]
  
  if (reverse) pal <- rev(pal)
  
  colorRampPalette(pal, ...)
}


scale_color_ck <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- ck_pal(palette = palette, reverse = reverse)
  
  if (discrete) {
    discrete_scale("colour", paste0("ck_", palette), palette = pal, ...)
  } else {
    scale_color_gradientn(colours = pal(256), ...)
  }
}

scale_fill_ck <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- ck_pal(palette = palette, reverse = reverse)
  
  if (discrete) {
    discrete_scale("fill", paste0("ck_", palette), palette = pal, ...)
  } else {
    scale_fill_gradientn(colours = pal(256), ...)
  }
}


# Bar plot
library(hrbrthemes)
library(gcookbook)

library(tidyverse)

ggplot(mtcars, aes(mpg, wt)) +
  geom_point() +
  labs(x="Fuel efficiency (mpg)", y="Weight (tons)",
       title="Seminal ggplot2 scatterplot example",
       subtitle="A plot that is only useful for demonstration purposes",
       caption="Brought to you by the letter 'g'") + 
  theme_ipsum()


library(ggthemes)

# Histogram

lubridate::as_date()



ck_theme <- function() {
  theme(
    # add border 1)
    # panel.border = element_rect(colour = "blue", fill = NA, linetype = 2),
    # color background 2)
     panel.background = element_rect(fill = "white"),
    # modify grid 3)
    #panel.grid.major.x = element_line(colour = "steelblue", linetype = 3, size = 0.5),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y =  element_line(colour = "grey", linetype = 3, size = 0.5),
    panel.grid.minor.y = element_blank(),
    # modify text, axis and colour 4) and 5)
    axis.text = element_text(colour = "grey", face = "italic", family = "Times New Roman"),
    axis.title = element_text(colour = "grey", family = "Times New Roman"),
    axis.ticks = element_line(colour = "grey"),
    # legend at the bottom 6)
    legend.position = "bottom"
  )
}

