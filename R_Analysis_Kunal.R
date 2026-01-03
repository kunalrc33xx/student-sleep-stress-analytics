# Load necessary library
install.packages("tidyverse")
library(tidyverse)

df = sleep_habits
# Data Cleaning
# Remove quotes and whitespace from Sleep_Duration
df <- df %>%
  mutate(Sleep_Duration_Clean = str_remove_all(Sleep_Duration, "'") %>% str_trim())

# Define the desired order
sleep_levels <- c("Less than 5 hours", "5-6 hours", "7-8 hours", "More than 8 hours")

# Filter and set factor levels
df_clean <- df %>%
  filter(Sleep_Duration_Clean %in% sleep_levels) %>%
  mutate(Sleep_Duration_Clean = factor(Sleep_Duration_Clean, levels = sleep_levels))

# Grouping & Aggregation
summary_table <- df_clean %>%
  group_by(Sleep_Duration_Clean) %>%
  summarise(
    Avg_CGPA = mean(`CGPA (on a scale of 10)`, na.rm = TRUE),
    Avg_Pressure = mean(Academic_Pressure, na.rm = TRUE)
  )

# Print table
print(summary_table)

# 4. Visualization
# Note: ggplot2 prefers single-axis plots. We use a scaling factor to plot Pressure on the CGPA axis.
# Scaling logic: Transform Pressure range ~3.1 to match CGPA range ~7.7
scale_factor <- 2.4
shift <- 0.2

ggplot(summary_table, aes(x = Sleep_Duration_Clean)) +
  # Bar Chart for CGPA
  geom_col(aes(y = Avg_CGPA), fill = "#4e79a7", alpha = 0.6, width = 0.6) +
  # Line Chart for Pressure (scaled)
  geom_line(aes(y = Avg_Pressure * scale_factor), group = 1, color = "#e15759", size = 1.5) +
  geom_point(aes(y = Avg_Pressure * scale_factor), color = "#e15759", size = 3) +
  # Y-axis settings with secondary axis
  scale_y_continuous(
    name = "Average CGPA",
    limits = c(0, 8.5),
    sec.axis = sec_axis(~ ./scale_factor, name = "Academic Pressure")
  ) +
  # Zoom separately using coord_cartesian
  coord_cartesian(ylim = c(7.0, 8.0)) +
  # Labels & theme
  labs(
    title = "Sweet Spot Analysis: Sleep vs. CGPA and Pressure",
    x = "Sleep Duration"
  ) +
  theme_minimal()

#Second analysis
# Calculate Correlation
# We use Spearman correlation because Academic Pressure is ordinal (ranked 1-5)
correlation_val <- cor(df$Academic_Pressure, df$Depression, method = "spearman")
print(paste("Spearman Correlation Coefficient:", round(correlation_val, 4)))

#Grouping & Aggregation
# Calculate the Depression Rate (Mean) for each pressure level
library(dplyr)
depression_summary <- df %>%
  group_by(Academic_Pressure) %>%
  summarise(
    Depression_Rate = mean(Depression, na.rm = TRUE)
  )

print("Summary Table:")
print(depression_summary)

install.packages("scales")
library(scales)

install.packages("ggplot2")

# Load the package
library(ggplot2)

#Visualization
ggplot(depression_summary, aes(x = factor(Academic_Pressure), y = Depression_Rate)) +
  # Create Bar Chart
  geom_col(fill = "#e15759", alpha = 0.8, width = 0.7) +
  
  # Add Percentage Labels on top of bars
  geom_text(aes(label = percent(Depression_Rate, accuracy = 1)), 
            vjust = -0.5, size = 5, fontface = "bold") +
  
  # Formatting Axes and Titles
  scale_y_continuous(labels = percent_format(), limits = c(0, 1)) +
  labs(
    title = "Correlation: Academic Pressure vs. Depression Probability",
    subtitle = paste("Strong positive correlation of", round(correlation_val, 2)),
    x = "Academic Pressure Level (1-5)",
    y = "Probability of Depression"
  ) +
  
  # Clean Theme
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.title = element_text(size = 12)
  )
# Data Preparation
install.packages("stringr")
library(stringr)
# Clean the Sleep_Duration column (remove quotes and whitespace)
library(tidyverse)
print("Column Names:")
print(names(df))

#Clean the Sleep Column (Step-by-Step)
# We create the clean column FIRST, check it, and THEN filter.
df <- df %>%
  mutate(Sleep_Clean = str_replace_all(Sleep_Duration, "'", "") %>% str_trim())

#Debug: Check the unique values BEFORE filtering to ensure cleaning worked
print("Unique values in Sleep_Clean:")
print(unique(df$Sleep_Clean))

#Filter out 'Others' and outliers
df_clean <- df %>%
  filter(Sleep_Clean != "Others") %>%
  filter(!is.na(Sleep_Clean))

# Convert to Factor with explicit levels
# This explicitly tells R that these 4 text strings are our categories
df_clean$Sleep_Clean <- factor(df_clean$Sleep_Clean, 
                               levels = c("Less than 5 hours", 
                                          "5-6 hours", 
                                          "7-8 hours", 
                                          "More than 8 hours"))

