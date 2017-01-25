/*-------------------------------*/
/* Stationarity and Differencing */
/*-------------------------------*/

/* Which of the following are Stationary? */
data TIME.FPP_DJ; /* Creating Difference for Dow Jones Index Values to Get Daily Change */
	set TIME.FPP_DJ;
	Diff_DJ = Dow_Jones - LAG(Dow_Jones);
run;

proc sgplot data=TIME.FPP_DJ;
	series x = Day y = Dow_Jones;
	yaxis label = 'Dow Jones Index';
	title;
run;

proc sgplot data=TIME.FPP_DJ;
	series x = Day y = Diff_DJ;
	yaxis label = 'Daily Change in Dow Jones Index';
	title;
run;

proc sgplot data=TIME.FPP_STRIKES;
	series x = Year y = Strikes;
	yaxis label = 'Strikes';
	title;
run;

proc sgplot data=TIME.FPP_HSALES;
	series x = Date y = Housing_Sales;
	yaxis label = 'Monthly Housing Sales (Millions)';
	title;
run;

proc sgplot data=TIME.FPP_EGGS;
	series x = Year y = Eggs;
	yaxis label = 'Eggs';
	title;
run;

proc sgplot data=TIME.FPP_PIGS;
	series x = Date y = Pigs;
	yaxis label = 'Pigs';
	title;
run;

proc sgplot data=TIME.FPP_LYNX;
	series x = Year y = Lynx;
	yaxis label = 'Lynx';
	title;
run;

proc sgplot data=TIME.FPP_BEER;
	series x = Date y = Beer;
	yaxis label = 'Beer';
	title;
run;

proc sgplot data=TIME.FPP_ELEC;
	series x = Date y = Elec_Prod;
	yaxis label = 'Australian Monthly Electric Production';
	title;
run;

/* ACF of Dow Jones Index */
proc arima data=TIME.FPP_DJ plot(unpack only)=(SERIES(ACF));
	identify var=Dow_Jones;
	title;
run;
quit;

/* ACF of Daily Changes in Dow Jones Index */
proc arima data=TIME.FPP_DJ plot(unpack only)=(SERIES(ACF));
	identify var=Diff_DJ;
	title;
run;
quit;

/* Plots of Antidiabetic Drug Sales */
data TIME.FPP_A10;
	set TIME.FPP_A10;
	Log_Sales = log(Sales);
	Diff_Log_Sales = Log_Sales - LAG12(Log_Sales);
run;

proc sgplot data=TIME.FPP_A10;
	series x = Date y = Sales;
	yaxis label = 'Sales ($Millions)';
	title 'Antidiabetic Drug Sales';
run;

proc sgplot data=TIME.FPP_A10;
	series x = Date y = Log_Sales;
	yaxis label = 'Monthly Log Sales';
	title 'Antidiabetic Drug Sales';
run;

proc sgplot data=TIME.FPP_A10;
	series x = Date y = Diff_Log_Sales;
	yaxis label = 'Annual Change in Monthly Log Sales';
	title 'Antidiabetic Drug Sales';
run;

/* Unit Root Tests - Both Augmented Dickey-Fuller and Phillips-Perron */
proc arima data=TIME.FPP_A10;
	identify var=Diff_Log_Sales stationarity=(adf=2);
	identify var=Diff_Log_Sales stationarity=(pp=2);
	title;
run;
quit;

/* Seasonal Unit Root Tests - Augmented Dickey-Fuller */
proc arima data=TIME.FPP_A10;
	identify var=Log_Sales stationarity=(adf=2 dlag=12);
	title;
run;
quit;


/*-----------------------*/
/* Autoregressive Models */
/*-----------------------*/

/* Simulate an AR1 Model: Y = 18 - 0.8*Lag(Y) + Error */
proc iml;
	phi = {1 0.8};
	theta = {1};
	mu = 10;
	sigma = 1;

	Y = ARMASIM(phi, theta, mu, sigma, 100, 12345);

	create TIME.FPP_AR1 var {Y};
	append;
	close TIME.FPP_AR1;
quit;

/* Fitting an AR1 Model in SAS */
proc arima data=TIME.FPP_AR1;
	identify var=Y;
	estimate p=1 method=ML;
