# Geographic, Experiential, and Productivity Trends in Data Jobs

**Author:** Nakonde Ronah Precious  
**Date:** 2025-10-22

## Overview

This project analyzes how geography, experience level, and work setting (remote, hybrid, in-office) influence salaries and productivity in data jobs.

Using two Kaggle datasets — one on data job listings and another on productivity metrics — the study explores job patterns from 2020–2023 amid tech layoffs and return-to-office debates.

## Key Findings

- Data roles grew significantly from 2020–2023.
- Smaller companies offer more remote positions.
- Executives working remotely earn the most; hybrid entry-level roles earn the least.
- Longer hours don't increase productivity (r = −0.25).
- Remote workers report higher well-being.

## Reproducibility

This project uses Nix to create a fully reproducible environment. No prior installation of R, Quarto, Python, or any packages is required. Nix handles everything automatically.

### What Gets Installed Automatically

- R version 4.5.2
- R packages: tidyverse, ggplot2, scales, forcats, svglite, viridis, gtExtras, gridExtra, DiagrammeR, DiagrammeRsvg, rsvg, quarto, rmarkdown
- Python 3.13 with packages: polars, great-tables
- Quarto (system binary)
- All system dependencies

## Prerequisites

**You only need Nix installed.** Nothing else is required.

## To Reproduce

### 1. Install Nix

**For macOS/Linux:**
```bash
curl --proto '=https' --tlsv1.2 -sSf \
  -L https://install.determinate.systems/nix | \
  sh -s -- install
```

**If you encounter a keychain error (macOS only):**

Run this command until you see "The specified item could not be found in the keychain":
```bash
sudo security delete-generic-password -a "Nix Store" -s "Nix Store" \
  -l "disk3 encryption password" -D "Encrypted volume password"
```

Then retry the Nix installation.

**After installation, activate Nix:**

Open a new terminal window, or run:
```bash
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### 2. Install and Configure Cachix (Optional but Recommended)

This dramatically speeds up the build process by using pre-compiled binaries:
```bash
# Install cachix
nix-env -iA cachix -f https://cachix.org/api/v1/install

# Configure the rstats-on-nix cache
cachix use rstats-on-nix
```

### 3. Clone the Repository
```bash
git clone https://github.com/RonahNakonde/Geographic-Experiential-and-Productivity-Trends-for-Data-Jobs.git
cd Geographic-Experiential-and-Productivity-Trends-for-Data-Jobs
```

### 4. Build the Environment
```bash
nix-build
```

**Note:** This may take 10-30 minutes the first time as Nix downloads and builds all dependencies. Subsequent builds are much faster thanks to caching.

### 5. Render the Analysis
```bash
nix-shell --run 'quarto render "Geographic, Experiential, and Productivity Trends in Data Jobs.qmd"'
```

The rendered HTML document will be created in the project directory.

### 6. View the Output

**macOS:**
```bash
open "Geographic, Experiential, and Productivity Trends in Data Jobs.html"
```

**Linux:**
```bash
xdg-open "Geographic, Experiential, and Productivity Trends in Data Jobs.html"
```

## Project Structure

| File | Description |
|------|-------------|
| `Geographic, Experiential, and Productivity Trends in Data Jobs.qmd` | Main Quarto analysis document (narrative and structure) |
| `data_analysis.R` | Data loading and processing script (business logic) |
| `visualization_functions.R` | Visualization and table generation functions |
| `default.nix` | Nix environment definition (auto-generated, manually edited for network access) |
| `gen-env.R` | Script to generate default.nix using the {rix} package |
| `data/` | Datasets (automatically downloaded from GitHub during render) |
| `README.md` | This file |

## How Reproducibility Works

This project follows best practices for reproducible research:

1. **Separation of Concerns:** Business logic (`data_analysis.R`, `visualization_functions.R`) is separate from the narrative document (`.qmd`)
2. **Declarative Dependencies:** All dependencies are explicitly declared in `default.nix`
3. **Environment Isolation:** Nix ensures the exact same software versions are used regardless of the host system
4. **Bit-for-Bit Reproducibility:** The same inputs always produce the same outputs

## Troubleshooting

### "Command not found: nix"

After installing Nix, either:
- Open a new terminal window, OR
- Run: `. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`

### Build takes too long

The first build downloads and compiles packages. This is normal. Use Cachix (step 2) to speed this up significantly.

### Network errors during rendering

The analysis downloads datasets from GitHub. Ensure you have an active internet connection.

### Clean rebuild

If something goes wrong, clean and rebuild:
```bash
rm -rf result
nix-collect-garbage
nix-build
```

## Regenerating the Environment (Advanced)

If you modify `gen-env.R` to add/remove packages:
```bash
# Enter a nix-shell with the rix package
nix-shell -p R rPackages.rix

# Regenerate default.nix
Rscript gen-env.R

# Exit the shell
exit

# Rebuild
nix-build
```

**Important:** After regenerating `default.nix`, you must manually re-add the network access configuration:

In the `mkShell` section, add:
```nix
SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
__noChroot = true;
```

## License

This project is for academic purposes.

## Contact

For questions or issues, please open an issue on GitHub.
