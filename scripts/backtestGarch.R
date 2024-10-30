# Function to backtest a GARCH model
backtestGarch <- function(rt, orig, h, inc.mean=TRUE, cdist="norm") {
  # Arguments:
  # - rt: the time series data
  # - orig: starting forecast origin
  # - h: forecast horizon
  # - inc.mean: flag for constant term of the model (mean-equation)
  # - cdist: conditional distribution (default is "norm")
  
  library(fGarch)
  
  T <- length(rt)  # Length of the time series
  
  # Constrain orig and h
  if(orig > T) orig <- T
  if(h < 1) h <- 1
  
  rmse <- rep(0, h)  # RMSE for different forecast horizons
  mabso <- rep(0, h)  # Mean absolute error
  nori <- T - orig  # Number of forecast origins
  
  err <- matrix(0, nori, h)  # Matrix to store forecast errors
  jlast <- T - 1  # The last index to forecast
  
  # Loop over each forecast origin
  for(n in orig:jlast) {
    jcnt <- n - orig + 1
    x <- rt[1:n]  # Subset of time series up to n
    
    # Fit GARCH(1,1) model
    mm <- garchFit(~arma(1,0) + garch(1,1), data=x, include.mean=inc.mean, cond.dist=cdist, trace=F)
    fore <- predict(mm, h)  # Forecast using the fitted model
    
    kk <- min(T, (n + h))  # Effective forecast horizon
    nof <- kk - n  # Number of forecasts at origin n
    pred <- fore$meanForecast[1:nof]  # Predicted values
    obsd <- rt[(n + 1):kk]  # Observed values
    err[jcnt, 1:nof] <- obsd - pred  # Forecast errors
  }
  
  # Calculate RMSE and mean absolute error for each horizon
  for(i in 1:h) {
    iend <- nori - i + 1
    tmp <- err[1:iend, i]
    mabso[i] <- sum(abs(tmp)) / iend
    rmse[i] <- sqrt(sum(tmp^2) / iend)
  }
  
  print("RMSE of out-of-sample forecasts")
  print(rmse)
  print("Mean absolute error of out-of-sample forecasts")
  print(mabso)
  
  # Return a list with results
  list(origin=orig, error=err, rmse=rmse, mabso=mabso)
}
