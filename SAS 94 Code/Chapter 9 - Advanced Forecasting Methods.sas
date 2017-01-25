/*---------------------------*/
/* Dynamic Regression Models */
/*---------------------------*/

/* ARIMA with Predictor Variables */
proc arima data=TIME.FPP_USCONSUMPTION;
	identify var=Consumption nlag=24 crosscorr=(Income);
	estimate input=(Income);
run;
quit;

/* New Values of Income Assumed to be Average */
proc means data=TIME.FPP_USCONSUMPTION;
	var Income;
run;

data New_USCon;
	input Consumption Income;
datalines;
. 0.7365571
. 0.7365571
. 0.7365571
. 0.7365571
. 0.7365571
. 0.7365571
. 0.7365571
. 0.7365571
;

data Combin_USCon;
	set TIME.FPP_USCONSUMPTION New_USCon;
run;

proc arima data=Combin_USCon plot=forecasts(all);
	identify var=Consumption nlag=24 crosscorr=(Income);
	estimate input=(Income) p=1 q=2;
	forecast lead=8;
run;
quit;

/* ARIMA with Linear Trend Regression */
data New_Austa;
	input Year Tourist_Arrivals;
datalines;
2011 .
2012 .
2013 .
2014 .
2015 .
2016 .
2017 .
2018 .
2019 .
2020 .
;

data New_Austa;
	set TIME.FPP_AUSTA New_Austa;
run;

proc arima data=New_Austa plot=forecasts(all);
	identify var=Tourist_Arrivals crosscorr=(Year) nlag=10;
	estimate input=(Year) p=2;
	forecast lead=10;
	title 'Forecasts From Linear Trend Plus AR(2)';
run;
quit;

proc arima data=New_Austa plot=forecasts(all);
	identify var=Tourist_Arrivals(1) crosscorr=(Year) nlag=10;
	estimate input=(Year);
	forecast lead=10;
	title 'Forecasts From Linear Trend Plus Stochastic Trend';
run;
quit;

/* Adding Lagged Values of Variables Into Regression */
data TIME.FPP_INSURANCE;
	set TIME.FPP_INSURANCE;
	Lag1_TV = LAG(TV_Advert);
	Lag2_TV = LAG2(TV_Advert);
	Lag3_TV = LAG3(TV_Advert);
run;

proc arima data=TIME.FPP_INSURANCE;
	identify var=Quotes crosscorr=(TV_Advert Lag1_TV);
	estimate input=(TV_Advert Lag1_TV) p=3;
run;
quit;

/* Future Values of Advertising Set to 8 */
data New_Ins;
	input Quotes TV_Advert;
datalines;
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
. 8
;

data New_Ins;
	set TIME.FPP_INSURANCE New_Ins;
	Lag1_TV = LAG(TV_Advert);
	Lag2_TV = LAG2(TV_Advert);
	Lag3_TV = LAG3(TV_Advert);
run;

proc arima data=New_Ins plot=forecasts(all);
	identify var=Quotes crosscorr=(TV_Advert Lag1_TV);
	estimate input=(TV_Advert Lag1_TV) p=3;
	forecast lead=20;
run;
quit;


/*------------------------*/
/* Vector Autoregressions */
/*------------------------*/

proc varmax data=TIME.FPP_USCONSUMPTION plot(unpack)=(residual model forecasts);
	model Consumption Income / p=3;
	output lead=12;
run;
quit;


/*----------------------------------------------*/
/* Neural Network Models - USE ENTERPRISE MINER */
/*----------------------------------------------*/


/*-----------------------------------------------------------------------*/
/* Forecasting Hierarchical or Grouped Time Series - USE FORECAST STUDIO */
/*-----------------------------------------------------------------------*/
