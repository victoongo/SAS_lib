%let nihtb='p:\NICHES\NIHTB';
libname nihtb &nihtb.;

%let redcap='p:\NICHES\redcap';
libname redcap &redcap.;

%let niches="P:\NICHES";
libname niches &niches.;

%include "D:\Dropbox\Projects\sas_lib\import_macros.sas";
%include "D:\Dropbox\Projects\sas_lib\chrtonum2.sas";
%include "D:\Dropbox\Projects\sas_lib\countby.sas";
%include "D:\Dropbox\Projects\sas_lib\reshape_wide.sas";
%include "D:\Dropbox\Projects\sas_lib\scoring.sas";

