%**options source2;  %** shows macro as it is being processed **;
run;  %** because the world needs more run statements **;
%MACRO minime(droplist,keeplist);  
run;  %** because the world needs more run statements **;
%** If an error has occurred before call to minime then fail immediately. **;

%if &syserr. ^= 0 %then %do;
  %put %upcase(note: ) minime did not run due to previous errors in your SAS session;
  %goto nevrmind;
%end;

               
/*******************************************************************************
* macro: minime.sas
* input: most recently created WORK dataset, and, optionally, variable lists to
*         exclude from or include in minimizing. 
* output: most recently created WORK dataset with variable lengths set at the 
*          safest variable length for all operating systems.  this should reduce 
*          the size of the SAS data file, but it could increase it, perhaps 
*          appropriately so.  
* 
* Programmer: Dan Blanchette   dan_blanchette@unc.edu
*             The Carolina Population Center at The University of North Carolina at Chapel Hill
* 
* developed at: 
*           The Carolina Population Center at The University of North Carolina at Chapel Hill and
*           Center for Entrepreneurship and Innovation Duke University's Fuqua School of Business
* date: 22May2003
* modified: 20Oct2011  -- added code to set system option varlenchk to nowarn if using 9.3 or 
*                          higher since it was added in an updated to SAS 9.2.
*                         also added a message that minime ended due to errors in current SAS
*                          session if that happened.
* modified: 10Mar2009  -- removed usage log option and cleaned up code a bit
* modified: 15Jul2004  -- added options to exclude or include a variable list to either
*                         not to be minimized or to be minimized.  this allows you to specify
*                         what variables you do or do not want to minimize.
*                      -- added option to log usage of macro.  look for "minime_usage.log" below.
*                      -- only resets variables that had a change in length.
* 
*  Disclaimer:  This program is free to use and to distribute as long as credit is given to
*                 Dan Blanchette
*                 The Carolina Population Center 
*                 University of North Carolina at Chapel Hill
* 
*                There is no warranty on this software either expressed or implied.  This program
*                 is released under the terms and conditions of GNU General Public License.
* 
* 
* comments: 
*  -- minime creates datasets "_conten" and "_conten1";
*      thus, the name of the input dataset cannot be _conten or _conten1.  
*      also, any existing dataset in the WORK library/directory 
*      named _conten or _conten1 will be overwritten by minime. 
*  -- minime uses arrays ___nv___, ___cv___, ___ch___, ___ln___  and ___lo___;
*      thus,  the input dataset cannot contain variables of the same name.
* options:
*  -- minime can be given a variable list(s) to exclude from and or to include in minimizing. 
*     your dataset will have the same variables in the same positions as when it started.
*  use:
*   %minime( exclude variable list , include variable list );
*  any valid SAS variable list can be used:
*    gender race          - the two variables "gender" and "race"
*    var1-var5            - var1 var2 var3 var4 var5
*    age--sampwt          - could be: age gender weight psu sampwt
*    age-numeric-sampwt   - only the numeric variables between age and sampwt
*                           which could be: age weight psu sampwt
*    age-character-sampwt - only the character variables between age and sampwt
*                           which could be: name 
*    _all_                - all variables in the dataset
*    _numeric_            - all numeric variables in the dataset
*    _character_          - all character variables in the dataset
*    va:                  - all variables in the dataset that begin with the string "va"
* 
* 
* 
* example use of this macro:
*  *********************************
* %include 'C:\SASmacros\minime.sas';
* 
*  data myfile;
*   set out.myfile;
*  run;
* 
*  %minime;  ** the default is to minimize all variable lengths **;
* 
* proc contents data=myfile;
* run;
* ********************************* 
*  
*  -- To see the attrib statement minime used to reset the variable lengths, 
*      use the %printme macro after minime has run:
*     
*  *********************************
* 
* %printme;
* 
* ** or to exclude a set of variables:  **
*  data myfile;
*   set out.myfile;
*  run;
* 
*  %minime(hhid personid);   ** minimize all variables except hhid and personid **;
* 
* ** or to process only a selection of variables: **;
*  %minime( , var1-var20); ** notice the first field (the exclude field) is empty
*                           * and there is a comma separating the first field and
*                           * the second field. 
*                           ***;
* 
* ** or some combination of excluding and including variables: **;
*  %minime(id1-id3,allq1--wt3_day1);  
* 
* 
* ********************************* 
*   
*******************************************************************************/

