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

# Checking assumptions:

# Is the data normally distributed?
# This can be checked by plotting a histogram of the residuals and a normal Q-Q plot
hist(sparrow_anova$residuals)  # Plotting histogram of residuals
plot(sparrow_anova, which = 2) # Plotting Q-Q plot

# Checking for homoscedasticity
plot(sparrow_anova, which = 1)

# 6) Running Tukey's HSD ----

# Post-Hoc Test - Tukey's Test

sparrow_test <- TukeyHSD(sparrow_anova, conf.level=.95)

# Plotting Tukey's test result
plot(sparrow_test)


# 7) Communicating model results ----

# Creating summary table of key statistics 
sparrow_summary <- sparrow_long %>%
  group_by(Habitat) %>%                          # Grouping the abundance data by habitat
  summarise(n = n(),                             # "n" is the number of observations
            average_abundance = mean(Abundance), # Average abundance of each habitat
            SD = sd(Abundance)) %>%              # Standard deviation of abundance in each habitat
  mutate(SE = SD/sqrt(n))                        # Standard error of abundance in each habitat

# Creating bar plot of sparrow summary
(sparrow_barplot <- ggplot(data = sparrow_summary) +
  geom_bar(aes(x = Habitat, y = average_abundance, fill = Habitat),    # Creating bar plot with habitat on the x axis and average abundance on the y
           stat = "identity", colour = "black") +                      # Setting stat to identity uses average_abundance instead of count and adding black borders to bars
  geom_errorbar(aes(x = Habitat, ymin = average_abundance - SE,        # Adding error bars to represent standard error
                ymax = average_abundance + SE), width = 0.25,          # Setting width of the error bars to 0.25 for better visibility
                colour = "black", size = 0.6) +                        # Setting colour and thickness of error bars
  scale_fill_manual(values = c("gold", "springgreen3", "royalblue")) + # Setting bar colours to colourblind friendly colours
  labs(x = "\n Habitat", y = "Average Abundance \n") +                 # Adding axis titles (\n leaves a space between plot and title)
  theme_test() +                                                       # Changing theme
  theme(legend.position = "none"))                                     # Removing legend


