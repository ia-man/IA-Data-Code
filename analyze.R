library(ppsr)
library(dplyr)
library(pander)
library(ggplot2)

# Seed random number generator
rseed = Sys.time()
rseed = as.integer(rseed)
rseed = rseed %% 100000
set.seed(rseed)

df <- read.csv("scrubbed.csv",
                stringsAsFactors = FALSE,
                na.strings=c("","NA"))

#str(df)

source("x2y.R")
dx2y(df, target = "Pressure_Score", confidence = TRUE) %>%
  filter(x2y >0) %>%
  pander(split.tables = Inf)

# Filter out problematic columns
ss <- select(df, select=-c("Travel_to_School", "Favourite_physical_activity",
        "Favorite_Food", "Beverage"))
#score_predictors(ss, y="Pressure_Score", do_parallel = TRUE, n_cores = 8)

# Select the interesting columns
ss <- df %>% select("Pressure_Score", "Schoolwork_Pressure",
      "Text_Messages_Received_Yesterday", "Armspan_cm",
      "Doing_Homework_Hours", "Height_cm", "Score_in_memory_game",
      "Index_Fingerlength_mm", "Texting_Messaging_Hours",
      "Favorite_School_Subject", "Sleep_Hours_Schoolnight" ) %>%
      rename(PS = Pressure_Score, SP = Schoolwork_Pressure,
             SMS = Text_Messages_Received_Yesterday,
             Armspan = Armspan_cm, HW = Doing_Homework_Hours,
             Height = Height_cm, Mem = Score_in_memory_game,
             FingerLen = Index_Fingerlength_mm, SMS_HRS = Texting_Messaging_Hours,
             Subject = Favorite_School_Subject, Sleep = Sleep_Hours_Schoolnight)
visualize_pps(ss, y="PS", do_parallel = TRUE, n_cores = 8)
visualize_both(ss, do_parallel = TRUE, n_cores = 8, nrow = 2, color_text = "#000000", color_value_negative = '#ece7f2', color_value_positive = '#2b8cbe')