/***************************************************************************/
/****** !NO MORE EDITS TO THE MACRO SHOULD BE MADE BEYOND THIS POINT! ******/
/***************************************************************************/

%local  AVARS bigger bvar bytemin bytemax cv decpos fail  int5max int5min 
        intmax intmin ldset len ln lo long7max long7min longmax longmin 
        nobs notes nv obs reclen wdset smaller temp_dir udset VAR_C VAR_N 
   ;;;


%** save option settings so they can be restored at the end of this macro **;
%let obs=%sysfunc(getoption(obs)); 
%let notes=%sysfunc(getoption(notes)); 
%if %sysevalf(&sysver. >= 9.3) %then %do;
  %let varlenchk= %sysfunc(getoption(varlenchk)); 
%end;
%let notes=%sysfunc(getoption(notes)); 

%*** maximize obs because user could have set it lower than the number of
           variables in the dataset **;
options obs=MAX;  
options nonotes;
%let fail=0;

%global dset; %** needed for printme **;

%*** use the most recently created SAS WORK dataset  ***;
%let ldset=%length(&syslast.);
%let decpos=%index(&syslast.,.);
%let dset=%substr(&syslast.,&decpos.+1,&ldset.-&decpos.);
%let udset=%qupcase(&dset.);


%if %index(&syslast.,WORK)^=1 %then %goto fail1;

%if %upcase(&udset.) = _CONTEN or %upcase(&udset.) = _CONTEN1 %then %goto fail2;

%**  use the WORK directory to store the SAS program files that this program creates ***;
%let temp_dir = %SYSFUNC(pathname(WORK)); 

%**  use the WORK directory to store the SAS files that this program creates ***;
%if %index(&temp_dir.,\) %then %let temp_dir = &temp_dir.\;  
%else %if %index(&temp_dir.,/) %then %let temp_dir = &temp_dir./; 

%** obtain original observation length **;
proc contents data= &dset. out= _conten(keep= npos nobs length) noprint;
run;
 
%let nobs=0;
data _null_;
 set _conten;
 call symput('nobs',nobs);
run;

%if &nobs.=0 %then %goto fail6;

proc sort data=_conten;
 by npos;
run;

%let reclen=0;
data _null_;
 set _conten end=___lo___;
 if ___lo___ then do;
  call symput("reclen",npos+length);
 end;
run;
** (end) obtain original observation length **;

%let wdset=&dset.;
%if %length(&keeplist.) > 0 or %length(&droplist.) > 0 %then %do;
  %let wdset=_conten1;
  %** create a dataset of the contents of input dataset **;
  data _conten1(keep= &keeplist. drop= &droplist.);
   set &dset.;
  run;
%end;

proc contents data= &wdset. out= _conten noprint;
run;


%let VAR_N=0;  %* number of numeric variables to be compressed *;
%let VAR_C=0;  %* number of character variables to be compressed *;
%let AVARS=0;  %* total number of all variables to be compressed *;


proc sort data= _conten; by type;
run;

%** Initialize macro vars **;
%let nv=0;
%let cv=0;
%let ch=0;
%let ln=0;
%let lo=0;
data _null_ ;
 set _conten end= lastobs;
 by type;
 if first.type then do;
  var_non = 0;
  var_noc = 0;
 end;
 name = lowcase(name);
 if name = "___nv___" then call symput("nv",1);
 if name = "___cv___" then call symput("cv",1);
 if name = "___ch___" then call symput("ch",1);
 if name = "___ln___" then call symput("ln",1);
 if name = "___lo___" then call symput("lo",1);
 if type = 1 then do;
  var_non + 1 ;
 end;
 if type = 2 then do;
  var_noc + 1 ;
 end;

%** create macro var containing final # of macro vars *;
if last.type and type = 1 then call symput( 'VAR_N', left( put( var_non, 5. ) ) ) ;
if last.type and type = 2 then call symput( 'VAR_C', left( put( var_noc, 5. ) ) ) ;
if lastobs then call symput( 'AVARS', left( put( _n_, 5. ) ) ) ;

