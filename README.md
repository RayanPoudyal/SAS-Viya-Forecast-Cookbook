# SAS-Viya-Forecast-Cookbook
SAS Viya forecast code illustrations using the examples in the online book Forecasting: principles and practice by Rob Hyndman and George Athana­sopou­los (https://www.otexts.org/book/fpp)

##Cookbook Outline
###Chapter 1 to 3: getting started, the forecaster's toolbox, and judgemental forecasts
no code or examples in the book. 

###Chapter 4: simple linear regression
We use a combination of DATA step and PROC REGSELECT to illustrate
    1. Forecasting using PROC REGSELECT
    2. Check residual autocorrelation using TSA AUTOCORRELATION function
    3. Test the residual autocorrelation using TSA WHITENOISE function. Please note that the book uses the Durbin-Watson test instead

###Chapter 5: multiple linear regression
We use a combination of DATA step and PROC REGSELECT to illustrate
    1. Forecasting using PROC REGSELECT
    2. Check residual autocorrelation using TSA AUTOCORRELATION function
    3. Test the residual autocorrelation using TSA WHITENOISE function. Please note that the book uses the Durbin-Watson test instead
    4. Use variable selection features to select proper predictors

###Chapter 6: time series decomposition
We use a combination of DATA step and PROC TSMODEL with TSA, TSM, and ATSM packages to illustrate
    1. Seasonal decomposition using TSA SEASONALDEOCMP function
    2. Moving average smoothing using TSA MOVINGSUMMARY function
    3. Forecasting each component and combine the results to form the final forecasts using the TSM and ATSM package

###Chapter 7: exponential smoothing
We use a combination of DATA step and PROC TSMODEL with TSM, and ATSM packages to illustrate
    1. Forecasting each individual ESM model type in separate steps as described in the book
    2. Forecasting each individual ESM model type in a single step (one data pass) and output multiple forecasts
    3. Forecasting each individual ESM model type and select the best in a single step (one data pass) and output the best forecast
    4. Forecasting each individual ESM model type and combine all forecasts in a single step (one data pass) and output the combined forecast
    5. Forecasting each individual ESM model type and select among all the model types and the combined model in a single step (one data pass) and output the combined forecast
    
###Chapter 8: ARIMA models
We use a combination of DATA step and PROC TSMODEL with TSA, TSM, and ATSM packages to illustrate
    1. Identify time series property such as stationarity (augmented Dickey-Fuller unit root test) and tentative autoregressive (p) and moving-average (q) orders using the TSA STATIONARITYTEST and ARMAORDERS functions as described in the book
    2. Forecasting the identified ARIMA model using the TSM and ATSM package
    3. Identify and forecasting the identified ARIMA model in a single step 
    4. Forecasting using the ATSM package to automatically identify the tentative ARIMA model in a single step

###Chapter 9: Advanced forecasting methods
We use a combination of DATA step and PROC TSMODEL with TSA, TSM, and ATSM packages, PROC NNET, and PROC TSRECONCILE to illustrate
    1. Identify time series property such as stationarity and tentative autoregressive (p) and moving-average (q) orders and cross correlation (the transfer function) using the TSA STATIONARITYTEST and ARMAORDERS functions as described in the book
    2. Forecasting the identified ARIMAX model using the TSM and ATSM package
    3. Identify and forecasting the identified ARIMAX model in a single step 
    4. Forecasting using the ATSM package to automatically identify the tentative ARIMAX model in a single step
    5. Forecasting using the neural net model using PROC CAS along with the neuralNet CAS actionset
    6. Hierarchical forecasting using PROC TSMODEL and PROC TSRECONCILE
