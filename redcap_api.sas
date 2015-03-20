*-------------------------------------------------------------------------------
* STEP 1: DIRECT YOUR OUTPUT FILE
*-------------------------------------------------------------------------------;

*filename in  "P:\NICHES\redcap\parameter.csv";
*filename out "P:\NICHES\redcap\redcap_out.csv";


filename in  "d:\parameter.txt";
filename out "d:\redcap_out.csv";
*filename status " d:\redcap_status.txt"; 

*-------------------------------------------------------------------------------
* STEP 2: SET YOUR MACRO VARIABLES: TOKEN AND URL
*-------------------------------------------------------------------------------;

*%let token = "";
*%let url   = "https://redcap.dtmi.duke.edu/api/api";

* public test token;
%let token = 9A81268476645C4E5F03428B8AC3AA7B;
%let url   = "https://bbmc.ouhsc.edu/redcap/api/";


*-------------------------------------------------------------------------------
* STEP 3: YOU DON'T NEED TO CHANGE ANYTHING IN THIS SECTION
*-------------------------------------------------------------------------------;

data _null_ ;
file in ; 
*put "%NRStr(content=record&type=flat&format=csv&token=)&token";
put "%NRStr(content=record&format=csv&token=)&token";
run;
*  headerout=status;
* the 
proc http
   in=in
   out=out
 
   url=&url
   method="post"
	ct="application/x-www-form-urlencoded";
run;


options mprint;
/** create file handles */
filename ein "d:/testIn.txt";
filename eout "d:/testOut.csv";
filename ehdrout "d:/test_Hdr.txt";
%let _token=9A81268476645C4E5F03428B8AC3AA7B; * public test token;
/** set the url variable */
%let _urlx=%str(https://bbmc.ouhsc.edu/redcap/api/);

/** create parameter file  */
data _null_;
   file ein;
   input ;
   put _infile_;
   datalines4;
  'token='||"&_token."||'&content=record&format=xml&type=flat&fields=study_id'
    ;;;; run;

/** request data from the server */
%sysexec curl -i -X POST -d @./testIn.txt &_urlx   >> ./test_Hdr.txt;