run ;

 %if &AVARS. = 0 %then %goto fail3;

 %let bvar=________;
 %if &nv. = 1 %then %do; %let bvar=___nv___; %goto fail4; %end;
 %if &cv. = 1 %then %do; %let bvar=___cv___; %goto fail4; %end;
 %if &ch. = 1 %then %do; %let bvar=___ch___; %goto fail4; %end;
 %if &ln. = 1 %then %do; %let bvar=___ln___; %goto fail4; %end;
 %if &lo. = 1 %then %do; %let bvar=___lo___; %goto fail4; %end;

  
%if &obs. = 0 %then %goto fail5;


%*** check dataset out ***;

   %let bytemin  = -127; 
   %let bytemax  =  127;
   %let intmin   = -32767;
   %let intmax   =  32767;
   %let int5min  = -8388607;
   %let int5max  =  8388607;
   %let longmin  = -2147483647;
   %let longmax  =  2147483647;
   %let long7min = -549755813887;
   %let long7max =  549755813887;

  data _conten1;
   set work.&wdset. end= ___lo___ ;
   format _all_;   ** remove all formats and informats **;
   informat _all_;

    %if &VAR_N. > 0 %then %do;

      %* process numeric vars *;
       array ___nv___ [&VAR_N.] _numeric_;
       array ___ln___ [&VAR_N.] _temporary_;
         if _n_ = 1 then do;
            do _n_ = 1 to &VAR_N.;
               ___ln___[_n_]=3; %* initialize temp vars to min numeric length *;
            end;
           _n_ = 1;
         end;
       do _n_ = 1 to &VAR_N.;
          if ___ln___[_n_] ne 8 and ___nv___[_n_] > .z then do ;
             if ___nv___[_n_] ne int(___nv___[_n_]) then ___ln___(_n_) = 8; %* all decimal vars length 8 *;
            else  %* check integers *;
             if &BYTEMIN. <= ___nv___[_n_] <= &BYTEMAX. then ___ln___(_n_) = max( ___ln___(_n_), 3 ) ;
            else
             if &INTMIN. <= ___nv___[_n_] <= &INTMAX. then ___ln___(_n_) = max( ___ln___(_n_), 4 ) ;
            else
             if &INT5MIN. <= ___nv___[_n_]<=&INT5MAX. then ___ln___(_n_) = max( ___ln___(_n_), 5 ) ;
            else
             if &LONGMIN. <= ___nv___[_n_] <= &LONGMAX. then ___ln___(_n_) = max( ___ln___(_n_), 6 ) ;
            else
             if &LONG7MIN. <= ___nv___[_n_] <= &LONG7MAX. then ___ln___(_n_) = max( ___ln___(_n_), 7 ) ;
            else
              ___ln___(_n_) = 8;
          end ;
        end ;  %*** end of _n_ = 1 to &VAR_N. ***;
     %end; %** end of processing numeric vars **;


   %* now process the character variables *;
     %if &VAR_C. > 0 %then %do;
           array ___cv___( &VAR_C. ) _character_ ;
           array ___ch___( &VAR_C. ) _temporary_ ;
         if _n_ = 1 then do;
            do _n_ = 1 to &VAR_C.;
               ___ch___[_n_] = 1; %* initialize temp vars to min character length *;
            end;
           _n_ = 1;
         end;

            %* increase character length until the maximum needed *;
           do _n_ = 1 to &VAR_C. ;
              if ___ch___[_n_] < length(___cv___[_n_]) then ___ch___[_n_] = length(___cv___[_n_]);
           end ;
     %end;  %* end of processing character vars *;

        if ___lo___ = 1
           then do ;
          %if &VAR_N. > 0 %then %do;
             do  _n_ = 1 to &VAR_N. ;
               ___nv___[_n_] = ___ln___[_n_]; %** replace values of variables with their length **;
             end;
          %end;

          %if &VAR_C. > 0 %then %do;
              do _n_ = 1 to &VAR_C. ;
              %* this converts the character data to numeric data *;
               ___cv___[_n_] = ___ch___[_n_]; %** replace values of variables with their length **;
              end;
          %end;
         output;
        end;
  run;


