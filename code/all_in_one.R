# Data viz for reaction time in a binary choice decision making task
# Author @ Rahul Venugopal
# This piece of code is inspired by Cederic Scherer's tidytuesday work

# Plot distribution and RT values + boxplot
# Highlighted median and number of correct vs incorrect trials
# First we have to have IQR data, two groups correct and incorrect
# KDE, boxplot, mean and median are reported

# Code flow
# Setting up theme
# 1. Creating an empty space via geom_rect
# 2. Boxplot which is almost a line. Outliers are visible this way
# 3. Draw 25th and 75th quartile as rectangles
# 4. geom_point drawn as | lines
# 5. stat_halfeye to draw distribution plot
# 6. Adding median and sample size as geom_text
# 7. Coloring two groups as per pal


# Create reaction time in 7 steps for each level as rug
# Each row is one level

# Loading libraries
library(tidyverse)
library(colorspace)
library(ragg)
library(cowplot)
library(ggtext)
library(pdftools)

# Load data
data_rt <- read.csv("sample_data.csv")

# Converting correct to a factor
data_rt$correct <- as.factor(data_rt$correct)

# This dataframe would be useful to set plot
df_rect <-
  tibble(
    xmin = c(-Inf, 400, 2100),
    xmax = c(Inf, Inf, Inf),
    ymin = c(3, 2, 1),
    ymax = c(Inf, Inf, Inf)
  )

# Getting IQR for the dataset
data_rt_iqr <- data_rt %>%
  group_by(correct) %>%
  mutate(
    median = median(response_time),
    q25 = quantile(response_time, probs = .25),
    q75 = quantile(response_time, probs = .75),
    n = n()
  ) %>%
  ungroup() %>%
  mutate(correct_num = as.numeric(fct_rev(correct)))

# Replacing higher number by another so that distribution plots don't touch
data_rt_iqr$correct_num[data_rt_iqr$correct_num == 2] <- 5

# The viz part where we set our theme
theme_set(theme_minimal(base_size = 15, base_family = "Neutraface Slab Display TT Bold"))
theme_update(
  panel.grid.major = element_line(color = "grey92", size = .4),
  panel.grid.minor = element_blank(),
  axis.title.x = element_text(color = "grey30", margin = margin(t = 7)),
  axis.title.y = element_text(color = "grey30", margin = margin(r = 7)),
  axis.text = element_text(color = "grey50"),
  axis.ticks =  element_line(color = "grey92", size = .4),
  axis.ticks.length = unit(.6, "lines"),
  legend.position = "top",
  plot.title = element_text(hjust = 0, color = "black",
                            family = "Neutraface 2 Display Titling",
                            size = 21, margin = margin(t = 10, b = 35)),
  plot.subtitle = element_text(hjust = 0, face = "bold", color = "grey30",
                               family = "Neutraface Text Book Italic",
                               size = 14, margin = margin(0, 0, 25, 0)),
  plot.title.position = "plot",
  plot.caption = element_text(color = "grey50", size = 10, hjust = 1,
                              family = "Neutraface Display Medium",
                              lineheight = 1.05, margin = margin(30, 0, 0, 0)),
  plot.caption.position = "plot",
  plot.margin = margin(rep(20, 4))
)
pal <- c("red", "#006400") # change color palette here

# raincloud and barcode plots

rt_viz <-
  ggplot(data_rt_iqr, aes(response_time, correct_num - .2)) +

  geom_boxplot(
    aes(
      color = correct,
      color = after_scale(darken(color, .1, space = "HLS"))
    ),
    width = 0,
    size = .9
  ) +
  geom_rect(
    aes(
      xmin = q25,
      xmax = median,
      ymin = correct_num - .05,
      ymax = correct_num - .35
    ),
    fill = "grey89"
  ) +
  geom_rect(
    aes(
      xmin = q75,
      xmax = median,
      ymin = correct_num - .05,
      ymax = correct_num - .35
    ),
    fill = "grey79"
  ) +
  geom_segment(
    aes(
      x = q25,
      xend = q25,
      y = correct_num - .05,
      yend = correct_num - .35,
      color = correct,
      color = after_scale(darken(color, .05, space = "HLS"))
    ),
    size = .25
  ) +
  geom_segment(
    aes(
      x = q75,
      xend = q75,
      y = correct_num - .05,
      yend = correct_num - .35,
      color = correct,
      color = after_scale(darken(color, .05, space = "HLS"))
    ),
    size = .25
  ) +
  geom_point(
    aes(
      color = correct
    ),
    shape = "|",
    size = 5,
    alpha = .8
  ) +
  ggdist::stat_halfeye(
    aes(
      y = correct_num,
      color = correct,
      fill = after_scale(lighten(color, .5))
    ),
    shape = 18,
    point_size = 5,
    interval_size = 1.8,
    adjust = .5,
    .width = c(0, 1)
  ) +
  geom_text(
    data = data_rt_iqr %>%
      group_by(correct, correct_num) %>%
      summarize(m = unique(median)),
    aes(
      x = m,
      y = correct_num + .22,
      label = format(round(m, 2), nsmall = 2)
    ),
    inherit.aes = F,
    color = "black",
    family = "Neutraface Slab Display TT Bold",
    size = 5
  ) +
  geom_text(
    data = data_rt_iqr %>%
      group_by(correct, correct_num) %>%
      summarize(n = unique(n), max = max(response_time, na.rm = T)),
    aes(
      x = max - 200,
      y = correct_num + 2,
      label = glue::glue("  n = {n}"),
      color = correct
    ),
    inherit.aes = F,
    family = "Neutraface Slab Display TT Bold",
    size = 5,
    hjust = 0
  ) +
  scale_y_continuous(
    limits = c(.55, NA),
    breaks = c(1,5), # will change based on grouping
    labels = c("Correct", "Incorrect"),
    expand = c(0, 0)
  ) +
  scale_color_manual(
    values = pal,
    guide = F
  ) +
  scale_fill_manual(
    values = pal,
    guide = F
  ) +
  labs(
    x = "Reaction time (ms)",
    y = NULL,
    subtitle = "Distribution of reaction time in correct vs incorrect trials") + 
  theme(
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(family = "Neutraface Slab Display TT Titl", 
                               color = rev(pal),size = 18, lineheight = .9),
    axis.ticks.length = unit(0, "lines"),
    axis.text = element_blank(),
    plot.subtitle = element_text(margin = margin(0, 0, -10, 0))
  )

ggsave("rt_dist_box_point.png", dpi = 600, width = 8, height = 8, type = 'cairo')