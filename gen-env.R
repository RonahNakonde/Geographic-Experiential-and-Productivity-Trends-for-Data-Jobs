# gen-env.R
library(rix)

rix(
  date = "2025-09-22",  # snapshot date for reproducibility
  r_pkgs = c(
    "tidyverse",
    "ggplot2",
    "scales",
    "forcats",
    "svglite",
    "viridis",
    "gtExtras",
    "gridExtra",
    "DiagrammeR",
    "DiagrammeRsvg",
    "rsvg"
  ),
  py_conf = list(
    py_version = "3.13",
    py_pkgs = c("polars", "great-tables")
  ),
  ide = "none",         # change to "vscode" if you use VS Code with R
  project_path = ".",   # current project directory
  overwrite = TRUE,     # overwrite existing Nix files if needed
  print = TRUE          # print the generated Nix expression in the console
)

