/****************************************************************************************************
** Macro: WHICH
** Input: A name of a SAS macro that SAS automatically finds when: %macroname is used in SAS code.
**
** Programmer: Dan Blanchette   dan_blanchette@unc.edu
**             The Carolina Population Center at The University of North Carolina at Chapel Hill
** Developed at:
**             Center for Entrepreneurship and Innovation Duke University's Fuqua School of Business
** Date: 06Nov2009
** Modified: 19May2010  - Added code to report that macro is either built-in or misspelled.
** Modified: 09Dec2010  - Now searchers for compiled SAS macros and does a better job searching
**                         the directories specified in the system option SASAUTOS.
**
** Disclaimer:  This program is free to use and to distribute as long as credit is given to
**               Dan Blanchette 
**               The Carolina Population Center 
**               University of North Carolina at Chapel Hill
**
**               There is no warranty on this software either expressed or implied.  This program
**                is released under the terms and conditions of GNU General Public License.
**
** Comments:
**   The WHICH SAS macro is like the Stata command (and UNIX/Linux command) -which-.  It 
**    looks in your SASAUTOS path for the location of a SAS macro that SAS will 
**    automatically find when: %macroname is used in SAS code and then it will print
**    the first 10 lines of the macro in your log window/file.
**
**   In UNIX/Linux you can add directories of other locations of SAS macros that SAS will
**    automatically find when %macroname is used in SAS code by putting a file named:
**     sasv9.cfg in your home directory and putting this line in it:
**      -sasautos ( '!SASROOT/sasautos' '$HOME/SASmacros/' ) 
**    NOTE: It is best to add your personal directories after: '!SASROOT/sasautos' so that SAS will
**           work normally for you in case you put a SAS program file that is named the
**           same as a SAS macro that is installed with SAS like: lowcase.sas
**
**    options mautolocdisplay; will display in the log the path to the SAS program and the 
**     file name that contains the autocall macro whenever that macro is invoked.
**
**    %which(macro_name);  will show all macros named macro_name that are compiled and in any of 
**     the directories specified SASMSTORE option libref in the order they will be invoked by SAS. 
**     SAS will only use the first macro named macro_name that SAS finds compiled in a concatenated 
**     library specified in the SASMSTORE option but WHICH will find and show all of them. WHICH will 
**     also find and show all macros files named macro_name.sas in the directories specifed in the
**     SASAUTOS system option but SAS will only use the first one that SAS finds.
**     
**     
**
** EXAMPLE USE OF THE WHICH MACRO:
** %include"C:\SASmacros\which.sas"; ** Include the macro file once in a SAS session and call **;
**                                    *  the macro as many times as you like in that session. **;
**
** %which(lowcase);
**
** ** find and print all lines of lowcase.sas: **;
** %which(lowcase , full);
**
** - Compiled macros cannot have their code displayed like a macro stored in a file can.
**
** - If a library or directory is added to the SASAUTOS system option, it will not be searched
**    by SAS unless the MRECALL option is turned on.  WHICH will search all libraries and directories
**    specified in the SASAUTOS system option anyway.
**
**
** Notes about SAS macros:
** - Once a macro is run it is compiled in the work.sasmacr catalog file and then it will be run 
**    rather than another compiled SAS macro in a catalog file stored in the library specified by
**    the sasmstore=libref system option or any file that has the same name in the SASAUTOS path 
**    or the path set by the SASAUTOS system option.  
**
** - The order of macros is always compiled macros first and then macros in files specified
**    in the system option SASAUTOS: 
**     1) WORK 
**     2) whatever SASMSTORE= is set to if it is set and the system option MSTORE is turned on.
**     3) the directories set in the system option SASAUTOS in the order they are set in.
**
** - Compiled macros are stored in work.sasmacr or whatever library sasmstored= is set to and 
**    the sort order is automatically set to: LIBNAME MEMNAME TYPE NAME.
**
** - If the system option MSTORED is turned off, macros stored in sasmacr.sas7bcat in the directory
**    set by the libref set by SASMSTORE are ignored.
**
** - The system option SASAUTOS can be set up in many different ways: quotes, no quotes, commas, and 
**    no commas...for example:
**      options sasautos=(SASAUTOS,"C:\my_macros" 'D:\some_other_macros');
**
** - The system option MAUTOLOCDISPLAY reports the path and filename of the SAS program file that 
**    has the macro even if has been run once before and was compiled.  It reports nothing if a 
**    compiled macro was run...for instance the macro code was in the current program or current SAS 
**    session or was compiled via %include...i.e. the user should know where the macro came from.
**
** - The macro filename has to be in all lowercase on UNIX/Linux for SAS to find it.
**
****************************************************************************************************/


