/*------------------------------*/
/* Simple Exponential Smoothing */
/*------------------------------*/

proc sgplot data=TIME.FPP_OIL(where=(1996 <= Year <= 2007));
	series x = Year y = Oil;
	yaxis label = 'Oil (Millions of Tonness)';
	title;
run;

/* Simple Exponential Smoothing Model - Cannot Find Code ot Fix Parameter and Not Let SAS Estimate */
proc esm data=TIME.FPP_OIL(where=(1996 <= Year <= 2007)) print=(estimates statistics) plot=(modelforecasts) lead=3;
	forecast Oil / model=simple;
	title;
run;


/*---------------------------*/
/* Holt's Linear Trend Model */
/*---------------------------*/

/* Holt's Linear Trend ESM */
proc esm data=TIME.FPP_AUSAIR(where=(1990 <= Year <= 2004)) print=(estimates statistics) plot=(modelforecasts) lead=3 outfor=FOR1;
	forecast Passengers / model=linear;
	title;
run;

/* Exponential Trend ESM */
proc esm data=TIME.FPP_AUSAIR(where=(1990 <= Year <= 2004)) print=(estimates statistics) plot=(modelforecasts) lead=3 outfor=FOR2;
	forecast Passengers / model=linear transform=log;
	title;
run;

/* Damped Trend ESM */
proc esm data=TIME.FPP_AUSAIR(where=(1990 <= Year <= 2004)) print=(estimates statistics) plot=(modelforecasts) lead=3 outfor=FOR3;
	forecast Passengers / model=dampedtrend;
	title;
run;

/* Plot Comparing All Three Above Models */
data ESM_Compare;
	merge FOR1(rename=(Predict = Predict_L)) FOR2(rename=(Predict = Predict_E)) FOR3 (rename=(Predict = Predict_D));
	by _TIMEID_;
	Year = 1989 + _TIMEID_;
run;

proc sgplot data=ESM_Compare;
	series x = Year y = Actual / legendlabel='Actual Values' lineattrs=(color=black);
	series x = Year y = Predict_L / legendlabel='Holt Linear Trend' lineattrs=(color=blue);
	series x = Year y = Predict_E / legendlabel='Exponential Trend' lineattrs=(color=red);
	series x = Year y = Predict_D / legendlabel='Damped Trend' lineattrs=(color=yellow);
	yaxis label = 'Air Passengers in Australia (Millions)';
	title 'Forecasts from Holt Method with Other Methods';
run;


/*----------------------*/
/* Damped Trend Methods */
/*----------------------*/

/*Simple ESM */
proc esm data=TIME.FPP_LIVESTOCK(where=(1970 <= Year <= 2000)) print=(estimates statistics) plot=(modelforecasts) lead=10 outfor=FOR1;
	forecast Sheep / model=simple;
	title;
run;

/*Holt's Linear Trend ESM */
proc esm data=TIME.FPP_LIVESTOCK(where=(1970 <= Year <= 2000)) print=(estimates statistics) plot=(modelforecasts) lead=10 outfor=FOR2;
	forecast Sheep / model=linear;
	title;
run;

/*Exponential Trend ESM */
proc esm data=TIME.FPP_LIVESTOCK(where=(1970 <= Year <= 2000)) print=(estimates statistics) plot=(modelforecasts) lead=10 outfor=FOR3;
	forecast Sheep / model=linear transform=log;
	title;
run;

/*Damped Trend ESM */
proc esm data=TIME.FPP_LIVESTOCK(where=(1970 <= Year <= 2000)) print=(estimates statistics) plot=(modelforecasts) lead=10 outfor=FOR4;
	forecast Sheep / model=dampedtrend;
	title;
run;

/* Comparing All Forecasts on One Chart */
data ESM_Compare2;
	merge FOR1(rename=(Predict = Predict_S)) FOR2(rename=(Predict = Predict_L)) FOR3(rename=(Predict = Predict_E)) FOR4(rename=(Predict = Predict_D));
	by _TIMEID_;
	Year = 1969 + _TIMEID_;
run;

data ESM_Compare2;
	merge ESM_Compare2 TIME.FPP_LIVESTOCK;
	by Year;
run;

proc sgplot data=ESM_Compare2;
	series x = Year y = Sheep / legendlabel='Actual Values' lineattrs=(color=black);
	series x = Year y = Predict_S / legendlabel='Simple ESM' lineattrs=(color=red);
	series x = Year y = Predict_L / legendlabel='Holt Linear Trend' lineattrs=(color=yellow);
	series x = Year y = Predict_E / legendlabel='Exponential Trend' lineattrs=(color=blue);
	series x = Year y = Predict_D / legendlabel='Damped Trend' lineattrs=(color=lightblue);
	yaxis label = 'Livestock, Sheep in Asia (Millions)';
	title 'Forecasts from Holt Method with Other Methods';
run;


/*------------------------------*/
/* Holt-Winters Seasonal Method */
/*------------------------------*/

/* Additive Holt Winters Model */
proc esm data=TIME.FPP_AUSTOURISTS(where=(2005 <= Date)) print=(estimates statistics) plot=(modelforecasts) lead=8 outfor=FOR1;
	id Date interval=quarter;
	forecast Tourists / model=addwinters;
	title;
run;

/* Multiplicative Holt Winters Model */
proc esm data=TIME.FPP_AUSTOURISTS(where=(2005 <= Date)) print=(estimates statistics) plot=(modelforecasts) lead=8 outfor=FOR2;
	id Date interval=quarter;
	forecast Tourists / model=multwinters;
	title;
run;

/* Compare Two Above Models */
data ESM_Compare3;
	merge FOR1(rename=(Predict=Predict_A)) FOR2(rename=(Predict=Predict_M));
	by Date;
run;

proc sgplot data=ESM_Compare3;
	series x = Date y = Actual / legendlabel='Actual Values' lineattrs=(color=black);
	series x = Date y = Predict_A / legendlabel='Holt-Winters Additive' lineattrs=(color=red);
	series x = Date y = Predict_M / legendlabel='Holt-Winters Multiplicative' lineattrs=(color=yellow);
	yaxis label = 'International Visitor Night in Australia (Millions)';
	title 'Forecasts from Holt-Winters Methods';
run;


/*--------------------------------------------------------------------------------*/
/* Innovations State Space Models for Exponential Smoothing - Section Not Covered */
/*--------------------------------------------------------------------------------*/

