# visualization_functions.R
# This script contains all visualization and table generation functions

# Function to create summary table
create_summary_table <- function(data) {
  data |> 
    gt() |> 
    tab_header(title = "Descriptive Statistics for Data Jobs Dataset") |> 
    fmt_number(columns = Value, decimals = 0)
}

# Function to create jobs summary table
create_jobs_summary_table <- function(data) {
  data |> 
    gt() |> 
    gt_plt_bar(column = total_count, width = 70) |> 
    cols_label(
      job_category = "Job Category",
      total_count = "Total Count of Jobs"
    )
}

# Function to create faceted line graph
create_jobs_trend_plot <- function(data) {
  ggplot(data, aes(x = work_year, y = count)) +
    geom_line(size = 1) +
    facet_wrap(~ job_category, scales = "free_y", 
               labeller = label_wrap_gen(width = 10)) +
    scale_color_viridis_d(option = "D") + 
    labs(
      title = "Distribution of Data Jobs From 2020 To 2023",
      x = "Year",
      y = NULL
    ) +
    theme_minimal() +
    theme(
      strip.text = element_text(size = 10, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid.minor = element_blank()
    )
}

# Function for work settings distribution
create_work_settings_plot <- function(data) {
  ggplot(data, aes(y = job_category, x = count, fill = work_setting)) +
    geom_col(position = "fill") +  
    scale_x_continuous(labels = scales::percent) +
    scale_fill_viridis(discrete = TRUE, option = "D") + 
    labs(x = NULL, y = NULL, fill = "Work Setting") +
    theme_classic()
}

# Function for company size distribution
create_company_size_plot <- function(data) {
  ggplot(data, aes(x = company_size, y = n, fill = work_setting)) +
    geom_bar(stat = "identity") +  
    scale_fill_viridis_d() + 
    labs(
      x = "Company Size",
      y = "Total Data Jobs",
      fill = "Work Setting"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Function for salary distribution boxplot
create_salary_boxplot <- function(data) {
  ggplot(data, aes(
    x = reorder(experience_level, -as.numeric(salary_in_usd)),
    y = as.numeric(salary_in_usd),
    fill = work_setting
  )) +
    geom_boxplot() +
    scale_fill_viridis(discrete = TRUE) +
    labs(x = "Experience Level", y = "Salary (USD)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Function for country proportions table
create_country_table <- function(data) {
  data |> 
    gt() |> 
    tab_header(title = "Proportions of Jobs in Different Countries") |> 
    cols_label(
      company_location = "Country",
      count = "Job Count",
      proportion = "Proportion of Total Jobs"
    ) |> 
    fmt_percent(columns = vars(proportion), decimals = 2) |> 
    tab_spanner(
      label = "Job Count Proportions",
      columns = vars(count, proportion)
    )
}

# Function for salary heatmap
create_salary_heatmap <- function(data) {
  ggplot(data, aes(x = company_location, y = work_setting, fill = avg_salary)) +
    geom_tile() +
    scale_fill_viridis(name = "Average Salary (USD)") +
    labs(x = "Company Location", y = "Work Setting") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Function for productivity summary table
create_productivity_table <- function(data) {
  data |> 
    gt() |> 
    tab_header(
      title = "Summary of Productivity Dataset Metrics by Employment Type"
    ) |> 
    fmt_number(columns = -Employment_Type, decimals = 2) |> 
    gt_theme_538()
}

# Function for productivity scatter plot
create_productivity_plot <- function(data) {
  ggplot(data, aes(
    x = Productivity_Score,
    y = Hours_Worked_Per_Week,
    color = Employment_Type
  )) +
    geom_point(alpha = 0.7, size = 3) +
    scale_color_viridis_d(option = "D") +  
    labs(
      x = "Productivity Score",
      y = "Hours Worked Per Week",
      color = "Employment Type"
    ) +
    geom_smooth(method = "lm", se = FALSE, color = "red", linetype = "dashed") +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "bottom"
    )
}

# Function for well-being violin plot
create_wellbeing_plot <- function(data) {
  ggplot(data, aes(
    x = Employment_Type,
    y = Well_Being_Score,
    fill = Employment_Type
  )) +
    geom_violin(trim = FALSE) +  
    scale_fill_viridis_d() + 
    labs(y = "Well Being Score", x = "Employment Type") +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "none"
    )
}

# Function for flowchart
create_flowchart <- function() {
  grViz("
  digraph flowchart {
    graph [layout = dot, rankdir = TB]
    
    node [shape = rectangle, style = filled, fillcolor = LightBlue, fontsize = 12]
    
    A [label = 'Import Data\n(Data Jobs & Productivity Datasets)']
    B [label = 'Data Cleaning & Preparation\n(Remove Duplicates, Handle Missing Values)']
    C [label = 'Exploratory Analysis\n(Distributions, Ratios, Correlations)']
    D [label = 'Visualizations\n(Salary Distributions, Experience Levels And\n Geographic Locations Among Work Settings)']
    E [label = 'Insights & Relationships\n(Remote Work Impact on Productivity and Well Being)']
    F [label = 'Conclusions']

    A -> B
    B -> C
    C -> D
    D -> E
    E -> F
  }
  ")
}
