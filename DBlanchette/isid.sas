/************************************************************************************************
** Macro: ISID
** Input: A SAS data set name of a SAS data set that exists in a SAS library and a variable list
**
** Programmer: Dan Blanchette   dan_blanchette@unc.edu
**             The Carolina Population Center at The University of North Carolina at Chapel Hill
** Developed at:
**             Center for Entrepreneurship and Innovation Duke University's Fuqua School of Business
** Date: 06Mar2009
**
** Disclaimer:  This program is free to use and to distribute as long as credit is given to 
**                Dan Blanchette 
**                The Carolina Population Center 
**                University of North Carolina at Chapel Hill
** 
**               There is no warranty on this software either expressed or implied.  This program 
**                is released under the terms and conditions of GNU General Public License.
**
** Comments:
**   The ISID SAS macro is just like the Stata command -isid-.  It tests if the 
**    variable(s) uniquely identifies each observation in the data set.
**
**   If no data set name is provided then ISID will check the most recently created SAS data set.
**
**   If no variable list is provided, then ISID will check the variables the data set is sorted by.
**
** EXAMPLE USE OF THE TYPE MACRO:
** %include"C:\SASmacros\isid.sas"; ** Include macro once in a SAS session and call it **;
**                                   *  as many times as you like in that session.     **;
**
** %isid(dset= sashelp.shoes, varlist= stores region, missok=missok);
**
** ** if you most recently data set is sorted, then no data set name nor variable list is required **;
** %isid;
**
************************************************************************************************/

%macro isid (dset=,varlist=,missok=) ;
  %** If an error has occurred before call to ISID then fail immediately. **;
  %if &syserr.^=0 %then %goto nevrmind; 

  %local does i mnobs mvars nobs notes orig_nobs s_last sortedby variable vcount word ;

  %let notes=%sysfunc(getoption(notes)); 

  options nonotes;
  %let s_last=&syslast.;

  %if &dset. =  and %upcase(&syslast.) ^=_NULL_  %then %let dset=&syslast.;
  %if &dset. =  %then %do;
    %goto fail1;
  %end;

  %if &varlist.=  %then %do;

    data _null_;
     dsid=open("&dset.",'i');
     sortedby=attrc(dsid,'SORTEDBY');
     call symput('sortedby',trim(sortedby));
     rc=close(dsid);
    run;
    
    %* if data sorted by descending values, remove DESCENDING. tranwrd is like subinstr **;
    %if %index(&sortedby.,DESCENDING DESCENDING) %then %do;
      %let varlist=%sysfunc(tranwrd(&sortedby.,DESCENDING DESCENDING,DESCENDING));
    %end;
    %else %if %index(&sortedby.,DESCENDING) %then %do;
      %let varlist=%sysfunc(tranwrd(&sortedby.,DESCENDING,));
    %end;
    %else %do;
      %let varlist=&sortedby.;
    %end;

  %end;

  %if &varlist.=  %then %do;
    %goto fail2;
  %end;

  %* test for missing values in varlist **;
  %let mvars=;
  %let i=1;
  %do %while(%length(%scan(%cmpres(&varlist.),&i.,%str( ))) GT 0); 
    %local var&i.;
    %let var&i.= %scan(%cmpres(&varlist.),&i.,%str( ));

    data _isid_ ;
     set &dset. (keep= &&var&i..);
      where missing(&&var&i..) = 1 ;
    run;
  
    data _null_;
     dsid=open("_isid_","i");
     mnobs=attrn(dsid,"nobs");
     call symput("mnobs",compress(mnobs));
    run;

    %if &mnobs. > 0 %then %do;
      %if &i. = 1 %then %let mvars=&&var&i..;
      %else %let mvars=&mvars. &&var&i..;
    %end;

    %let i=%eval(&i + 1);
  %end;  %* of while loop **;


  proc sql noprint;
   create table _isid_ as
    select distinct *
     from &dset. (keep= &varlist.);
  quit;
  
  data _null_;
   dsid=open("&dset.","i");
   orig_nobs=attrn(dsid,"nobs");
   call symput("orig_nobs",compress(orig_nobs));
  run;


  data _null_;
   dsid=open("work._isid_","i");
   nobs=attrn(dsid,"nobs");
   call symput("nobs",compress(nobs));
  run;

  options notes;

  %* count the number of words in a string like the Stata function wordcount() and macro function ": word count" **;
  %let variable=variable;
  %let does=does;
  %let has=has;
  %macro wcount(words=);
    %let word=dude;
    %let vcount=0;
    %do %while(&word ne);
        %let vcount=%eval(&vcount.+1);
        %let word=%cmpres(%qscan(&words.,&vcount,%str( )));
    %end;
    %let vcount=%eval(&vcount-1);
  
    %if &vcount. > 1 %then %do;
       %let variable=variables;
       %let does=do;
       %let has=have;
    %end;
  %mend wcount;

  %if %length(&mvars.) > 0 %then %do;
     %wcount(words=&mvars.);
     %if &missok. ^=  %then %do;
        %put ;
        %put %upcase(note: ) &variable.  &mvars. &has. missing values; 
        %put ;
     %end;
     %else %do;
        %put ;
        %put %upcase(error: ) &variable.  &mvars. &has. missing values; 
        %put ;
     %end;
  %end;

  
  %wcount(words=&varlist.);
  %if  &nobs. < &orig_nobs %then %do;
     %put ;
     %put %upcase(error:) &variable.  &varlist. &does. not uniquely identify each observation;
     %put ;
  %end;
  %else %do;
     %put ;
     %put %upcase(note:) &variable.  &varlist. uniquely identify each observation;
     %put ;
  %end;

  %goto okay;

  %fail1: ;
    %put %upcase(error: ) no data set for ISID to check. ;
  %goto okay;

  %fail2: ;
    %put %upcase(error: ) no variable list for ISID to check. ;
  %goto okay;

  %okay: ;
  %let syslast=&s_last.;
  options &notes.;

  %nevrmind: ;  %** Go to here if an error occurred before ISID started **;


%mend isid;
