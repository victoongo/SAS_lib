/******************************************************************************
** Macro: RUNQUIT
** Description: A SAS macro that does an error check after any procedure or
**               data step and stops SAS from processing the rest of your
**               code if an error has occurred.
**
** Programmer: Dan Blanchette   dan_blanchette@unc.edu
**             Carolina Population Center 
**             University of North Carolina at Chapel Hill 
** Date: 14May2010
** Modified: 08Jun2010 - added %_ABORT CANCEL;  if running SAS 9 or higher
**                        and a way to get SAS Session Manager to pop-up for
**                        pre-SAS 9 users.
**
** Disclaimer:  This program is free to use and to distribute as long as credit is given to
**               Dan Blanchette 
**               The Carolina Population Center 
**               University of North Carolina at Chapel Hill
**
**              There is no warranty on this software either expressed or implied.  This program
**               is released under the terms and conditions of GNU General Public License.
**
** Comments:  The macro RUNQUIT inserts "run;" and "quit;" into your code and
**             does an error check and if an error has occurred it stops SAS from 
**             continuing to process the rest of the submitted statements.  You can 
**             just type "%runquit;" instead of "run;" or "quit; in your code so 
**             that SAS will stop whenever an error occurs.
**       
**            For batch SAS users, RUNQUIT inserts "endsas;" into your code when an 
**             error occurs and thus stops the program from continuing.
**
**            For interactive SAS users running SAS 9 (or higher) RUNQUIT invokes the 
**             SAS macro %ABORT with the CANCEL option which only cancels submitted
**             statements and writes this in your log for SAS 9.2 or higher:
**
**              ERROR: Execution canceled by an %ABORT CANCEL statement.
**              NOTE: The SAS System stopped processing due to receiving a CANCEL request.
**
**             SAS 9 introduced the %ABORT macro but it did not have the CANCEL option,
**              but "%ABORT cancel;" still stops SAS from processing the rest of your
**              code in an interactive SAS session without terminating your session.
**              It writes this error message in your log:
**              
**              ERROR: Unrecognized option on %ABORT statement: cancel
**              ERROR: Execution terminated by an %ABORT statement
**             
**            For interactive SAS Windows users running an earlier version of SAS than
**             version 9 running SAS on the Windows operating system, RUNQUIT basically 
**             presses the Interrupt button (the icon with the exclamation point "!" in 
**              a circle in the SAS toolbar) for you when an error occurs.  When the 
**             pop-up window comes up all you have to do is click "OK" two times as long 
**             as your default selected answers are:
**                 1. Cancel Submitted Statements
**             and in the 2nd pop-up:
**                 Y to cancel submitted statements
**            
**            For interactive SAS Windows users running an earlier version of SAS 
**             than 9 but not running SAS on the Windows operating system, 
**             RUNQUIT pops up a window to pause SAS and to instruct you to click 
**             the Interrupt button in your SAS Session Manager (which is normally 
**              minimized when SAS is invoked).
**
** If you are running SAS 9.2 or higher and want to copy and paste RUNQUIT into the top 
**  of all your SAS programs, RUNQUIT can be as simple as:
** 
**   %macro runquit;
**     ; run; quit; 
**     %if &syserr. ne 0 %then %do;
**        %abort cancel;
**     %end;
**   %mend runquit;
**
**
** EXAMPLE USE OF THE RUNQUIT MACRO:
** %include"C:\SASmacros\runquit.sas"; ** Include macro once in a SAS session **;
**                                      *  and call it as many times as you like
**                                      *  in that session.     **;
**
**   ** This will generate an error
**    *  due to an invalid libref: **;
**   proc contents data=sas_please_help.shoes;
**   %runquit;
**
**   ** This procedure will not be run due to the 
**    *  error generated from the previous procedure: **;
**   proc contents data=sashelp.shoes;
**   %runquit;
**
**
*******************************************************************************/

%macro runquit;
   ; run; quit;
  %if &syserr. ne 0 %then %do;
    %if %sysevalf(&sysver. * 100) >= 900 %then %do; 
      %if %nrbquote(&sysprocessname.) = DMS Process %then %do;
        %abort cancel;
      %end;
      %else %do;
        endsas; 
      %end;
    %end;
    %** else do if SAS 8 or earlier **;
    %if %nrbquote("&sysprocessname.") ne "DMS Process" %then %do;
      endsas; 
    %end;
    %else %do;
      %if "&sysscp." = "WIN" %then %do;
        dm "WATTENTION";
      %end;
      %else %do;

        %** open up a window **;
        %local something;
        %let something=;
        data _null_;
         length something $10;
         window non_win_os
             rows=20
             columns=75
             #2 @4 'AN ERROR HAS OCCURRED' color=red
             #4 @4 'Click the Interrupt button in your SAS Session Manager'
             #5 @4 ' to stop SAS from continuing to process your code.'
             #6 @4 ' Choose:'
             #7 @4 '   Cancel Submitted Statements'
             #8 @4 'This will not end your SAS session.'
             #10 @4 'Press ENTER to make the SAS Session Manager window pop-up.'  something 
             #11 @4 ' An error message window will also pop-up that you just click OK.'
             #13 @4 'Close this window to let SAS continue processing your code.'
          ;;;
         display non_win_os;
         call symput('something',something);
         stop;
        run;
        %if "&something." ne "" %then %do;
          dm 'hostedit';
          data _null_;
           window sas_session_mgr
               rows=10
               columns=75
               #2 @4 'Find the error message pop-up window and click OK'
               #3 @4 ' then find the SAS Session Manager window and click Interrupt'
               #5 @4 'Press ENTER to let SAS continue processing your code.'
           ;;;
           display sas_session_mgr;
           stop;
          run;
        %end;
      %end;
    %end;
  %end;
%mend runquit;