# Final Check: Verify we have data in all 4 buckets
print("Count of rows per category (Should not be 0):")
table(df_clean$Sleep_Clean)

# Run the Regression Model
# Formula: Y (CGPA) ~ X1 (Sleep) + X2 (Academic Pressure) + X3 (Study Hours)
model <- lm(`CGPA (on a scale of 10)` ~ Sleep_Clean + Academic_Pressure + `Work/Study_Hours`, data = df)

#View results
summary(model)


#Business Problem 2

# Data Preparation: Convert Sleep to Numeric for Averaging
# We create a numeric proxy for sleep to calculate averages per city
df <- df %>%
  mutate(Sleep_Numeric = case_when(
    str_detect(Sleep_Duration, "Less than 5") ~ 4.0,
    str_detect(Sleep_Duration, "5-6") ~ 5.5,
    str_detect(Sleep_Duration, "7-8") ~ 7.5,
    str_detect(Sleep_Duration, "More than 8") ~ 9.0,
    TRUE ~ NA_real_
  ))

# Aggregate by City
city_summary <- df %>%
  group_by(City) %>%
  summarise(
    Avg_Pressure = mean(Academic_Pressure, na.rm = TRUE),
    Avg_Sleep = mean(Sleep_Numeric, na.rm = TRUE),
    Count = n()
  ) %>%
  filter(Count > 10) # Filter out cities with very few students for cleaner data

# Visualization: Scatter Plot
ggplot(city_summary, aes(x = Avg_Sleep, y = Avg_Pressure, label = City)) +
  # Points
  geom_point(aes(color = Avg_Pressure, size = Avg_Pressure), alpha = 0.8) +
  
  # Text Labels (Repel ensures they don't overlap)
  # install.packages("ggrepel") if needed
  ggrepel::geom_text_repel(size = 3.5, fontface = "bold") +
  
  # Color Scale
  scale_color_viridis_c(option = "magma", direction = -1) +
  
  # Formatting
  labs(
    title = "City Analysis: Sleep vs. Academic Pressure",
    subtitle = "Big cities like Bangalore and Delhi show high stress and lower sleep.",
    x = "Average Sleep Duration (Hours)",
    y = "Average Academic Pressure (1-5)",
    color = "Pressure Level",
    size = "Pressure Level"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

#Visualization 2
# 1. Aggregate by Degree/Qualification
degree_summary <- df %>%
  group_by(`Highest qualification`) %>% # Backticks for spaces
  summarise(
    Avg_Pressure = mean(Academic_Pressure, na.rm = TRUE),
    Count = n()
  ) %>%
  filter(Count >= 10) %>% # Filter out degrees with very few responses (outliers)
  arrange(desc(Avg_Pressure)) %>% # Sort High to Low
  slice_head(n = 10) # Keep top 10

# 2. Visualization: Horizontal Bar Chart
ggplot(degree_summary, aes(x = reorder(`Highest qualification`, Avg_Pressure), y = Avg_Pressure)) +
  # Bar Chart
  geom_col(aes(fill = Avg_Pressure), show.legend = FALSE) +
  
  # Add Value Labels on bars
  geom_text(aes(label = round(Avg_Pressure, 2)), hjust = 1.2, color = "white", fontface = "bold") +
  
  # Flip Coordinates for readability (Horizontal Bars)
  coord_flip() +
  
  # Color Scale
  scale_fill_gradient(low = "#ffcccb", high = "#b00000") + # Light Red to Dark Red
  
  # Formatting
  labs(
    title = "Top 10 Most Stressful Degrees",
    x = "Degree / Qualification",
    y = "Average Academic Pressure (1-5)"
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 11, face = "bold"),
    plot.title = element_text(size = 16, face = "bold")
  )

#Building another LM

#Data Cleaning
# Remove quotes and extra spaces from the text columns
df <- df %>%
  mutate(
    City_Clean = str_remove_all(City, "'") %>% str_trim(),
    Degree_Clean = str_remove_all(`Highest qualification`, "'") %>% str_trim()
  )

#Set Reference Levels (Crucial for Interpretation)
# We set "Class 12" as the baseline for Degree because it is a high-stress group.
# This means the coefficients for other degrees will show how much *less* (or more) stressful they are compared to High School.
df$Degree_Clean <- as.factor(df$Degree_Clean)
df$Degree_Clean <- relevel(df$Degree_Clean, ref = "Class 12")

# We set "Agra" as the baseline for City (Low stress city)
df$City_Clean <- as.factor(df$City_Clean)
df$City_Clean <- relevel(df$City_Clean, ref = "Agra")

# Run the Linear Regression
# Formula: Pressure ~ City + Degree + CGPA
model_demographics <- lm(Academic_Pressure ~ City_Clean + Degree_Clean + `CGPA (on a scale of 10)`, data = df)

# View Statistical Summary
# Look for rows with '*' or '***' to identify significant drivers
summary(model_demographics)


