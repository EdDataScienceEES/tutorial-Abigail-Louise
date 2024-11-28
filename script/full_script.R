# ANOVA and Tukey's HSD Tutorial full script
# Written by Abigail Haining
# Email - s2317501@ed.ac.uk
# 19/11/24

# Workflow:
# 1) Set working directory, load packages and import data
# 2) Data manipulation
# 3) Data visualisation
# 4) Running a one-way ANOVA
# 5) Running Tukey's HSD
# 6) Communicating model results



# 1) Set working directory, load packages and import data ----

# Set the working directory (enter your own filepath here)
setwd("C:/Users/abiga/OneDrive/3rd year/Data Science in EES/tutorial-Abigail-Louise")

# You can check where your working directory is
getwd()

# Load packages
library(tidyverse)
library(broom)
library(gridExtra)
library(grid)

# Import data
sparrow <- read_csv("data/house_sparrow.csv")

# Check the data
head(sparrow)
view(sparrow)


# 2) Data manipulation ----

# Convert data frame to long form
sparrow_long <- pivot_longer(sparrow, cols = c(Urban, Forest, Farmland), names_to = "Habitat", values_to = "Abundance")


# 3) Data visualisation ----

# Visualising data with histograms to check for normal distribution for each habitat type
# Urban
(sparrow_urban <- ggplot(sparrow, aes(x = Urban)) + # Creating plot, specifying data and the column to use for x axis
   geom_histogram(bins = 15,                        # Adding data as histogram with 15 intervals
                  fill = "royalblue") +             # Adding colour responding to habitat
   labs(x = "Abundance", y = "Frequency") +         # Adding x and y axis labels
   theme_test())                                    # Apply a clean theme

# Farmland
(sparrow_farmland <- ggplot(sparrow, aes(x = Farmland)) + # Creating plot, specifying data and the column to use for x axis
    geom_histogram(bins = 15,                             # Adding data as histogram with 15 intervals
                   fill = "gold") +                       # Adding colour responding to habitat
    labs(x = "Abundance", y = "Frequency") +              # Adding x and y axis labels
    theme_test())                                         # Apply a clean theme

# Forest
(sparrow_forest <- ggplot(sparrow, aes(x = Forest)) + # Creating plot, specifying data and the column to use for x axis
    geom_histogram(bins = 15,                         # Adding data as histogram with 15 intervals
                   fill = "springgreen3") +           # Adding colour responding to habitat
    labs(x = "Abundance", y = "Frequency") +          # Adding x and y axis labels
    theme_test())                                     # Apply a clean theme

# Arranging plots in a single panel
(grid.arrange(sparrow_urban, sparrow_farmland, sparrow_forest, nrow = 1,        # Creating panel of 3 plots on 1 row
             bottom = textGrob("Fig. 1 - Response variable (Abundance) appears normally distributed across all groups (Habitats), n = 120", # Adding caption
                               gp = gpar(fontsize = 10, fontface = "italic")))) # Specifying font size for caption and making it italic

# Visualising data with a boxplot
(sparrow_boxplot <- ggplot(sparrow_long,                                      
                           aes(x = Habitat, y = Abundance, fill = Habitat)) +                   # Setting x axis as habitat and y as abundance 
   geom_boxplot() +                                                                             # Adding data as a boxplot
   scale_fill_manual(values = c("gold", "springgreen3", "royalblue")) +                         # Setting box colours to corresponding habitat colours
    labs(x = "\n Habitat", y = "Abundance \n",                                                  # Adding axis labels (\n leaves a space between plot and title) 
      caption = "Fig. 2 - Boxplot showing the distribution of abundance across farmland, urban, 
      and forest groups. The farmland and urban groups exhibit overlapping, while 
      forest abundance is generally lower than that of the other two groups, n = 120") +        # Adding caption
   theme_bw() +                                                                                 # Apply a clean theme
   theme(legend.position = "none"))                                                             # Removing legend

# 4) Running a one-way ANOVA ----

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


# 5) Running Tukey's HSD ----

# Running Tukey's HSD post-hoc test on the anova output and setting the confidence level to 95%
(sparrow_test <- TukeyHSD(sparrow_anova, conf.level=.95))

# To convert results into a better presented format of the summary table you can use the broom package
(tukey_results <- broom::tidy(sparrow_test)) # Creating tidy data frame using broom

# Plotting Tukey's test result
plot(sparrow_test)


# 6) Communicating model results ----

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
                      ymax = average_abundance + SE), width = 0.25,      # Setting width of the error bars to 0.25 for better visibility
                  colour = "black", linewidth = 0.6) +                   # Setting colour and thickness of error bars
    scale_fill_manual(values = c("gold", "springgreen3", "royalblue")) + # Setting bar colours to colourblind friendly colours
    labs(x = "\n Habitat", y = "Average Abundance \n",                   # Adding axis titles 
         caption = "Fig. 3") +                 
    theme_test() +                                                       # Apply a clean theme
    theme(legend.position = "none"))                                     # Removing legend


# Improve Tukey's test result plot
(sparrow_tukey_plot <- ggplot(tukey_results, 
                              aes(x = contrast, y = estimate)) +      # Set x axis to pairwise comparisons and y to mean differences
    geom_point(color = "black", size = 2) +                           # Add points for mean differences and increase size
    geom_errorbar(aes(ymin = conf.low, ymax = conf.high),             # Add error bars showing confidence intervals
                  width = 0.2, color = "black") +                     # Add error bars for confidence intervals
    geom_hline(yintercept = 0, linetype = "dashed", color = "blue") + # Add a reference line at 0 and highlight with blue colour
    coord_flip() +                                                    # Flip coordinates for horizontal orientation
    labs(x = "Pairwise Comparisons", y = "Mean Difference",           # Add informative axis titles
         title = "Tukey HSD Test with 95% confidence level") +        # Add plot title
    theme_bw(base_size = 12))                                         # Apply a clean theme


