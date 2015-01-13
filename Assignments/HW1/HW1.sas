%let wrds = wrds.wharton.upenn.edu 4016;options comamid = TCP remote=WRDS;
signon username=_prompt_;

/* execute code remotely within rsubmit-endrsubmit code block 
   note that after 15 or so minutes of inactivity, you need to sign on again
*/
rsubmit;
data myTable (keep = gvkey fyear datadate sale at ni prcc_f csho);
set comp.funda;
/* require fyear to be within 2000-2013 */
if 2000 <=fyear <= 2013;
/* prevent double records */
if indfmt='INDL' and datafmt='STD' and popsrc='D' and consol='C' ;
run;
proc download data=myTable out=myCompTable;run;
endrsubmit;



/* Question 1 : Check if there is any duplicate on the compustat fundamentals database
		1. use dupout
			a by 2 var
			b by 1 var
		2. use proc means
*/
/* 1 a*/
proc sort data=myCompTable out=MyCompTableNoDup nodupkey dupout=dupgvyear by gvkey fyear;
run;
/* 1 b*/

data myCompTable;
set myCompTable;
gv_year= gvkey || fyear;
run;
proc sort data=myCompTable out=MyCompTableNoDup nodupkey dupout=dupgvyear by gv_year; run;
 
/* 2 */
data myCompTable;
set myCompTable;
gv_year= gvkey || fyear;
run;
proc sort data=myCompTable out=MyCompTableNoDup nodupkey dupout=dupgvyear by gv_year; run;