%macro which(mname, full); 
%* which.sas does not use sasauto macros so that it will work if the system option MAUTOSOURCE is turned off *;
%local count found i j len_dir len_lword len_wd 
        lib1 lib2 lib3 lib4 lib5 lib6 lib7 lib8 lib9 lib10 
        lib11 lib12 lib13 lib14 lib15 lib16 lib17 lib18 lib19 lib20
        lib21 lib22 lib23 lib24 lib25 lib26 lib27 lib28 lib29 lib30
        lmname nlibs mstore_lib onotes oobs oqlmax pwdir temp_dir sasautos test ;
%let mname= %upcase(&mname.);
%let lmname= %qsysfunc(lowcase(&mname.));
%let onotes=%sysfunc(getoption(notes));
%let oobs=%sysfunc(getoption(obs));
%let oqlmax= %sysfunc(getoption(quotelenmax));
options noquotelenmax nonotes;

%** _which_ is a very unlikely libname **;
libname _which_ ".";  
%let pwdir= %nrbquote(%qsysfunc(pathname(_which_)));
libname _which_ clear; 
%let sasautos= %qsysfunc(getoption(sasautos));

options notes;
%if %qupcase(%qsysfunc(getoption(mautosource))) = NOMAUTOSOURCE and %length(&sasautos.) > 0 %then %do; 
   %put ;
   %put %upcase(note: ) The system option MAUTOSOURCE is turned off and the system option SASAUTOS is set so no directories specified in the system option SASAUTOS will be searched. ;
   %put ;
%end;

%let mstore_lib= %qsysfunc(getoption(sasmstore));
%if %upcase(%qsysfunc(getoption(mstored))) = MSTORED and &mstore_lib. =   %then %do;
   %put ;
   %put %upcase(note: ) The system option MSTORED is turned on and the system option SASMSTORE is not set so only the compiled macros that will be searched will be in the catalog file: WORK.SASMACR. ;
   %put ;
%end;
%else %if %upcase(%qsysfunc(getoption(mstored))) = NOMSTORED and &mstore_lib. ne   %then %do;
   %put ;
   %put %upcase(note: ) The system option MSTORED is turned off and the system option SASMSTORE is set so only the compiled macros that will be searched will be in the catalog file: WORK.SASMACR. ;
   %put ;
%end;
options nonotes;


%let temp_dir= %qsysfunc(pathname(work));
%if %qupcase(%qsysfunc(getoption(mautosource))) = MAUTOSOURCE and %length(&sasautos.) > 0 %then %do; 
  %** need to be in a directory that is extremely unlikely to have a subdir named the same as a libref **;
  %sysexec cd &temp_dir.;
  %** _which1_ is a very unlikely filename **;
  filename _which1_ "%nrbquote(&sasautos.)";
  %sysexec cd %nrbquote(&pwdir.);
  %let sasautos= %qsysfunc(pathname(_which1_));
  filename _which1_ clear;
  %** replace single quotes surrounding directory names with double quotes: **;
  options nonotes;
  data _null_;
    length sasautos $20000;
    sasautos= prxchange("s/ '/ ""/i",-1,"&sasautos.");
    sasautos= prxchange("s/' /"" /i",-1,sasautos);
    sasautos= prxchange("s/^\('/(""/i",1,trim(sasautos));
    sasautos= prxchange("s/'\)$/"")/i",1,trim(sasautos));
    call symput('sasautos',trim(sasautos));
  run;
  %let sasautos= %nrbquote(&sasautos.)  %nrstr(%"%)%");  ** make sure it ends with ")" **;
%end;
%else %do;
  %let sasautos=")"; 
