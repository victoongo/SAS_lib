%let nihtb='D:\Projects\NIHTB';
libname nihtb &nihtb.;

%let redcap='D:\Projects\redcap';
libname redcap &redcap.;

%include "D:\Dropbox\Projects\sas_lib\import_macros.sas";
%include "D:\Dropbox\Projects\sas_lib\chrtonum2.sas";
%include "D:\Dropbox\Projects\sas_lib\countby.sas";
%include "D:\Dropbox\Projects\sas_lib\reshape_wide.sas";
%include "D:\Dropbox\Projects\sas_lib\scoring.sas";

