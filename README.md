# Time Series Analysis — Case 1

A focused case study in time-series forecasting for the Citi Bike dataset. The project is organized by topic: each analytical track lives in its own folder under the repository root and includes a topic README with step‑by‑step instructions to run the code.

## Quick overview
- Data: citibike.RData (in repository root)
- Language: R (scripts and analysis notebooks)
- Each topic folder contains: scripts, example inputs/outputs (when applicable) and a README that explains dependencies and how to run the code for that topic.

## Project layout
The meaningful top-level folders are:

- Data Exploration: exploratory plots, scripts to inspect data and visualize patterns
- (Seasonal) Unit Root Test: seasonal unit-root and stationarity diagnostics and example workflows
- ARIMA and SARIMA: ARIMA/SARIMA modeling, diagnostics, out-of-sample evaluation, DM/MCS tests
- Exponential-Smoothing-Model: ETS (exponential smoothing) modeling and rolling/expanding-window forecasts
- Forecast Reconciliation: methods and scripts to reconcile forecasts across aggregation levels

Files at repository root:
- citibike.RData — primary dataset used by the example scripts
- README.md — this file

Note: Some folders may include small helper files and cached results (e.g., grid cache `.rds` files or CSVs). See the folder README for details.

## Short guide — from clone to running a topic

1. Clone the repository:
   git clone https://github.com/peterboeckenhoff/Time-Series-Analysis---Case-1---JTP.git
   cd Time-Series-Analysis---Case-1---JTP

2. Open R or RStudio. Install the packages required by the topic you plan to run (each topic README lists exact dependencies). Example (run in R):
   install.packages(c("tidyr","ggplot2","dplyr","forecast","MCS"))

3. Data file:
   Ensure `citibike.RData` is present in the working directory (it is included at the repo root). Topic scripts expect the data file in the same folder or will ask you to set the working directory accordingly — check the topic README.

4. Run a topic
   - Open the folder for the topic you want (e.g., `ARIMA and SARIMA/`) and read its README.
   - Typical workflows:
     - In RStudio: Session → Set Working Directory → To Source File Location, then open the main script and run it or use source("script.R").
     - From R console: setwd("ARIMA and SARIMA"); source("Complete_code_combined.R")

   Each topic README explains:
   - required R packages and installation commands,
   - which script(s) to run,
   - required input files and expected outputs,
   - helpful runtime options (e.g., TEST_MODE or cached grid files).

## Recommended study order
A sensible progression for understanding the case study:
1. Data Exploration — inspect and visualize the data
2. (Seasonal) Unit Root Test — assess stationarity and seasonal behavior
3. ARIMA and SARIMA — fit autoregressive models and evaluate
4. Exponential-Smoothing-Model — ETS baselines and diagnostics
5. Forecast Reconciliation — combine or reconcile forecasts

## Reproducibility and runtime notes
- Some scripts (SARIMA grid search, MCS bootstrap) can be slow; look for cached files in the topic folders (`grid_cache_*.rds`, `results/`) to avoid long reruns.
- Many scripts include a TEST_MODE or similar switch to run short example cases — check the topic README.
- Random seeds are often fixed in testing/bootstrapping steps; consult the topic README if you need to reproduce exact results.

## Where to look next
Open the README inside the folder for the topic you want to run:
- Data Exploration/README-Data Exploration.md
- ARIMA and SARIMA/README.md
- Exponential-Smoothing-Model/README.md
- Forecast Reconciliation/ (check the folder README)
- (Seasonal) Unit Root Test/ (check the folder README)