%end;

%let i= 1;
%let found= 0;   %** if actual file is found **;
%let count=0;
%let len_wd= %eval(%length(&temp_dir.) + 2);

%if %sysfunc(fileexist(&temp_dir./sasmacr.sas7bcat)) %then %do;
  proc catalog catalog= work.sasmacr entrytype= macro; 
         contents  out= work.sasmacr
     ;;; 
  run; quit;

  data _null_;
   set work.sasmacr;
    where upcase(name) = upcase("&mname.") and upcase(type) = "MACRO";
    if _n_ = 1 then do;
      call symput('count',1);
    end;
  run; 
  %if &count. = 1 %then %do;
    %let found= 1;
    options notes;
    %put ;
    %put %upcase(note: ) &mname. is compiled in the work.sasmacr catalog file so its contents cannot be displayed.;
    %put ;
    options nonotes;
  %end; 

  proc datasets library= work nodetails nolist nowarn;
    delete sasmacr / memtype= data;
  run; quit;
%end;

%if %upcase(%qsysfunc(getoption(mstored))) = MSTORED and &mstore_lib. ne   %then %do;
  options nonotes;
  %** this handles concatenated librefs specified in sasmstore: **;
  data _null_;
   set sashelp.vlibnam end= lastobs;
   where libname = %upcase("&mstore_lib.") and path = sysvalue;
   i + 1;
   length lib $500;
   lib= 'lib' || trim(put(i,8.0));
   lib= compress(lib);
   call symput(lib,trim(path));
   if lastobs then call symput('nlibs',left(trim(put(_n_,8.0))));
  run;
  
  %do i= 1 %to &nlibs.;
    %if %qsysfunc(fileexist("&&lib&i../sasmacr.sas7bcat")) %then %do;
      libname _which1_ "%nrbquote(&&lib&i..)";
      %if &syslibrc. = 0 %then %do;  
        proc catalog catalog= _which1_.sasmacr entrytype= macro;
               contents  out= work.sasmacr
           ;;;
        run; quit;
  
        %** only 1 obs will exist if macro found: **;
        data _null_;
         set work.sasmacr;
          where upcase(name) = upcase("&mname.") and upcase(type) = "MACRO";
          count= &count. + 1;
          call symput('count',left(put(count,8.0)));
        run;

        proc datasets library= work nodetails nolist nowarn;
          delete sasmacr / memtype= data;
        run; quit;
    
        options notes;
        %if &count. = 1 %then %do;
          %let found= 1;
          %put ;
          %put %upcase(note: ) The macro &mname. is compiled in the sasmacr catalog file in %str(%")%nrbquote(&&lib&i..)%str(%") so its contents cannot be displayed.; 
          %put ;
        %end; 
        %if &count. > 1 %then %do;
          %let found= 1;
          %put ;
          %put %upcase(warning: ) The macro &mname. is also compiled in the sasmacr catalog file in %str(%")%nrbquote(&&lib&i..)%str(%") so its contents cannot be displayed.;
          %put ;
        %end; 
        options nonotes;
      %end; %** if libname _which1_ exists loop **; 
      libname _which1_ clear;
    %end; %** of sasmacr.sas7bcat exists loop  **;
    options nonotes;
  %end;  %** of i= 1 to nlibs loop **;
%end;

