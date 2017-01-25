/*--------------------------------------------*/
/* Introduction to Multiple Linear Regression */
/*--------------------------------------------*/

/* Scatterplot Matrix of Variables */
proc corr data=TIME.FPP_CREDIT nosimple plots(maxpoints=NONE)=matrix(nvar=all histogram);
	var Score Savings Income Time_Address Time_Employed;
	title;
run;

/* Scatterplot Matrix with Log Transformations on Some Variables */
data TIME.FPP_CREDIT;
	set TIME.FPP_CREDIT;
	Log_Savings = log(Savings+1);
	Log_Income = log(Income+1);
	Log_Address = log(Time_Address+1);
	Log_Employed = log(Time_Employed+1);
run;

proc corr data=TIME.FPP_CREDIT nosimple plots(maxpoints=NONE)=matrix(nvar=all histogram);
	var Score Log_Savings Log_Income Log_Address Log_Employed;
	title;
run;

/* Multiple Linear Regression Predicted Credit Score */
proc reg data=TIME.FPP_CREDIT plot=DIAGNOSTICS;
	model Score = Log_Savings Log_Income Log_Address Log_Employed;
run;
quit;
	

/*------------------------*/
/* Some Useful Predictors */
/*------------------------*/

/* Create Seasonal Dummy Variables */
data TIME.FPP_AUSBEER;
	set TIME.FPP_AUSBEER;
	Year = YEAR(Date);
	Month = MONTH(Date);
	Trend = _N_;
	if MONTH(Date) = 1 then Q1 = 1; else Q1 = 0;
	if MONTH(Date) = 4 then Q2 = 1; else Q2 = 0;
	if MONTH(Date) = 7 then Q3 = 1; else Q3 = 0;
	if MONTH(Date) = 10 then Q4 = 1; else Q4 = 0;
run;

/* Build Regression Model with Trend and Seasonal Dummies */
proc reg data=TIME.FPP_AUSBEER(where=(1992 <= Year <= 2006));
	model AUS_Beer = Trend Q2 Q3 Q4;
	output out=Beer_Pred p=Pred;
run;
quit;

proc sgplot data=Beer_Pred;
	series x = Date y = AUS_Beer / legendlabel='Actual Values' lineattrs=(color=black);
	series x = Date y = Pred / legendlabel='Predicted Values' lineattrs=(color=red);
	yaxis label='Beer Production';
	title 'Quarterly Beer Production';
run;
quit;

/* Predict New Values */
data Pred_AUSBEER;
	set TIME.FPP_AUSBEER;
	if Year > 2006 then AUS_Beer = .;
run;

proc reg data=Pred_AUSBEER(where=(1992 <= Year));
	model AUS_Beer = Trend Q2 Q3 Q4;
	output out=Beer_Pred2 p=Pred LCL=Lower UCL=Upper;
run;
quit;

data Beer_Pred2;
	set Beer_Pred2;
	if Year <= 2006 then Lower = .;
	if Year <= 2006 then Upper = .;
run;

proc sgplot data=Beer_Pred2;
	band x = Date LOWER = Lower UPPER = Upper / legendlabel='95% Prediction Interval';
	series x = Date y = AUS_Beer / legendlabel='Actual Values' lineattrs=(color=black);
	series x = Date y = Pred / legendlabel='Predicted Values' lineattrs=(color=red);
	yaxis label='Beer Production';
	title 'Quarterly Beer Production';
run;
quit;

proc sgplot data=Beer_Pred2(where=(Year > 2006));
	band x = Date LOWER = Lower UPPER = Upper / legendlabel='95% Prediction Interval';
	series x = Date y = AUS_Beer / legendlabel='Actual Values' lineattrs=(color=black);
	series x = Date y = Pred / legendlabel='Predicted Values' lineattrs=(color=red);
	yaxis label='Beer Production';
	title 'Quarterly Beer Production';
run;
quit;


/*----------------------*/
/* Residual Diagnostics */
/*----------------------*/

/* Residual Plots */
proc reg data=TIME.FPP_CREDIT plot(unpack)=DIAGNOSTICS;
	model Score = Log_Savings Log_Income Log_Address Log_Employed;
	output out=Credit_Res r=Residuals;
run;
quit;

/* Residual Autocorrelations */
proc reg data=TIME.FPP_AUSBEER(where=(1992 <= Year <= 2006));
	model AUS_Beer = Trend Q2 Q3 Q4;
	output out=Beer_Pred p=Pred r=Residuals;
run;
quit;

proc arima data=Beer_Pred;
	identify var=Residuals nlag=10;
run;
quit;

/* Durbin-Watson Test for Autocorrelation */
proc reg data=TIME.FPP_AUSBEER(where=(1992 <= Year <= 2006));
	model AUS_Beer = Trend Q2 Q3 Q4 / dwProb;
run;
quit;


/*-----------------------*/
/* Non-linear Regression */
/*-----------------------*/

/* Stepwise Regression */
data Fuel_Nonlinear;
	set TIME.FPP_FUEL;
	if City < 25 then Under_25 = 0; else Under_25 = City - 25;
run;

proc reg data=Fuel_Nonlinear;
	model Carbon = City Under_25;
	output out=Carbon_Pred p=Predictions;
run;
quit;

proc sort data=Carbon_Pred out=Carbon_Pred_Rank;
	by Predictions;
run;

proc sgplot data=Carbon_Pred_Rank;
	scatter x = City y = Carbon;
	series x = City y = Predictions;
run;
quit;

/* Nonlinear Regression */
data Fuel_Nonlinear;
	set TIME.FPP_FUEL;
	if City < 25 then Under_25 = 0; else Under_25 = City - 25;
	City2 = City**2;
	City3 = City**3;
	Under_25_2 = Under_25**2;
	Under_25_3 = Under_25**3;
run;

proc reg data=Fuel_Nonlinear;
	model Carbon = City City2 City3 Under_25_3;
	output out=Carbon_Pred2 p=Predictions;
run;
quit;

proc sort data=Carbon_Pred2 out=Carbon_Pred_Rank2;
	by Predictions;
run;

proc sgplot data=Carbon_Pred_Rank2;
	scatter x = City y = Carbon;
	series x = City y = Predictions;
run;
quit;