%* since it is one obs in the dataset transpose to create variable name *;
 proc transpose data= _conten1 out= _conten1;
   var _all_;
 run;

%let len=0;
data _conten1(drop= lc);
 set _conten1 end= ___lo___;
 varnum = _n_;  %** make the variable order be the order they are in the dataset **;
 %** find the maximum length of col1 **;
 retain lc;
 if lc < length(col1) then lc = length(col1); 
 if ___lo___ then call symput('len',lc+1);  ** and make it into a macro var **;
run;


%** %left is an autocall macro that may not be
  *  available to all users so use more clunky way:  **;
%let len=%sysfunc(left(%nrbquote(&len.)));

proc sort data= _conten;
 by varnum;
run;

data _conten;
 merge _conten(keep= name varnum type 
   length rename= (length = o_length)  
   )
       _conten1(keep= _name_ varnum col1);
 by varnum;
run;


%if &VAR_C. = 0 %then %do;
 data _conten;
  set _conten
   (where= (o_length ^= col1)) %* only reset vars that changed in length *;
  ;;
  name  = left(name);
 _name_ = left(_name_);
 run;
%end;
%else %if &VAR_C. > 0 %then %do;
 data _conten;
  length col1 $&len.;
  set _conten 
   (where= (o_length ^= input(left(col1),8.))) %* only reset vars that changed in length *;
 ;;;
  name  = left(name);
 _name_ = left(_name_);
 if type = 2 then col1 = compress("$"||col1);
 if type = 2 then col1 = left(col1);
 run;
%end;
    
data _null_;
 set _conten end= lastobs;
 file "&temp_dir._&SYSJOBID._.sas";  %** reuse name of file **;
 if _n_ = 1 then do;
%if %sysevalf(&sysver. >= 9.3) %then %do;
 %let varlenchk= %sysfunc(getoption(varlenchk)); 
 put "options varlenchk= nowarn;" ;
%end;
 put '  '; 
 put ' data work.&dset.; '; 
 end;
 put '  attrib ' _name_ ' length = ' col1 ';';
if lastobs then do;
 put '  set work.&dset.; '; 
 put ' run; ';
%if %sysevalf(&sysver. >= 9.3) %then %do;
 put 'options varlenchk= &varlenchk.;' ;
%end;
 end;
run;

%include "&temp_dir._&SYSJOBID._.sas";


%** check to see if there was an improvement. **;
/**************************************
** gives actual filesize in bytes: **;
data fileatt;
   length name $ 20 value $ 40;
   drop rc fid j infonum;
   rc = filename("myfile","physical-filename");
   fid = fopen("myfile");
   infonum = foptnum(fid);
   do j = 1 to infonum;
      name = foptname(fid,j);
      value = finfo(fid,name);
      put 'File attribute ' name 
       'has a value of ' value;
      output;
   end;
   rc = filename("myfile");
run;
**************************************/
proc contents data= &dset. out= _conten1 noprint;
run;

proc sort data= _conten1;
 by npos;
run;

%let bigger=0;
%let smaller=0;

data _null_;
 set _conten1 end= lastobs;
 if lastobs;
 oldlen = &reclen.;
 reclen = npos+length;
 if (oldlen-reclen) < 0 then do;
   dif = int((reclen - oldlen) / oldlen * 100);
   call symput("bigger",dif);
 end;
 else if (oldlen - reclen) >= 0 then do;
       dif = int((oldlen - reclen) / oldlen * 100);
       call symput("smaller",dif);
      end;
run;
 
%let bigger=%sysfunc(compress(&bigger.));
%let smaller=%sysfunc(compress(&smaller.));

options notes; ** make sure notes are on **;
%if &bigger. = 0 and &smaller. = 0  %then %do;
   %put ;
   %put NOTE: minime did not make WORK.&dset. smaller.         ;     
   %put lengths of some variables may have changed.            ;
   %put the size of the data file may or may not have changed. ; 
   %put ;
  %end;
%if &bigger. > 0  %then %do;
   %put ;
   %put NOTE: minime actually made WORK.&dset. larger. the observation length is longer by &bigger. percent. ;
   %put ;
 %end;
