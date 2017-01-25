/*----------------------------*/
/* Regression and Correlation */
/*----------------------------*/

proc sgplot data=TIME.FPP_FUEL;
	reg x = City y = Carbon;
	xaxis label='City (MPG)';
	yaxis label='Carbon Footprint (Tons Per Year)';
	title;
run;

proc reg data=TIME.FPP_FUEL;
	model Carbon = City;
run;
quit;


/*---------------------------------*/
/* Evaluating the Regression Model */
/*---------------------------------*/

proc reg data=TIME.FPP_FUEL plot(unpack)=diagnostics;
	model Carbon = City;
run;
quit;


/*-----------------------------*/
/* Forecasting with Regression */
/*-----------------------------*/

/* Add New Observation for Scoring */
data New_Fuel;
	input Carbon City;
datalines;
. 30
;

data TIME.FPP_FUEL2;
	set TIME.FPP_FUEL New_Fuel;
run;

/* Build Regression and Score New Observation with Confidence and Prediction Intervals */
proc reg data=TIME.FPP_FUEL2;
	model Carbon = City / p clm cli;
run;
quit;


/*-----------------------*/
/* Statistical Inference */
/*-----------------------*/

/* Basic Regression Output */
proc reg data=TIME.FPP_FUEL2 plot=NONE;
	model Carbon = City;
run;
quit;

/* Confidence Intervals for Parameter Estimates */
proc reg data=TIME.FPP_FUEL2 plot=NONE;
	model Carbon = City / clb;
run;
quit;


/*-----------------------------*/
/* Non-linear Functional Forms */
/*-----------------------------*/

/* Plotting Linear vs. Log-Log */
data TIME.FPP_FUEL;
	set TIME.FPP_FUEL;
	Log_Carbon = log(Carbon);
	Log_City = log(City);
run;

proc sgplot data=TIME.FPP_FUEL;
	reg x = City y = Carbon;
	xaxis label='City (MPG)';
	yaxis label='Carbon Footprint (Tons Per Year)';
	title;
run;

proc sgplot data=TIME.FPP_FUEL;
	reg x = Log_City y = Log_Carbon;
	xaxis label='Log of City';
	yaxis label='Log of Carbon Footprint';
	title;
run;

/* Regression Predicting Log of Carbon Instead */
proc reg data=TIME.FPP_FUEL plot(unpack)=diagnostics;
	model Log_Carbon = Log_City;
run;
quit;


/*----------------------------------*/
/* Regression with Time Series Data */
/*----------------------------------*/

/* Visualizing Consumption and Income Across Time */
proc sgplot data=TIME.FPP_USCONSUMPTION;
	series x = Date y = Consumption / legendlabel='Consumption' lineattrs=(color=black);
	series x = Date y = Income / legendlabel='Income' lineattrs=(color=red);
	yaxis label='% Change in Consumption and Income';
	title;
run;
quit;

proc sgplot data=TIME.FPP_USCONSUMPTION;
	reg x = Income y = Consumption;
	xaxis label='% Change in Income';
	yaxis label='% Change in Consumption';
run;
quit;

/* Build Regression Using Income to Predict Consumption */
proc reg data=TIME.FPP_USCONSUMPTION plot=NONE;
	model Consumption = Income;
run;
quit;

/* Scenario Based Forecast of Next Two Quarters With Income Estimates */
data New_Consumption;
	input Consumption Income;
datalines;
. -1
. 1
;

data TIME.FPP_USCONSUMPTION2;
	set TIME.FPP_USCONSUMPTION New_Consumption;
run;

/* Build Regression and Score New Observation with Confidence and Prediction Intervals */
proc reg data=TIME.FPP_USCONSUMPTION2;
	model Consumption = Income / p clm cli;
run;
quit;

/* Linear Trend Regression Model */
proc reg data=TIME.FPP_AUSTA plot=NONE;
	model Tourist_Arrivals = Year;
run;
quit;

/* Look at Residual Correlation for Both Consumption and Tourism */
proc reg data=TIME.FPP_USCONSUMPTION noprint;
	model Consumption = Income;
	output out=CON_RES r=Residuals;
run;
quit;

proc arima data=CON_RES;
	identify var=Residuals;
run;
quit;

proc reg data=TIME.FPP_AUSTA noprint;
	model Tourist_Arrivals = Year;
	output out=TOUR_RES r=Residuals;
run;
quit;

proc arima data=TOUR_RES;
	identify var=Residuals nlag=12;
run;
quit;

/* Spurious Regression */
proc sgplot data=TIME.FPP_AUSAIR;
	series x = Year y = Passengers;
	yaxis label='Air Passengers in Australia (Millions)';
	title;
run;
quit;

proc sgplot data=TIME.FPP_GUINEARICE;
	series x = Year y = Rice;
	yaxis label='Rice Production in Guinea (Million Tons)';
	title;
run;
quit;

data Spurious;
	merge TIME.FPP_AUSAIR TIME.FPP_GUINEARICE;
	by Year;
run;

proc sgplot data=Spurious;
	scatter x = Rice y = Passengers;
	xaxis label='Rice Production in Guinea (Million Tons)';
	yaxis label='Air Passengers in Australia (Millions)';
run;
quit;

proc reg data=Spurious plot=NONE;
	model Passengers = Rice / dwProb;
run;
quit;
