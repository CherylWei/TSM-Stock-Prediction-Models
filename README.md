# 📈 TSM-Stock-Prediction-Models


This repository contains R scripts for downloading, analyzing, and forecasting stock prices using ARIMA and GARCH models. It includes functions for backtesting the predictive performance of these models on historical stock data.

## 📂 Directory Structure

```
Stock-Analysis-and-Forecasting/
├── data/
│   └── TSM.csv             # Historical data for TSM stock
├── scripts/
│   ├── backtest.R          # ARIMA backtesting function
│   ├── backtestGarch.R     # GARCH backtesting function
│   └── main_script.R       # Main script for performing analysis
├── README.md               # This README file
└── .gitignore              # Specifies intentionally untracked files
```

## 📜 Requirements

Before running the scripts, ensure you have the following R packages installed:

```r
install.packages(c("quantmod", "rugarch", "qrmtools", "tseries", "forecast", "xts", "fGarch"))
```

## 🚀 Usage

1. **Clone the repository:**
   ```sh
   git clone https://github.com/your_username/Stock-Analysis-and-Forecasting.git
   cd Stock-Analysis-and-Forecasting
   ```

2. **Customize the `main_script.R` as per your requirements (especially data paths).**

3. **Source the required scripts and run the `main_script.R`:**
   ```r
   source("scripts/backtest.R")
   source("scripts/backtestGarch.R")
   source("scripts/main_script.R")
   ```

## 📘 Description of Functions

### `backtest.R`

The purpose of `backtest.R` is to provide a function (`backtest`) that performs backtesting for ARIMA models. It evaluates the predictive performance of these models by comparing the forecasts with actual historical data.

### `backtestGarch.R`

The purpose of `backtestGarch.R` is to provide a function (`backtestGarch`) that performs backtesting for GARCH models. This function evaluates the predictive performance of GARCH(1,1) models based on their ability to forecast time series data.

### `main_script.R`

This script:
- Downloads and preprocesses stock data.
- Fits ARIMA and GARCH models.
- Uses the backtest functions to perform model validation and analysis on the data.

## 📊 Example

```r
# Load necessary libraries
library(quantmod)

# Load and prepare the data
getSymbols("TSM", from="2007-01-03", to="2022-11-14")
TSM_data = TSM$TSM.Adjusted
TSM_returns = diff(log(TSM_data))

# Fit an ARIMA model to the stationary returns
arima_model = auto.arima(TSM_returns)

# Perform backtesting
backtest_result = backtest(arima_model, TSM_returns, orig=1000, h=10)

# View backtest results
print(backtest_result)
```

## ⚙️ License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 👥 Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any feature/addition you make.

## 🧑‍💻 Author

- Cheryl Lin 我是雪兒 - [@Cheryl_Wei]
