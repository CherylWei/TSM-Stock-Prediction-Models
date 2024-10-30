# Load libraries
library(quantmod)
library(rugarch)
library(qrmtools)
library(tseries)
library(forecast)
library(xts)
library(fGarch)

# Load the backtest functions
source("scripts/backtest.R")
source("scripts/backtestGarch.R")

# Example: Load and plot data
getSymbols("TSM", from="2007-01-03", to="2022-11-14")
head(TSM)
tail(TSM)
chartSeries(TSM, theme="white")

# Calculate returns and transform to stationary
test = data.frame(TSM$TSM.Adjusted)
TSM_AdjClose_stationary = diff(log(test)) * 100
ts.plot(TSM_AdjClose_stationary)

# ARIMA model fitting and backtesting
m1 = auto.arima(TSM_AdjClose_stationary)
backtest_result = backtest(m1, TSM_AdjClose_stationary, orig=1000, h=10)
print(backtest_result)

# GARCH model fitting and backtesting
backtestGarch_result = backtestGarch(TSM_AdjClose_stationary, orig=1000, h=10)
print(backtestGarch_result)