%let test=test;
%let i= 1;
%do %while ("&test." ^= "done");
  %local dir&i. ;
  %let dir&i.= %qscan(&sasautos.,&i.,%nrstr(%"));  /* " */ 
  %let dir&i.= %qsysfunc(trim(&&dir&i..));
  %if "%nrbquote(&&dir&i..)" = "%(" or "%nrbquote(&&dir&i..)" = "(" %then %goto done;
  %if "%nrbquote(&&dir&i..)" = " " or "%nrbquote(&&dir&i..)" = ""  %then %do;
    %goto done; 
  %end;
  %if "%nrbquote(&&dir&i..)" = "%str(%))" %then %do;
    %let test=done;
    %goto done;  %** end of list to search **;
  %end;
  %** syslibrc will equal 0 if at least one directory exists in a concatenated libref: **;
  libname _which_ "%nrbquote(&&dir&i..)";
  %if &syslibrc. ne 0 %then %do;  %** if the directory does not exist then see if it is a libref: **;
    %let len_dir= %eval(%length(%nrbquote(&&dir&i..)) + 2);
    %if &len_dir. > 0 %then %do;
      %let len_lword= %eval(&len_dir. - &len_wd. - 1);
      %if &len_wd. < &len_dir. and &len_lword. > 0 %then %do;  %** it is SASAUTOS or a fileref **;
        %let dir&i.= %qsubstr(&&dir&i..,&len_wd.,&len_lword.);
        %** test if fileref is concatenated and exists: **;
        %if %index(%qsysfunc(pathname(&&dir&i..)),%str(%()) = 1 %then %do;
          %let dir&i.= %nrbquote(%qsysfunc(pathname(&&dir&i..)));
          data _null_;
            length _which_ $20000;
            _which_= prxchange("s/ '/ ""/i",-1,"&&dir&i..");
            _which_= prxchange("s/' /"" /i",-1,_which_);
            _which_= prxchange("s/^\('/(""/i",1,trim(_which_));
            _which_= prxchange("s/'\)$/"")/i",1,trim(_which_));
            call symput("dir&i.",trim(_which_));
          run;
          %** syslibrc will equal 0 if at least one directory exists in a concatenated libref: **;
          libname _which_ &&dir&i..;  %** SASAUTOS is not listed in sashelp.vlibname so need to create _which_**;
        %end;
        %else %do; 
          libname _which_ "%qsysfunc(pathname(&&dir&i..))";  %** SASAUTOS is not listed in sashelp.vlibname so need to create _which_**;
        %end;
        %if &syslibrc. = 0 %then %do;  %** if the directory or directories exist then do: **;
          %let nlibs= 0;
          data _null_;
            retain j .;
            set sashelp.vlibnam end= lastobs;
            where upcase(libname) = "_WHICH_" and path = sysvalue;
            if _n_ = 1 then j= &i.;
            length lib $500;
            lib= 'lib' || trim(put(j,8.0));
            lib= compress(lib);
            call symput(lib,trim(path));
            if lastobs then do;
              call symput('nlibs',left(trim(put(j,8.0))));
            end;
            j= j + 1;
          run;

          %do j= &i. %to &nlibs.;
            %sysexec cd %nrbquote(&&lib&j.); %** test if the path assigned to the libref really exists: **;
            %if &sysrc. = 0 %then %do;
              %let dir&j.= %nrbquote(&&lib&j.);
            %end;
            %else %do;
              %goto done; ** not an existing directory assigned to the libref **;
            %end;
            %** this code is repeated after this loop **;
            %if %qsysfunc(fileexist("&&dir&j../&lmname..sas")) %then %do;
              %let found= 1;
              %let count= %eval(&count. + 1);
              %put ;
              options notes;
              %put %upcase(note: ) &lmname..sas is in "%nrbquote(&&dir&j..)";
              options nonotes;
              %if &count. > 1 %then %do;
                %put %upcase(warning: ) This is copy number &count. of the macro &mname.;
              %end;
              %if %length(&full.) = 0 %then %do;
                options obs= 10;
              %end;
              %type("%nrbquote(&&dir&j../&lmname..sas)", log);
              %put ;
              %if %length(&full.) = 0 %then %do;
                options obs= &oobs.;
              %end;
            %end;
          %end;  %** of nlibs loop **;
        %end;  %** of if libref exists loop **;
        options nonotes;
        libname _which_ clear;
        %goto done; ** now that concatenated librefs are handled **;
      %end;  %** len_wd < len_dir and len_word > 0 **;
      %else %do;
        options nonotes;
        libname _which_ clear; 
        %goto done; ** not an existing directory **;
      %end;
    %end;  %** of len_dir > 0 **;
    %else %goto done; ** nothing **;
  %end;

  %** this code is repeated above in the nlibs loop **;
  %if %qsysfunc(fileexist("&&dir&i../&lmname..sas")) %then %do;
    %let found= 1;
    %let count= %eval(&count. + 1);
    %put ;
    options notes;
    %put %upcase(note: ) &lmname..sas is in "%nrbquote(&&dir&i..)";
    options nonotes;
    %if &count. > 1 %then %do;
      %put %upcase(warning: ) This is copy number &count. of the macro &mname.;
    %end;
    %if %length(&full.) = 0 %then %do;
      options obs= 10;
    %end;
    %type("%nrbquote(&&dir&i../&lmname..sas)", log);
    %put ;
    %if %length(&full.) = 0 %then %do;
      options obs= &oobs.;
    %end;
  %end;

  %done: ; 
  %let i= %eval(&i. + 1);
%end;

%if &found. = 0 %then %do;
  options notes;
  %put ;
  %put %upcase(error: ) &mname. is either a built-in SAS macro (no &lmname..sas file exists) or &mname. is not in your SASAUTOS path.;
  options notes;
%end;

%sysexec cd %nrbquote(&pwdir.);
options &onotes obs= &oobs. &oqlmax. ;
%mend which;


/************************************************************************************************
** Macro: TYPE
** Input: An ASCII text file that you want printed to your SAS output window or .lst file
**
** Programmer: Dan Blanchette   dan.blanchette@duke.edu
**             Center for Entrepreneurship and Innovation Duke University's Fuqua School of Business
** Developed at UNC-CH at:
**             Research Computing at The University of North Carolina at Chapel Hill and
**             Center for Entrepreneurship and Innovation Duke University's Fuqua School of Business
** Date: 26February2008
** Modified: 09Dec2010 - changed options to toptions and changed &swoptions to toptions despite the
**                        fact that it worked with the non-defined macro variable name swoptions.
**                      - Fixed it so that scanning for options is only done when there are options 
**                         specified by the user.
**
** Disclaimer:  This program is free to use and to distribute as long as credit is given
**               to Dan Blanchette and Research Computing at UNC-CH. The University of 
**               North Carolina at Chapel Hill is not responsible for results created by 
**               this macro. There is no warranty on this software either expressed or 
**               implied.  This program is released under the terms and conditions of 
**               GNU General Public License.
**
** Comments:
**   The TYPE SAS macro is just like the Stata command (and DOS command) -type-.  It 
**    just prints your text file to your output window or .lst file.  It even has the 
**    "starbang" option that Stata's -type- command has that prints only lines that 
**    start with "*!"
**
** EXAMPLE USE OF THE TYPE MACRO:
** %include"C:\SASmacros\type.sas"; ** Include macro once in a SAS session and call it **;
**                                   *  as many times as you like in that session.     **;
**
** %type("C:\my_project\some_text_file.txt");
**
** ** only print lines that start with "*!": **;
** %type("C:\my_project\some_text_file.txt", starbang);
**
************************************************************************************************/

%macro type(infile, toptions);
 %* remove quotes if surrounded by them *;
 %if %nrbquote(%index(%nrbquote(&infile.),%str(%")))=1   /* " */
   or %nrbquote(%index(%nrbquote(&infile.),%str(%')))=1  /* ' */
      %then %let infile=%nrbquote(%substr(%nrbquote(&infile.),2,%length(%nrbquote(&infile.))-2));

 %local sb w2;
 %let sb= 0;
 %let w2= print;
 %let toptions= %sysfunc(lowcase(%nrbquote(&toptions.)));

 %** need to remove dashes from toptions as SAS thinks they are minus signs and wants to evaluate stuff **;
  %*  need to do this in a data step so that the double quotes around toptions do not get added to the *;
  %*  toptions macro variable *;
 data _null_;
  call symput('toptions',translate("&toptions."," ","-"));
 run;

 %if %str(&toptions.) ^= %str() %then %do;
   %** Find out what options were specified **;
   %if %index(&toptions.,star) %then %let sb= 1; %** set starbang option  **;
   %if %index(&toptions.,log) %then %let w2= log; %** set w2 option  **;
 %end;

 data _null_;
  file &w2.;
  infile "%nrbquote(&infile.)" lrecl= 32767 truncover;
  input @1 starbang $2.;
  %if &sb. = 0 %then %do;
    put _infile_;
  %end;
  %else %do;
   if starbang = "*!" then put _infile_;
  %end;
 run;
%mend type;