%if &smaller. > 0 %then %do;
   %put ;
   %put NOTE: minime made WORK.&dset. smaller.  the observation length is shorter by &smaller. percent. ;
   %put ;
 %end;


%goto okay;

%fail1: %put ;  
        %put %upcase(error:) minime.sas did not run.  ;
        %put   the input dataset &dset. has to be in the WORK library. ;
        %** SAS 8 will put a note at the end of the log stating that what page errors occurred
          *  but earlier versions do not. so insert evil code to generate an error *;
        %if %sysevalf(&sysver. < 8) %then 
              bite bite bite 
        %put ;
        %let fail=1;
%goto okay;

%fail2: %put ;
        %put %upcase(error:) minime.sas did not run.  ;
        %put   the input dataset cannot be named &dset. ;
        %if %sysevalf(&sysver. < 8) %then 
              bite bite bite 
        %put ;
        %let fail=2;
%goto okay;

%fail3: %put ;
        %put %upcase(error:) minime.sas did not run.  ;
        %put    the input dataset &dset. has no variables ;
        %if %sysevalf(&sysver. < 8) %then 
              bite bite bite 
        %put ;
        %let fail=3;
%goto okay;

%fail4: %put ;
        %put %upcase(error:) minime.sas did not run.  ;
        %put    the input dataset &dset. cannot contain a variable named &bvar.;
        %put    because minime uses an array by that name. ;
        %put    either rename the variable or drop it.;
        %if %sysevalf(&sysver. < 8) %then 
              bite bite bite 
        %put ;
        %let fail=4;
%fail5: %put ;
        %put %upcase(error:) minime.sas did not run.  ;
        %put    the option "obs" is set to 0;
        %if %sysevalf(&sysver. < 8) %then 
              bite bite bite 
        %put ;
        %let fail=5;
%goto okay;
%fail6: %put ;
        %put %upcase(error:) minime.sas did not run.  ;
        %put    the input data set &dset. has no observations;
        %if %sysevalf(&sysver. < 8) %then 
              bite bite bite 
        %put ;
        %let fail=6;
%goto okay;
%okay: ;


options obs= &obs. &notes.;
%** make sure that the last dataset created in WORK is the users dataset **;
%let sysdsn=work    &dset.;
%let syslast=work.&dset.;

%nevrmind: ;  %** Go to here if error occurred before minime started **;

%MEND minime;


%MACRO printme;
 %if %sysfunc(exist(work._conten)) ^= 1 %then %goto fail1;
 %else %do;
   
   data _null_;
    set _conten end= lastobs;
   file print;  %* print to output window *;
   if _n_ = 1 then do;
    put ;
    put '*============================================================*';
    put '|  This is the data step minime used to reset the lengths    |';
    put '|   of the variables.                                        |';
    put '|                                                            |';
    put '|  This code can be copied into your program and run instead |';
    put '|   of running minime.                                       |';
    put '*============================================================*';
    put ;
   %if %sysevalf(&sysver. >= 9.3) %then %do;
     put '%let varlenchk= %sysfunc(getoption(varlenchk));' ;
     put "options varlenchk= nowarn;" ;
   %end;
    put " data work.&dset.; ";
   end;
   put "   attrib  " _name_ " length = " col1 "; ** length was: " o_length " *;" ;
   if lastobs = 1 then do;
    put "  set work.&dset.;";
    put " run; ";
   %if %sysevalf(&sysver. >= 9.3) %then %do;
     put 'options varlenchk= &varlenchk.;' ;
   %end;
   end;
 run;
 
 %** make sure that the last dataset created in WORK is the users dataset **;
 %let sysdsn=work    &dset.;
 %let syslast=work.&dset.;
%end;  %** if work._conten exists **;

%goto okay;

%fail1: %put ;  
        %put %upcase(error:) printme did not run.  ;
        %put   printme can only be run directly after running the minime macro;
        %** SAS 8 will put a note at the end of the log stating that what page errors occurred
         %*  but earlier versions do not. so insert evil code to generate an error **;
        %if %sysevalf(&sysver. < 8) %then 
              bite bite bite 
        %put ;
%okay: ;

%MEND printme;

