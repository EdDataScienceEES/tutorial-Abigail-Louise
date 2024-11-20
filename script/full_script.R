# ANOVA and Tukey's HSD Tutorial full script

# Written by Abigail Haining (19/11/24)

# Tutorial Aims:
# 1) What is ANOVA and Tukey's Test?
# 2) Research question and hypothesis
# 3) Data manipulation
# 4) Data visualisation
# 5) Running a one-way ANOVA
# 6) Running Tukey's HSD
# 7) Communicating model results


# For 1 & 2 see tutorial ----


# 3) Data manipulation ----

# Set the working directory (enter your own filepath here)
setwd("C:/Users/abiga/OneDrive/3rd year/Data Science in EES/tutorial-Abigail-Louise")

# You can check where your working directory is
getwd()

# Load packages
library(tidyverse)


# Import data
sparrow <- read_csv("data/sparrow_data.csv")

# Check the data
head(sparrow)
print(sparrow)

# Convert data frame to long form
sparrow_long <- gather(sparrow, Habitat, Abundance, c(Urban, Forest, Farmland))

# Check variables
str(sparrow_long)


# 4) Data visualisation ----

# Visualising data with a boxplot
(sparrow_boxplot <- ggplot(sparrow_long, aes(x = Habitat, y = Abundance, fill = Habitat)) +
   geom_boxplot())


# 5) Running a one-way ANOVA ----

sparrow_anova <- aov(Abundance ~ Habitat, data = sparrow_long)

summary(sparrow_anova)


# 6) Running Tukey's HSD ----

# Post-Hoc Test - Tukey's Test

sparrow_test <- TukeyHSD(sparrow_anova, conf.level=.95)

# Plotting Tukey's test result
plot(sparrow_test)


# 7) Communicating model results ----



