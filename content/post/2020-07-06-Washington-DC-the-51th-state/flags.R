library(units)
library(dplyr)
library(ggplot2)
library(patchwork)

old_glory_blue <- "#3C3B6E"
old_glory_red <- "#B22234"
white <- "#FFFFFF"

pentagon_coordinates <- function(r=1, n=1){
  sapply(1:(5*n), function(i){
    theta <- set_units(18 + (72/n)*(i-1), "degrees") %>%
      set_units("radians")
    c(x=round(r*cos(theta), 6), y=round(r*sin(theta), 6))
  }) %>%
    t() %>%
    as.data.frame()
}

stars_51 <- function() {
  df <- data.frame(x=0,y=0) %>%
    bind_rows(pentagon_coordinates(r=1, n=1)) %>%
    bind_rows(pentagon_coordinates(r=2, n=2)) %>%
    bind_rows(pentagon_coordinates(r=3, n=3)) %>%
    bind_rows(pentagon_coordinates(r=4, n=4))
  ggplot(df) +
    aes(x=x, y=y) +
    geom_text(label="\U2605", aes(size=9),
              family="", color = white) +
    theme_void() +
    coord_fixed() +
    theme(legend.position = "none",
          plot.background =
            element_rect(fill = old_glory_blue, color = old_glory_blue),
          panel.grid = element_blank(),
          panel.border = element_blank())
}

bars_top <- function(){
  df <- data.frame(ymin=seq(from=0, by=3/16, length.out = 7),
                   ymax=seq(from=3/16, by=3/16, length.out = 7),
                   xmin=0,
                   xmax=16/7,
                   color=factor(c(1,0,1,0,1,0,1)))
  ggplot(df) +
    geom_rect(aes(ymin=ymin, ymax=ymax, xmin=xmin, xmax=xmax, fill=color)) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_fill_manual(values = c("1" = old_glory_red, "0" = white)) +
    theme_void() +
    theme(legend.position = "none",
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank())
}

bars_bottom <- function(){
  df <- data.frame(ymin=seq(from=0, by=3/16, length.out = 6),
                   ymax=seq(from=3/16, by=3/16, length.out = 6),
                   xmin=0,
                   xmax=5,
                   color=factor(c(1,0,1,0,1,0)))
  ggplot(df) +
    geom_rect(aes(ymin=ymin, ymax=ymax, xmin=xmin, xmax=xmax, fill=color)) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_fill_manual(values = c("1" = old_glory_red, "0" = white)) +
    theme_void() +
    theme(legend.position = "none",
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank())
}

flag_51 <- (stars_51() | bars_top()) / bars_bottom() + plot_layout(heights = 0.1)