run;
quit;

/* Simulate an AR2 Model: Y = 8 + 1.3*Lag(Y) - 0.7*Lag2(Y) + Error */
proc iml;
	phi = {1 -1.3 0.7};
	theta = {1};
	mu = 20;
	sigma = 1;

	Y = ARMASIM(phi, theta, mu, sigma, 100, 12345);

	create TIME.FPP_AR2 var {Y};
	append;
	close TIME.FPP_AR2;
quit;

/* Fitting an AR2 Model in SAS */
proc arima data=TIME.FPP_AR2;
	identify var=Y;
	estimate p=2 method=ML;
run;
quit;


/*-----------------------*/
/* Moving Average Models */
/*-----------------------*/

/* Simulate an MA1 Model: Y = 20 + Error + 0.8*Lag(Error) */
proc iml;
	phi = {1};
	theta = {1 0.8};
	mu = 20;
	sigma = 1;

	Y = ARMASIM(phi, theta, mu, sigma, 100, 12345);

	create TIME.FPP_MA1 var {Y};
	append;
	close TIME.FPP_MA1;
quit;

/* Fitting an MA1 Model in SAS */
proc arima data=TIME.FPP_MA1;
	identify var=Y;
	estimate q=1 method=ML;
run;
quit;

/* Simulate an MA2 Model: Y = 0 + Error - 1*Lag(Error) + 0.8*Lag2(Error) */
proc iml;
	phi = {1};
	theta = {1 -1 0.8};
	mu = 0;
	sigma = 1;

	Y = ARMASIM(phi, theta, mu, sigma, 100, 12345);

	create TIME.FPP_MA2 var {Y};
	append;
	close TIME.FPP_MA2;
quit;

/* Fitting an MA2 Model in SAS */
proc arima data=TIME.FPP_MA2;
	identify var=Y;
	estimate q=2 method=ML;
run;
quit;


/*---------------------------*/
/* Non-Seasonal ARIMA Models */
/*---------------------------*/

/* Automatic Selection Techniques - MINIC(auto.arima function in R), SCAN, ESACF */
proc arima data=TIME.FPP_USCONSUMPTION;
	identify var=Consumption minic P=(0:10) Q=(0:10);
run;
quit;

proc arima data=TIME.FPP_USCONSUMPTION;
	identify var=Consumption scan P=(0:10) Q=(0:10);
run;
quit;

proc arima data=TIME.FPP_USCONSUMPTION;
	identify var=Consumption esacf P=(0:10) Q=(0:10);
run;
quit;

/* Forecast an AR3 Model as Selected by the MINIC */
proc arima data=TIME.FPP_USCONSUMPTION plot=(ALL);
	identify var=Consumption minic P=(0:10) Q=(0:10);
	estimate p=3 method=ML;
	forecast lead=10;
run;
quit;

/* ACF and PACF Plots Already Included in PROC ARIMA Idenfity Statement */
proc arima data=TIME.FPP_USCONSUMPTION plot=(ALL);
	identify var=Consumption;
run;
quit;


/*------------------------------*/
/* ARIMA Modeling in R (in SAS) */
/*------------------------------*/

/* Plotting Seasonally Adjusted Data by Default or Through SGPLOT */
proc timeseries data=TIME.FPP_ELECEQUIP plots=(SA) outdecomp=decomp;
	id Date interval=month;
	var NOI;
	title;
run;

proc sgplot data=decomp;
	series x = Date y = SA / lineattrs=(color=blue);
	series x = Date y = ORIGINAL / legendlabel='New Orders Index' lineattrs=(color=gray);
	yaxis label = 'New Orders Index';
	title 'Electrical Equipment Manufacturing (Euro Area)';
run;

/* Modeling Seasonally Adjusted Series with a First Difference */
proc arima data=decomp;
	identify var=SA(1);
run;
quit;

/* Spikes at 1 and 3 in PACF with Exponential Decrease in ACF = AR(3) */
proc arima data=decomp;
	identify var=SA(1);
	estimate p=3 method=ML;
run;
quit;

