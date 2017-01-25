/*------------------------*/
/* Time Series Components */
/*------------------------*/

/* Initial Plots - Next 4 Plots */
proc sgplot data=TIME.FPP_HSALES;
	series x = Date y = Housing_Sales;
	yaxis label = 'Monthly Housing Sales (Millions)';
	title;
run;

proc sgplot data=TIME.FPP_USTREAS;
	series x = Day y = Contracts;
	yaxis label = 'US Treasury Bill Contracts';
	title;
run;

proc sgplot data=TIME.FPP_ELEC;
	series x = Date y = Elec_Prod;
	yaxis label = 'Australian Monthly Electric Production';
	title;
run;

data TIME.FPP_DJ; /* Creating Difference for Dow Jones Index Values to Get Daily Change */
	set TIME.FPP_DJ;
	Diff_DJ = Dow_Jones - LAG(Dow_Jones);
run;

proc sgplot data=TIME.FPP_DJ;
	series x = Day y = Diff_DJ;
	yaxis label = 'Daily Change in Dow Jones Index';
	title;
run;

/* Plotting Trend-Cycle Component by Default or Through SGPLOT */
proc timeseries data=TIME.FPP_ELECEQUIP plots=TCC outdecomp=decomp;
	id Date interval=month;
	var NOI;
	title;
run;

proc sgplot data=decomp;
	series x = Date y = TCC / lineattrs=(color=blue);
	series x = Date y = ORIGINAL / legendlabel='New Orders Index' lineattrs=(color=gray);
	yaxis label = 'New Orders Index';
	title 'Electrical Equipment Manufacturing (Euro Area)';
run;

/* Plotting Data, Seasonal Component, Trend-Cycle Component, and Error Component */
proc timeseries data=TIME.FPP_ELECEQUIP plots=(SERIES TCC SC IC);
	id Date interval=month;
	var NOI;
	title;
run;

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


/*-----------------*/
/* Moving Averages */
/*-----------------*/

/* Calculate a Moving Averages - Odd Orders */
proc expand data=TIME.FPP_ELECSALES out=elecsales5;
	convert GWh = Mean5_GWh / method = none transformout = (CMOVAVE 5);
	title;
run;

proc sgplot data=elecsales5;
	series x = Year y = Mean5_GWh / legendlabel='5-MA Estimate of Trend-Cycle' lineattrs=(color=blue);
	series x = Year y = GWh / legendlabel='GWh' lineattrs=(color=gray);
	yaxis label = 'GWh';
	title 'Residential Electricity Sales';
run;

proc expand data=TIME.FPP_ELECSALES out=elecsales3;
	convert GWh = Mean3_GWh / method = none transformout = (CMOVAVE 3);
	title;
run;

proc sgplot data=elecsales3;
	series x = Year y = Mean3_GWh / legendlabel='3-MA Estimate of Trend-Cycle' lineattrs=(color=blue);
	series x = Year y = GWh / legendlabel='GWh' lineattrs=(color=gray);
	yaxis label = 'GWh';
	title 'Residential Electricity Sales';
run;

proc expand data=TIME.FPP_ELECSALES out=elecsales5;
	convert GWh = Mean5_GWh / method = none transformout = (CMOVAVE 5);
	title;
run;

proc sgplot data=elecsales5;
	series x = Year y = Mean5_GWh / legendlabel='5-MA Estimate of Trend-Cycle' lineattrs=(color=blue);
	series x = Year y = GWh / legendlabel='GWh' lineattrs=(color=gray);
	yaxis label = 'GWh';
	title 'Residential Electricity Sales';
run;

proc expand data=TIME.FPP_ELECSALES out=elecsales7;
	convert GWh = Mean7_GWh / method = none transformout = (CMOVAVE 7);
	title;
run;

proc sgplot data=elecsales7;
	series x = Year y = Mean7_GWh / legendlabel='7-MA Estimate of Trend-Cycle' lineattrs=(color=blue);
	series x = Year y = GWh / legendlabel='GWh' lineattrs=(color=gray);
	yaxis label = 'GWh';
	title 'Residential Electricity Sales';
run;

proc expand data=TIME.FPP_ELECSALES out=elecsales9;
	convert GWh = Mean9_GWh / method = none transformout = (CMOVAVE 9);
	title;
run;

proc sgplot data=elecsales9;
	series x = Year y = Mean9_GWh / legendlabel='9-MA Estimate of Trend-Cycle' lineattrs=(color=blue);
	series x = Year y = GWh / legendlabel='GWh' lineattrs=(color=gray);
	yaxis label = 'GWh';
	title 'Residential Electricity Sales';
run;

/* Calculate Moving Averages of Moving Averages - 2x4 Example */
proc expand data=TIME.FPP_ELECSALES out=elecsales4;
	convert GWh = Mean4_GWh / method = none transformout = (CMOVAVE 4);
	title;
run;

proc expand data=elecsales4 out=elecsales2x4;
	convert Mean4_GWh = Mean2x4_GWh / method = none transformout = (CMOVAVE 2);
	title;
run;

proc sgplot data=elecsales2x4;
	series x = Year y = Mean2x4_GWh / legendlabel='2x4-MA Estimate of Trend-Cycle' lineattrs=(color=blue);
	series x = Year y = GWh / legendlabel='GWh' lineattrs=(color=gray);
	yaxis label = 'GWh';
	title 'Residential Electricity Sales';
run;

/* Calculate Moving Averages of Moving Averages - 2x12 Example */
proc expand data=TIME.FPP_ELECEQUIP out=elecequip12;
	convert NOI = Mean12_NOI / method = none transformout = (CMOVAVE 12);
	title;
run;

proc expand data=elecequip12 out=elecequip2x12;
	convert Mean12_NOI = Mean2x12_NOI / method = none transformout = (CMOVAVE 2);
	title;
run;

proc sgplot data=elecequip2x12;
	series x = Date y = Mean2x12_NOI / legendlabel='2x12-MA Estimate of Trend-Cycle' lineattrs=(color=blue);
	series x = Date y = NOI / legendlabel='New Orders Index' lineattrs=(color=gray);
	yaxis label = 'New Orders Index';
	title 'Electrical Equipment Manufacturing (Euro Area)';
run;


/*-------------------------*/
/* Classical Decomposition */
/*-------------------------*/

proc timeseries data=TIME.FPP_ELECEQUIP plots=(SERIES DECOMP) outdecomp=decomp;
	id Date interval=month;
	var NOI;
	title;
run;


/*---------------------------------------------------------------------------------------*/
/* STL Decomposition - Cannot Find any Documentation That SAS Performs STL Decomposition */
/*---------------------------------------------------------------------------------------*/


