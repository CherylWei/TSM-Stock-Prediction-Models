# Function to backtest an ARIMA model
backtest <- function(m1, rt, orig, h, xre=NULL, fixed=NULL, inc.mean=TRUE) {
  # Arguments:
  # - m1: time-series model object
  # - rt: the time series data
  # - orig: starting forecast origin
  # - h: forecast horizon
  # - xre: independent variables (optional)
  # - fixed: parameter constraint (optional)
  # - inc.mean: flag for constant term of the model
  
  # Extract the model orders
  regor <- c(m1$arma[1], m1$arma[6], m1$arma[2])
  seaor <- list(order = c(m1$arma[3], m1$arma[7], m1$arma[4]), period = m1$arma[5])
  
  T <- length(rt)  # Length of the time series
  
  # Ensure xre is a matrix if not NULL
  if(!is.null(xre) && !is.matrix(xre)) xre <- as.matrix(xre)
  ncx <- ncol(xre)  # Number of columns in xre
  
  # Constrain orig and h
  if(orig > T) orig <- T
  if(h < 1) h <- 1
  
  rmse <- rep(0, h)  # RMSE for different forecast horizons
  mabso <- rep(0, h)  # Mean absolute error
  nori <- T - orig  # Number of forecast origins
  
  err <- matrix(0, nori, h)  # Matrix to store forecast errors
  jlast <- T - 1  # The last index to forecast
  
  # Loop over each forecast origin
  for(n in orig:jlast){
    jcnt <- n - orig + 1
    x <- rt[1:n]  # Subset of time series up to n
    
    if(!is.null(xre)){
      # With external regressors
      pretor <- xre[1:n,]
      mm <- arima(x, order = regor, seasonal = seaor, xreg = pretor, fixed = fixed, include.mean = inc.mean)
      nx <- xre[(n+1):(n+h),]
      if(h == 1) nx <- matrix(nx, 1, ncx)
      fore <- predict(mm, h, newxreg = nx)
    } else {
      # Without external regressors
      mm <- arima(x, order = regor, seasonal = seaor, xreg = NULL, fixed = fixed, include.mean = inc.mean)
      fore <- predict(mm, h, newxreg = NULL)
    }
    
    kk <- min(T, (n + h))  # Effective forecast horizon
    nof <- kk - n  # Number of forecasts at origin n
    pred <- fore$pred[1:nof]  # Predicted values
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
  list(origin = orig, error = err, rmse = rmse, mabso = mabso)
}
