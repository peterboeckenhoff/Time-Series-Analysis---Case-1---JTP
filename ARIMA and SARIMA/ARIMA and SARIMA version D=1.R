## ============================================================
## Case 1: Forecasting Citi Bike Bicycle Trips
## ARIMA and SARIMA modeling for area 6 demand - D = 1 version
## ============================================================


## ---- 0. Packages -------------------------------------------
install.packages("forecast")
library(forecast)  # Arima(), auto.arima(), forecast(), checkresiduals()

## ---- 1. Load data --------------------------------------------
setwd("C:/Users/janne/OneDrive/Documents/Time Series Analytics/Case")


data_citibike$datetime <- as.POSIXct(
  paste(
    data_citibike$year,
    data_citibike$month,
    data_citibike$day,
    data_citibike$hour
  ),
  format = "%Y %m %d %H"
)

data_citibike <- data_citibike[order(data_citibike$datetime), ]

## ---- 2. Build the time series object for area 6 --------------
# Training sample: April 1 - July 31, 2023 (4 months)
train_df <- subset(data_citibike,
                   datetime >= as.POSIXct("2023-04-01 00:00:00") &
                     datetime <= as.POSIXct("2023-07-31 23:00:00"))

test_df  <- subset(data_citibike,
                   datetime >= as.POSIXct("2023-08-01 00:00:00") &
                     datetime <= as.POSIXct("2023-08-31 23:00:00"))


y_train <- ts(train_df$`area 6`, frequency = 24)

## ---- 2b. ACF/PACF plots for identifying p, q, P, Q -------------
## d = 0 taken as given (Boot-ADF / Pantula principle unit root test).
##   - PACF cuts off after lag p, ACF tails off  -> suggests AR(p)
##   - ACF cuts off after lag q, PACF tails off   -> suggests MA(q)
##   - both tail off                              -> mixed ARMA
acf(y_train, lag.max = 48, main = "ACF - area 6 (training)")
pacf(y_train, lag.max = 48, main = "PACF - area 6 (training)")

acf(y_train, lag.max = 24 * 5, main = "ACF - seasonal lags")
abline(v = seq(24, 24 * 5, by = 24), col = "red", lty = 2)

pacf(y_train, lag.max = 24 * 5, main = "PACF - seasonal lags")
abline(v = seq(24, 24 * 5, by = 24), col = "red", lty = 2)

## ==================== D = 1  =========================

D_hat <- 1
D_hat

y_train_sdiff <- diff(y_train, lag = 24, differences = D_hat)

acf(y_train_sdiff, lag.max = 48, main = "ACF - seasonally differenced (short lags)")
pacf(y_train_sdiff, lag.max = 48, main = "PACF - seasonally differenced (short lags)")

acf(y_train_sdiff, lag.max = 24 * 5, main = "ACF - seasonally differenced, seasonal lags")
abline(v = seq(24, 24 * 5, by = 24), col = "red", lty = 2)

pacf(y_train_sdiff, lag.max = 24 * 5, main = "PACF - seasonally differenced, seasonal lags")
abline(v = seq(24, 24 * 5, by = 24), col = "red", lty = 2)

## ---- 3. ARIMA models -------------------------------------------

## 3a. Manually specified ARIMA (non-seasonal).
## p, q chosen by AIC grid search - does NOT depend on D, so this
## section is identical between the D=0 and D=1 files.
p_range <- 0:3
q_range <- 0:3

grid_results_pq <- data.frame()
for (p_try in p_range) {
  for (q_try in q_range) {
    fit_try <- tryCatch(
      Arima(y_train, order = c(p_try, 0, q_try)),
      error = function(e) NULL
    )
    if (!is.null(fit_try)) {
      grid_results_pq <- rbind(grid_results_pq,
                               data.frame(p = p_try, q = q_try, AIC = AIC(fit_try)))
    }
  }
}

grid_results_pq <- grid_results_pq[order(grid_results_pq$AIC), ]
print(grid_results_pq)   # lowest AIC at the top

best_pq <- grid_results_pq[1, ]
p <- best_pq$p
q <- best_pq$q
cat("Selected p =", p, ", q =", q, "(lowest AIC in grid)\n")

fit_arima_manual <- Arima(y_train, order = c(p, 0, q))
summary(fit_arima_manual)
checkresiduals(fit_arima_manual)

## 3b. Automatic search over the ARIMA class (Hyndman & Khandakar, 2008)
fit_arima_auto <- auto.arima(y_train, d = 0, seasonal = FALSE)
summary(fit_arima_auto)
checkresiduals(fit_arima_auto)

## ---- 4. SARIMA models --------------------------------------------

## 4a. Manually specified SARIMA. P, Q chosen by AIC grid search under
## D = 1 
P_range <- 0:2
Q_range <- 0:2

grid_results <- data.frame()
for (P_try in P_range) {
  for (Q_try in Q_range) {
    fit_try <- tryCatch(
      Arima(y_train, order = c(p, 0, q),
            seasonal = list(order = c(P_try, D_hat, Q_try), period = 24)),
      error = function(e) NULL
    )
    if (!is.null(fit_try)) {
      grid_results <- rbind(grid_results,
                            data.frame(P = P_try, Q = Q_try, AIC = AIC(fit_try)))
    }
  }
}

grid_results <- grid_results[order(grid_results$AIC), ]
print(grid_results)

best <- grid_results[1, ]
P <- best$P
Q <- best$Q
cat("Selected P =", P, ", Q =", Q, "(lowest AIC in grid)\n")

fit_sarima_manual <- Arima(y_train,
                           order = c(p, 0, q),
                           seasonal = list(order = c(P, D_hat, Q), period = 24))
summary(fit_sarima_manual)
checkresiduals(fit_sarima_manual)

## 4b. Automatic SARIMA search - lets auto.arima choose D on its own,

fit_sarima_auto <- auto.arima(y_train, d = 0, seasonal = TRUE)
summary(fit_sarima_auto)
checkresiduals(fit_sarima_auto)