/* Remove Spike at 2 Since Insignificant */
proc arima data=decomp;
	identify var=SA(1);
	estimate p=(1,3) method=ML;
run;
quit;

/* Forecast Model */
proc arima data=decomp plots=(ALL);
	identify var=SA(1);
	estimate p=(1,3) method=ML;
	forecast lead = 12;
run;
quit;


/*-----------------------*/
/* Seasonal ARIMA Models */
/*-----------------------*/

/* Look at Seasonally Differenced Data to Remove Season */
proc arima data=TIME.FPP_EURETAIL;
	identify var=Retail_Index(4);
	title;
run;
quit;

/* Look at Seasonally Differenced Data Plus First Order Difference */
proc arima data=TIME.FPP_EURETAIL;
	identify var=Retail_Index(1,4);
run;
quit;

/* Estimate with MA term at Lags 1 and 4 (Seasonal Lag) */
proc arima data=TIME.FPP_EURETAIL;
	identify var=Retail_Index(1,4);
	estimate q=(1,4) method=ML;
run;
quit;

/* Estimate with MA term at Lags 1,2,3 and 4 (Seasonal Lag) */
proc arima data=TIME.FPP_EURETAIL;
	identify var=Retail_Index(1,4);
	estimate q=4 method=ML;
run;
quit;

/* Forecast Model */
proc arima data=TIME.FPP_EURETAIL plots=(ALL);
	identify var=Retail_Index(1,4);
	estimate q=4 method=ML;
	forecast lead = 12;
run;
quit;

/* Cortecosteroid Drug Sales in Australia Example */
proc sgplot data=TIME.FPP_H02;
	series x = Date y = H02;
	yaxis label='H02 Sales (Million Scripts)';
	title;
run;

data TIME.FPP_H02;
	set TIME.FPP_H02;
	Log_H02 = log(H02);
run;

proc sgplot data=TIME.FPP_H02;
	series x = Date y = Log_H02;
	yaxis label='Log H02 Sales';
	title;
run;

/* Take Seasonal Difference */
proc arima data=TIME.FPP_H02;
	identify var=Log_H02(12);
run;
quit;

/* Model the Data with Different Models and Output AIC and SBC Values */
proc arima data=TIME.FPP_H02;
	identify var=Log_H02(12);
	estimate p=(1,2,3,12,24) method=ML;
	estimate p=(1,2,3,12,24) q=1 method=ML;
	estimate p=(1,2,3,12,24) q=2 method=ML;
	estimate p=(1,2,3,12) q=1 method=ML;
	estimate p=(1,2,3) q=(1,12) method=ML;
	estimate p=(1,2,3) q=(1,12,24) method=ML;
	estimate p=(1,2,3,12) q=(1,12) method=ML;
	ods output FitStatistics = Fit;
run;
quit;

/* Compare Above Models Using AIC - Model 6 was Best */
data Fit_AIC;
	set Fit;
	if Label1 ne 'AIC' then delete;
run;

/* Compare Above Models Using SBC - Model 5 was Best */
data Fit_SBC;
	set Fit;
	if Label1 ne 'SBC' then delete;
run;

/* Using Model 6 From Above - Ljung-Box Test Passes White Noise at Reasonable Alpha Level */
proc arima data=TIME.FPP_H02;
	identify var=Log_H02(12);
	estimate p=(1,2,3) q=(1,12,24) method=ML;
run;
quit;

