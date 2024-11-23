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
library(broom)

# Import data
sparrow <- read_csv("data/sparrow_data.csv")

# Check the data
head(sparrow)
print(sparrow)
view(sparrow)

# Convert data frame to long form
sparrow_long <- gather(sparrow, Habitat, Abundance, c(Urban, Forest, Farmland))

# Check variables
str(sparrow_long)


# 4) Data visualisation ----

# Visualising data with a boxplot
(sparrow_boxplot <- ggplot(sparrow_long,                                      
                           aes(x = Habitat, y = Abundance, fill = Habitat)) + # Setting x axis as habitat and y as abundance 
   geom_boxplot() +                                                           # Adding data as a boxplot
   scale_fill_manual(values = c("gold", "springgreen3", "royalblue")))        # Setting box colours to colourblind friendly colours


# 5) Running a one-way ANOVA ----

# Running a one-way ANOVA of abundance against habitat
sparrow_anova <- aov(Abundance ~ Habitat, data = sparrow_long)

# Printing summary output
summary(sparrow_anova)

# Checking assumptions:

# Normal distribution of residuals - this can be checked by plotting a histogram of the residuals and a normal Q-Q plot

hist(sparrow_anova$residuals, breaks = 30)  # Plotting histogram of residuals and increasing intervals to get a better visualisation
# The residuals do not look normally distributed

plot(sparrow_anova, which = 2) # Plotting Q-Q plot
# There are heavy tails present which suggests the data has a skewed distribution 
# Or the outliers do not follow a normal distribution (by looking at the histogram it appears to be the this)


# Checking for homoscedasticity
plot(sparrow_anova, which = 1)
# The red line is flat against grey dashed line which is what we want to see


# 6) Running Tukey's HSD ----

# Running Tukey's HSD post-hoc test on the anova output and setting the confidence level to 95%
(sparrow_test <- TukeyHSD(sparrow_anova, conf.level=.95))

# To convert results into a better presented format of the summary table you can use the broom package
(tukey_results <- broom::tidy(sparrow_test)) # Creating tidy data frame using broom

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
                colour = "black", linewidth = 0.6) +                        # Setting colour and thickness of error bars
  scale_fill_manual(values = c("gold", "springgreen3", "royalblue")) + # Setting bar colours to colourblind friendly colours
  labs(x = "\n Habitat", y = "Average Abundance \n") +                 # Adding axis titles (\n leaves a space between plot and title)
  theme_test() +                                                       # Changing theme
  theme(legend.position = "none"))                                     # Removing legend


# Improve Tukey's test result plot
(sparrow_tukey_plot <- ggplot(tukey_results, 
                              aes(x = contrast, y = estimate)) +    # Set x axis to pairwise comparisons and y to mean differences
  geom_point(color = "black", size = 2) +                           # Add points for mean differences and increase size
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high),             # Add error bars showing confidence intervals
                width = 0.2, color = "black") +                     # Add error bars for confidence intervals
  geom_hline(yintercept = 0, linetype = "dashed", color = "blue") + # Add a reference line at 0 and highlight with blue colour
  coord_flip() +                                                    # Flip coordinates for horizontal orientation
  labs(x = "Pairwise Comparisons", y = "Mean Difference",           # Add informative axis titles
       title = "Tukey HSD Test with 95% confidence level") +        # Add plot title
  theme_minimal(base_size = 12))                                    # Apply a clean theme



