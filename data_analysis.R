# data_analysis.R
# This script contains all data processing and analysis logic

library(tidyverse)
library(ggplot2)
library(scales)
library(forcats)
library(svglite)
library(viridis)
library(gtExtras)
library(gridExtra)
library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

# Import Data
jobs_data <- read_csv("data/jobs_in_data.csv") 
productivity_data <- read_csv("data/remote_work_productivity.csv") 

# Descriptive Statistics
numeric_summary <- jobs_data |> 
  summarise(
    min_salary_usd = min(salary_in_usd, na.rm = TRUE),
    max_salary_usd = max(salary_in_usd, na.rm = TRUE),
    mean_salary_usd = mean(salary_in_usd, na.rm = TRUE),
    median_salary_usd = median(salary_in_usd, na.rm = TRUE),
    sd_salary_usd = sd(salary_in_usd, na.rm = TRUE)
  )

categorical_summary <- jobs_data |> 
  summarise(
    unique_work_years = n_distinct(work_year),
    unique_company_locations = n_distinct(company_location),
    unique_company_sizes = n_distinct(company_size),
    experience_levels = n_distinct(experience_level),
    work_settings = n_distinct(work_setting)
  )

combined_summary <- tibble(
  Statistic = c(
    "Min Salary (USD)", "Max Salary (USD)", "Mean Salary (USD)", 
    "Median Salary (USD)", "SD Salary (USD)",
    "Unique Work Years", "Unique Company Locations", 
    "Unique Company Sizes", "Experience Levels", "Work Settings"
  ),
  Value = c(
    numeric_summary$min_salary_usd, numeric_summary$max_salary_usd, 
    numeric_summary$mean_salary_usd, numeric_summary$median_salary_usd, 
    numeric_summary$sd_salary_usd, categorical_summary$unique_work_years, 
    categorical_summary$unique_company_locations, 
    categorical_summary$unique_company_sizes, 
    categorical_summary$experience_levels, 
    categorical_summary$work_settings
  )
)

# Distribution of Jobs Among Categories
jobs_summary <- jobs_data |> 
  count(job_category, work_setting, name = "count")

jobs_summary1 <- jobs_summary |> 
  group_by(job_category) |> 
  mutate(total_count = sum(count)) |> 
  ungroup() |> 
  mutate(job_category = fct_reorder(job_category, total_count, .desc = TRUE))

job_category_summary <- jobs_summary1 |> 
  group_by(job_category) |> 
  summarise(total_count = sum(count), .groups = "drop")

# Job Trends Over Time
jobs_summary_facet <- jobs_data |> 
  group_by(job_category, work_year) |> 
  summarise(count = n(), .groups = "drop")

# Company Size Analysis
jobs_data_company_size <- jobs_data |> 
  group_by(company_size, work_setting) |> 
  count()

# Country Proportions
country_proportions <- jobs_data |> 
  group_by(company_location) |> 
  summarise(count = n(), .groups = 'drop') |> 
  arrange(desc(count)) |> 
  slice(1:15) |> 
  mutate(proportion = count / sum(count))

# Top Countries for Heatmap
top_countries <- jobs_data |> 
  group_by(company_location) |> 
  summarise(count = n(), .groups = 'drop') |> 
  arrange(desc(count)) |> 
  slice(1:10) |> 
  pull(company_location)

filtered_data <- jobs_data |> 
  filter(company_location %in% top_countries)

proportions_usd_data <- filtered_data |> 
  group_by(company_location, work_setting) |> 
  summarise(
    count = n(),
    avg_salary = mean(salary_in_usd, na.rm = TRUE),
    .groups = 'drop'
  ) |> 
  group_by(company_location) |> 
  mutate(proportion = count / sum(count))

# Productivity Summary
summary_table_productivity <- productivity_data |> 
  group_by(Employment_Type) |> 
  summarize(
    `Average Hours Worked` = mean(Hours_Worked_Per_Week, na.rm = TRUE),
    `Average Productivity Score` = mean(Productivity_Score, na.rm = TRUE),
    `Average Well-Being Score` = mean(Well_Being_Score, na.rm = TRUE)
  )

# Correlation Test
productivity_correlation <- cor.test(
  productivity_data$Productivity_Score, 
  productivity_data$Hours_Worked_Per_Week
)
