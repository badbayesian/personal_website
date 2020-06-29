library(ggplot2)
library(gganimate)
library(dplyr)

riddle_street_df <- function() {
  df <- expand.grid(x = seq(-5, 5), y = seq(-5, 5), time = 0:21)
  df$color <- 0
  df$x_prev <- df$x
  df$y_prev <- df$y
  
  mat <- matrix(0, nrow = 11, ncol = 2)
  direction <- 0
  for (i in 2:11) {
    move <- sample(c(-1, 1), 1)
    if (direction %in% c(0, 2)) {
      mat[i, 1] <- mat[i - 1, 1] + move
      mat[i, 2] <- mat[i - 1, 2] 
    } else {
      mat[i, 1] <- mat[i - 1, 1] 
      mat[i, 2] <- mat[i - 1, 2] + move
    }
    direction <- (direction + move) %% 4
  }
  
  for (i in seq(0, 21, 2)) {
    idx <- which(df$x == mat[(i / 2) + 1, 1] &
                   df$y == mat[(i / 2) + 1, 2] &
                   df$time == i)
    df$color[idx] <- 1
    if (i > 0) {
      df$x_prev[idx] <- df$x[prev_idx]
      df$y_prev[idx] <- df$y[prev_idx]
      df <- df %>%
        add_row(x = df$x[idx], y = df$y[idx],
                time = i + 1, color = 1,
                x_prev = df$x[idx], y_prev = df$y[idx])
    }
    prev_idx <- idx
  }
  return(df)
}


df <- riddle_street_df()
df_path <- filter(df, color == 1)
gg <- ggplot(df) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  coord_fixed() +
  aes(x = x, y = y, color = color) +
  labs(title = "Riddler City Streets") +
  scale_y_continuous(breaks = seq(-5, 5)) +
  scale_x_continuous(breaks = seq(-5, 5)) +
  theme_bw() +
  theme(
    panel.grid.minor = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    panel.border = element_blank(),
    legend.position="none",
    plot.title = element_text(size = 22)
  ) +
  geom_point() +
  geom_segment(aes(x = x_prev, y = y_prev,
                   xend = x, yend = y, size = 0.1),
               linejoin = "mitre",
               data = df_path,
               arrow = arrow(angle = 30,
                             length = unit(0.25, "cm"), type = "closed")
  ) +
  geom_text(aes(label = paste0("(", x, ",", y, ")")),
            hjust = -0.15, vjust = 1.5, size = 2.5
  ) +
  transition_states(
    time,
    transition_length = 2,
    state_length = 1.5,
  ) +
  enter_fade() +
  exit_shrink() +
  ease_aes("sine-in-out")
anim_save("static/img/2020-06-29-riddler-express-markov-streets/riddler_streets.gif", gg)
