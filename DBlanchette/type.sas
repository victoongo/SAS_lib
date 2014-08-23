/************************************************************************************************
** Macro: TYPE
** Input: An ASCII text file that you want printed to your SAS output window or .lst file
**
** Programmer: Dan Blanchette   dan_blanchette@unc.edu
**             The Carolina Population Center at The University of North Carolina at Chapel Hill
** Developed at:
**             Research Computing at The University of North Carolina at Chapel Hill and
**             Center for Entrepreneurship and Innovation Duke University's Fuqua School of Business
** Date: 26February2008
** Modified: 09Dec2010 - changed options to toptions and changed &swoptions to toptions despite the
**                        fact that it worked with the non-defined macro variable name swoptions.
**                      - Fixed it so that scanning for options is only done when there are options 
**                         specified by the user.
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