/* Build Models on Training Set and Forecast*/
proc arima data=TIME.FPP_H02(where=(Date <= '01jun2006'd));
	identify var=Log_H02(12);
	estimate p=(1,2,3,12,24);
	forecast lead=24 outfor=FOR1;
	estimate p=(1,2,3,12,24) q=1;
	forecast lead=24 outfor=FOR2;
	estimate p=(1,2,3,12,24) q=2;
	forecast lead=24 outfor=FOR3;
	estimate p=(1,2,3,12) q=1;
	forecast lead=24 outfor=FOR4;
	estimate p=(1,2,3) q=(1,12);
	forecast lead=24 outfor=FOR5;
	estimate p=(1,2,3) q=(1,12,24);
	forecast lead=24 outfor=FOR6;
	estimate p=(1,2,3,12) q=(1,12);
	forecast lead=24 outfor=FOR7;
	estimate p=(1,2,3,4) q=(1,2,3,12);
	forecast lead=24 outfor=FOR8;
	estimate p=(1,2,3) q=(1,2,3,12);
	forecast lead=24 outfor=FOR9;
	estimate p=(1,2,3,4) q=(1,2,12);
	forecast lead=24 outfor=FOR10;
	estimate p=(1,2,3) q=(1,2,12);
	forecast lead=24 outfor=FOR11;

	identify var=Log_H02(1,12);
	estimate p=(1,2) q=(1,2,3,12);
	forecast lead=24 outfor=FOR12;
	estimate p=(1,2) q=(1,2,3,4,12);
	forecast lead=24 outfor=FOR13;
	estimate p=(1,2) q=(1,2,3,4,5,12);
	forecast lead=24 outfor=FOR14;
run;
quit;

/* Compare Above Models Using RMSE From Validation Data Set - Model 7 Wins */
data ARIMA_Compare;
	merge TIME.FPP_H02 
		  FOR1(rename=(Forecast=Forecast1))
		  FOR2(rename=(Forecast=Forecast2))
		  FOR3(rename=(Forecast=Forecast3))
		  FOR4(rename=(Forecast=Forecast4))
		  FOR5(rename=(Forecast=Forecast5))
		  FOR6(rename=(Forecast=Forecast6))
		  FOR7(rename=(Forecast=Forecast7))
		  FOR8(rename=(Forecast=Forecast8))
		  FOR9(rename=(Forecast=Forecast9))
		  FOR10(rename=(Forecast=Forecast10))
		  FOR11(rename=(Forecast=Forecast11))
		  FOR12(rename=(Forecast=Forecast12))
		  FOR13(rename=(Forecast=Forecast13))
		  FOR14(rename=(Forecast=Forecast14));
	if _N_ <= 180 then delete;
	Log_H02 = log(H02);
run;

%macro mae_rmse_sql(
        dataset /* Data set which contains the actual and predicted values */, 
        actual /* Variable which contains the actual or observed valued */, 
        predicted /* Variable which contains the predicted value */
        );
%global mae rmse; /* Make the scope of the macro variables global */
proc sql noprint;
    select count(1) into :count from &dataset;
    select mean(abs(&actual-&predicted)) format 20.10 into :mae from &dataset;
    select sqrt(mean((&actual-&predicted)**2)) format 20.10 into :rmse from &dataset;
quit;
%mend;

%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST1);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST2);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST3);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST4);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST5);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST6);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST7);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST8);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST9);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST10);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST11);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST12);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST13);
%put NOTE: mae=&mae rmse=&rmse;
%mae_rmse_sql(ARIMA_Compare, Log_H02, FORECAST14);
%put NOTE: mae=&mae rmse=&rmse;

/* Plot Model 7 Forecast with Original Values */
data Final_H02;
	merge TIME.FPP_H02 FOR7;
	Log_H02 = log(H02);
	H02_Forecast = exp(Forecast);
	if _N_ > 180 then H02_Lower = exp(L95);
	if _N_ > 180 then H02_Upper = exp(U95);
run;

proc sgplot data=Final_H02;
	band x = Date lower = H02_Lower upper = H02_Upper / legendlabel='95% Confidence Inteval';
	series x = Date y = H02_Forecast / legendlabel='Predicted Values';
	series x = Date y = H02 / legendlabel='Actual Sales' lineattrs=(color=red);
	yaxis label = 'H02 Sales (Million Scripts)';
	title 'Forecasted vs. Actual Series';
run;

proc sgplot data=Final_H02(where=(Date > '01jun2006'd));
	band x = Date lower = H02_Lower upper = H02_Upper / legendlabel='95% Confidence Inteval';
	series x = Date y = H02_Forecast / legendlabel='Predicted Values';
	series x = Date y = H02 / legendlabel='Actual Sales' lineattrs=(color=red);
	yaxis label = 'H02 Sales (Million Scripts)';
	title 'Forecasted vs. Actual Series';
run;
