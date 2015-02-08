PROC IMPORT OUT= WORK.METHYL1 
            DATAFILE= "C:\SAS\SAS_DATA\NICHES\SOURCE_DATA\SLC6A2r.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
PROC SORT DATA=METHYL1;
BY NESTID;

PROC PRINT DATA=METHYL1;
TITLE 'METHYLATION OF ONE CPG SLC6A2'
RUN;

PROC IMPORT OUT= WORK.METHYL2 
            DATAFILE= "C:\SAS\SAS_DATA\NICHES\SOURCE_DATA\MMP9r.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
PROC SORT DATA=METHYL2;
BY NESTID;

PROC PRINT DATA=METHYL2;
TITLE 'METHYLATION OF FOUR CPG MMP9'
RUN;

PROC IMPORT OUT= WORK.METHYL3 
            DATAFILE= "C:\SAS\SAS_DATA\NICHES\SOURCE_DATA\MEG31Gr.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
PROC SORT DATA=METHYL3;
BY NESTID;

PROC PRINT DATA=METHYL3;
TITLE 'METHYLATION OF FOUR CPG MEG31G'
RUN;

PROC IMPORT OUT= WORK.METHYL4 
            DATAFILE= "C:\SAS\SAS_DATA\NICHES\SOURCE_DATA\MEG3CBS1r.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
PROC SORT DATA=METHYL4;
BY NESTID;

PROC PRINT DATA=METHYL4;
TITLE 'METHYLATION OF EIGHT CPG MEG3CBS1'
RUN;

DATA NEW 'C:\SAS\SAS_DATA\NICHES\SOURCE_DATA\nest_r01_r21_blq_med_05aug14.sas7bdat';
SET 'C:\SAS\SAS_DATA\NICHES\SOURCE_DATA\nest_r01_r21_blq_med_05aug14.sas7bdat';
PROC SORT DATA=NEW;
BY NESTID;
RUN;
PROC PRINT DATA=NEW;
RUN;


TITLE 'VARIABLES USED TO ADJUST METHYLATION DATA';
RUN;


DATA ADJUSTVARS; 
MERGE METHYL1 METHYL2 METHYL3 METHYL4 NEW; 
BY NESTID;
RUN;
PROC PRINT DATA=ADJUSTVARS;
TITLE 'METHYLATION OF ALL FOUR REGIONS';
RUN;



PROC PRINT DATA=ADJUSTVARS;
TITLE 'METHYLATION OF ALL FOUR REGIONS';
RUN;


*TABLE1;
PROC FREQ DATA=ADJUSTVARS;
TABLES MATERNAL_SMOKING2*(MOM_AGE_DELV RACE_FINAL2 EDUCATION MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER)/ NOPERCENT NOCOL;
RUN;
%MACRO ff(VAR);
PROC freq DATA=ADJUSTVARS;
  tables MATERNAL_SMOKING2/chisq;
  RUN;
%MEND;
%ff(RACE_FINAL2);	
%ff(EDUCATION);
%ff(MOM_AGE_DELV);
%ff(BABY_GENDER); 
%ff(BMI_LMP_KGM2);
%ff(BABY_WEIGHT);
%ff(MARITAL_STATUS);
%ff(MEG3IG_MEAN);
%ff(MMP9_MEAN);
%ff(MEG3CBS_MEAN);
%ff(SLC6A2_MEAN);
PROC MEANS DATA=ADJUSTVARS; VAR MOM_AGE_DELV;
RUN;
PROC FREQ DATA=ADJUSTVARS; TABLES MATERNAL_SMOKING2/LIST;
RUN;

PROC MEANS DATA=ADJUSTVARS; CLASS MATERNAL_SMOKING2;
	VAR SLC6A2_CG1 SLC6A2MEAN MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4 MMP9MEAN MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4 MEG3IGMEAN 
	MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8 MEG3CBS1MEAN;
	RUN;

PROC MEANS DATA=ADJUSTVARS;
	VAR SLC6A2_CG1 SLC6A2MEAN MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4 MMP9MEAN MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4 MEG3IGMEAN 
	MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8 MEG3CBS1MEAN;
	RUN;

PROC TTEST DATA=ADJUSTVARS; CLASS MATERNAL_SMOKING2;
	VAR SLC6A2_CG1 SLC6A2MEAN MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4 MMP9MEAN MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4 MEG3IGMEAN 
	MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8 MEG3CBS1MEAN;
	RUN;

PROC MEANS DATA=ADJUSTVARS MEAN STD MEDIAN MIN MAX FW=5;
	CLASS MATERNAL_SMOKING2;
	VAR SLC6A2_CG1 SLC6A2MEAN MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4 MMP9MEAN MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4 MEG3IGMEAN 
	MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8 MEG3CBS1MEAN;
	RUN;

PROC NPAR1WAY DATA=ADJUSTVARS WILCOXON MEDIAN ANOVA;
	CLASS MATERNAL_SMOKING2;
	VAR SLC6A2_CG1 SLC6A2MEAN MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4 MMP9MEAN MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4 MEG3IGMEAN 
	MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8 MEG3CBS1MEAN;
	RUN;

PROC GLM DATA=ADJUSTVARS;
	CLASS MATERNAL_SMOKING2;
	MODEL SLC6A2_CG1 SLC6A2MEAN=MATERNAL_SMOKING2/SOLUTION;
	RUN;
PROC GLM DATA=ADJUSTVARS;
	CLASS MATERNAL_SMOKING2;
	MODEL MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4 MMP9MEAN=MATERNAL_SMOKING2/SOLUTION;
	RUN;
PROC GLM DATA=ADJUSTVARS;
	CLASS MATERNAL_SMOKING2;
	MODEL MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4 MEG3IGMEAN=MATERNAL_SMOKING2/SOLUTION;
	RUN;
PROC GLM DATA=ADJUSTVARS;
	CLASS MATERNAL_SMOKING2;
	MODEL MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8 MEG3CBS1MEAN=MATERNAL_SMOKING2/SOLUTION;
	RUN;

PROC LOGISTIC DATA=ADJUSTVARS;
	CLASS MATERNAL_SMOKING2;
	MODEL BABY_WEIGHT=MATERNAL_SMOKING2;
	RUN;
proc univariate data=adjustvars plot; var slc6a2mean mmp9mean meg3igmean meg3cbs1mean;	run;
proc corr data=adjustvars alpha;
  var  SLC6A2_CG1 MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4 MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4 
	   MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8;
  run;
proc corr data=adjustvars alpha vardef=df out=data1;
  var SLC6A2_CG1 MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4 MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4 
	   MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8;
  run;
  proc factor data=adjustvars method=ml priors=smc rotate=varimax reorder; 
  var SLC6A2_CG1 MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4 MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4 
	   MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8;
  run;




proc factor data=adjustvars method=ml priors=smc; 	
  var SLC6A2_CG1 MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4 MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4 
	  MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8;
  run;	
  
proc calis data=adjustvars cov stderr all kurtosis modification residual;
lineqs
slc6a2_cg1 =lmmp9_cg1F1+e1;
std e1=ve1, F1=1; 
  var SLC6A2_CG1;
run;
proc calis data=adjustvars cov stderr all kurtosis modification residual;
lineqs
mmp9_cg1 =lmmp9_cg1F1+e1;
mmp9_cg2 =lmmp9_cg2F1+e2;
mmp9_cg3 =lmmp9_cg3F1+e3;
mmp9_cg4 =lmmp9_cg4F1+e4;
std e1-e4=ve1-ve4, F1=1; 
  var MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4;
run;
proc calis data=adjustvars cov stderr all kurtosis modification residual;
lineqs
MEG3IG_CG2 =lMEG3IG_CG2F1+e1;
MEG3IG_CG3 =lMEG3IG_CG3F1+e2;
MEG3IG_CG4  =lMEG3IG_CG4F1+e3;
MEG3IG_CG5  =lMEG3IG_CG5F1+e4;
std e1-e3=ve1-ve3, F1=1; 
  var MEG3IG_CG2 MEG3IG_CG3 MEG3IG_CG4;
run;
proc calis data=adjustvars cov stderr all kurtosis modification residual;
lineqs
MEG3CBS1_CG1 =lMEG3CBS1_CG1F1+e1;
MEG3CBS1_CG2 =lMEG3CBS1_CG2F1+e2;
MEG3CBS1_CG3 =lMEG3CBS1_CG3F1+e3;
MEG3CBS1_CG4 =lMEG3CBS1_CG4F1+e4;
MEG3CBS1_CG5 =lMEG3CBS1_CG5F1+e5;
MEG3CBS1_CG6 =lMEG3CBS1_CG6F1+e6;
MEG3CBS1_CG7 =lMEG3CBS1_CG7F1+e7;
MEG3CBS1_CG8 =lMEG3CBS1_CG8F1+e8;
std e1-e8=ve1-ve8, F1=1; 
  var MEG3CBS1_CG1 MEG3CBS1_CG2 MEG3CBS1_CG3 MEG3CBS1_CG4 MEG3CBS1_CG5 MEG3CBS1_CG6 MEG3CBS1_CG7 MEG3CBS1_CG8;
run;

%macro gg(dat,out, pred0=, pred1=,pred2= );
quit;
ods listing close; 	
ods output LSMeanDiffs = ls_m_d ; 
ods output LSMeans = ls_m ;
ods output type3 = ty3;  
ods output nobs=nobs;  
proc genmod data=&dat ; 
  class &pred0 &pred1;
  model &out=&pred0 &pred1 &pred2/d=n type3;
  lsmeans &pred0/pdiff cl;
  title2 "&dat, &pred0, &pred1, &pred2";
run;
ods listing;
quit; 
proc print data=ty3; 
proc print data=ls_m; 
proc print data=ls_m_d;run; 
data ls_m_;
  merge ls_m(keep=effect &pred0 mean) 
        ls_m_d(keep=effect &pred0. _&pred0. estimate stderr lowercl uppercl probchisq);
  by effect &pred0;
  if ^first.&pred0 then mean = .;
  
data nobs1; set nobs(keep=nobsread nobsused); if _n_ = 1;
   mergevar = 1;
proc sort data=ty3; by source;
data ls_m_ty3;
  merge ls_m_
        ty3(keep=source probchisq rename=(source=effect probchisq=p_type3));
	by effect;
  if ^first.effect then p_type3 = .;
  mergevar = 1;
run;
data x; set ls_m_ty3(keep=effect ); 
  if _n_ = 1; effect= "ZZZZZ";run;
data est_m1; set ls_m_ty3 x;
  by effect ; if ^first.effect then p_type3=.;
   if _n_ = 1 then mergevar=1;
              else mergevar=2;
proc print data=est_m2;run;
data est_m2(drop=mergevar rename=(&pred0=call _&pred0.=_call)); merge est_m1 nobs1; by mergevar;
  if effect = "ZZZZZ" then effect = "";
   if effect >"" then idd = "&dat"||"_"||"outcome="||"&out";
proc append base = stat data=est_m2 force;run; 
%mend; 
data miss; set adjustvars;
  if maternal_smoking2 ="" or mom_age_delv="" or education="" or race_final2="" or   
       bmi_lmp_kgm2="" or  marital_status="" or  baby_weight="" or  baby_gender="" ;
  run;
proc print data=miss;
  var nestid maternal_smoking2 mom_age_delv education race_final2 bmi_lmp_kgm2 marital_status baby_weight baby_gender;
  title2 "at one missing values in variables used in the MV";
  run; 

proc datasets;
  delete stat;
  run;
%let i  = 0;

%gg(adjustvars,SLC6A2_CG1,pred0=maternal_smoking2,pred1=,pred2=);  	

%gg(adjustvars,MMP9_CG1,pred0=maternal_smoking2,pred1=,pred2=);  	
%gg(adjustvars,MMP9_CG2,pred0=maternal_smoking2,pred1=,pred2=);  	
%gg(adjustvars,MMP9_CG3,pred0=maternal_smoking2,pred1=,pred2=);  	
%gg(adjustvars,MMP9_CG4,pred0=maternal_smoking2,pred1=,pred2=);  
	
%gg(adjustvars,MEG3IG_CG2,pred0=maternal_smoking2,pred1=,pred2=);  	
%gg(adjustvars,MEG3IG_CG3,pred0=maternal_smoking2,pred1=,pred2=);  	
%gg(adjustvars,MEG3IG_CG4,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(adjustvars,MEG3IG_CG5,pred0=maternal_smoking2,pred1=,pred2=); 
	
%gg(adjustvars,MEG3CBS1_CG1,pred0=maternal_smoking2,pred1=,pred2=);  	
%gg(adjustvars,MEG3CBS1_CG2,pred0=maternal_smoking2,pred1=,pred2=);
%gg(adjustvars,MEG3CBS1_CG3,pred0=maternal_smoking2,pred1=,pred2=);
%gg(adjustvars,MEG3CBS1_CG4,pred0=maternal_smoking2,pred1=,pred2=);
%gg(adjustvars,MEG3CBS1_CG5,pred0=maternal_smoking2,pred1=,pred2=);
%gg(adjustvars,MEG3CBS1_CG6,pred0=maternal_smoking2,pred1=,pred2=);
%gg(adjustvars,MEG3CBS1_CG7,pred0=maternal_smoking2,pred1=,pred2=);
%gg(adjustvars,MEG3CBS1_CG8,pred0=maternal_smoking2,pred1=,pred2=);

proc print data=stat;
title2 "unajusted for table 2"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;

%gg(adjustvars,slc6a2_cg1,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);  

%gg(adjustvars,mmp9_cg1,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,mmp9_cg2,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,mmp9_cg3,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,mmp9_cg4,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);

%gg(adjustvars,meg3ig_cg2,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,meg3ig_cg3,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,meg3ig_cg4,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,meg3ig_cg5,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);


%gg(adjustvars,meg3cbs1_cg1,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,meg3cbs1_cg2,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,meg3cbs1_cg3,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,meg3cbs1_cg4,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,meg3cbs1_cg5,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,meg3cbs1_cg6,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,meg3cbs1_cg7,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);
%gg(adjustvars,meg3cbs1_cg8,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_gender baby_weight,pred2=);

proc print data=stat;
title2 "ajusted for table 3"; run;
*** double check controlled variables ***;


data a_female a_male a_ge40 a_lt40 a_bwt_lt2500 a_bwt_GE2500;
  set adjustvars; if slc6a2mean>.
  if baby_gender= "1_MALE  "   then output a_male; 
  if baby_gender= "2_FEMALE"   then output a_female;
  if 40<=maternal_age_delv       then output a_ge40;
  if 0<  maternal_age_delv <40   then output a_lt40;
  if baby_weight = "1_LT2500" then output a_bwt_lt2500;	
  if baby_weight = "2_GE2500" then output a_bwt_ge2500;
run;


data a_female a_male a_ge40 a_lt40 a_bwt_lt2500 a_bwt_GE2500;
  set adjustvars; if mmp9mean>.
  if baby_gender= "1_MALE  "   then output a_male; 
  if baby_gender= "2_FEMALE"   then output a_female;
  if 40<=maternal_age_delv       then output a_ge40;
  if 0<  maternal_age_delv <40   then output a_lt40;
  if baby_weight = "1_LT2500" then output a_bwt_lt2500;	
  if baby_weight = "2_GE2500" then output a_bwt_ge2500;
run;


data a_female a_male a_ge40 a_lt40 a_bwt_lt2500 a_bwt_GE2500;
  set adjustvars; if megigmean>.
  if baby_gender= "1_MALE  "   then output a_male; 
  if baby_gender= "2_FEMALE"   then output a_female;
  if 40<=maternal_age_delv       then output a_ge40;
  if 0<  maternal_age_delv <40   then output a_lt40;
  if baby_weight = "1_LT2500" then output a_bwt_lt2500;	
  if baby_weight = "2_GE2500" then output a_bwt_ge2500;
run;


data a_female a_male a_ge40 a_lt40 a_bwt_lt2500 a_bwt_GE2500;
  set adjustvars; if meg3cbs1mean>.
  if baby_gender= "1_MALE  "   then output a_male; 
  if baby_gender= "2_FEMALE"   then output a_female;
  if 40<=maternal_age_delv       then output a_ge40;
  if 0<  maternal_age_delv <40   then output a_lt40;
  if baby_weight = "1_LT2500" then output a_bwt_lt2500;	
  if baby_weight = "2_GE2500" then output a_bwt_ge2500;
run;

proc datasets;
  delete stat;
  run;
%let i  = 0; 
%gg(a_lt40,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_ge40,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_bwt_lt2500,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_bwt_Ge2500,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_male,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_female,slc6a2mean,pred0=maternal_smoking2,pred1= ,pred2=); 

%gg(a_lt40,mmp9mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_ge40,mmp9mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_bwt_lt2500,mmp9mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_bwt_Ge2500,mmp9mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_male,mmp9mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_female,mmp9mean,pred0=maternal_smoking2,pred1= ,pred2=);  

%gg(a_lt40,megigmean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_ge40,megigmean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_bwt_lt2500,megigmean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_bwt_Ge2500,megigmean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_male,megigmean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_female,megigmean,pred0=maternal_smoking2,pred1= ,pred2=); 

%gg(a_lt40,meg3cbs1mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_ge40,meg3cbs1mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_bwt_lt2500,meg3cbs1mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_bwt_Ge2500,meg3cbs1mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_male,meg3cbs1mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_female,meg3cbs1mean,pred0=maternal_smoking2,pred1= ,pred2=); 
 


data a_female a_male a_ge40 a_lt40 a_bwt_lt2500 a_bwt_GE2500;
  set adjustvars; if mmp9mean>.
  if baby_gender= "1_MALE  "   then output a_male; 
  if baby_gender= "2_FEMALE"   then output a_female;
  if 40<=maternal_age_delv       then output a_ge40;
  if 0<  maternal_age_delv <40   then output a_lt40;
  if baby_weight = "1_LT2500" then output a_bwt_lt2500;	
  if baby_weight = "2_GE2500" then output a_bwt_ge2500;
run;
proc datasets;
  delete stat;
  run;
%let i  = 0; 
%gg(a_male,mmp9mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_female,mmp9mean,pred0=maternal_smoking2,pred1= ,pred2=);  

proc print data=stat;
title2 "stratified, unajusted for table 3a"; run;

data ADJUSTVARS_excl_ex a_male_ex a_female_ex a_ge40_ex a_lt40_ex a_bwt_lt2500_ex a_bwt_ge2500_ex;
  set adjustvars;
	output ADJUSTVARS_excl_ex;
	  if baby_sex= "1_MALE  "   then output a_male_ex; 
  if baby_sex= "2_FEMALE"   then output a_female_ex;
  if 40<=age_maternal       then output a_ge40_ex;
  if 0<  age_maternal <40   then output a_lt40_ex;
  if birth_wt_2500 = "1_LT2500" then output a_bwt_lt2500_ex;	
  if birth_wt_2500 = "2_GE2500" then output a_bwt_ge2500_ex;
	run; 

proc datasets;
  delete stat;
  run;

%let i  = 0;

%gg(ADJUSTVARS_excl_ex,slc6a2_cg1,pred0=maternal_smoking2,pred1=,pred2=);  	 	
%gg(ADJUSTVARS_excl_ex,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);  

%gg(a_lt40_ex      ,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_ge40_ex      ,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);   
%gg(a_bwt_lt2500_ex,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_bwt_ge2500_ex,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);  
%gg(a_male_ex      ,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);   
%gg(a_female_ex    ,slc6a2mean,pred0=maternal_smoking2,pred1=,pred2=);  
option ls = 160;
proc print data=stat;
title2 "sensitivty analysis for table 2 and 3";
run;
proc means data=ADJUSTVARS_excl_ex;class maternal_smoking2;
  var slc6a2_cg1 slc6a2mean;run;
proc means data=all_excl_ex;class maternal_smoking2;
  var mmp9_cg1-mmp9_cg4 mmp9mean;run;
proc means data=all_excl_ex;class maternal_smoking2;
  var megig_cg2-megig_cg5 megigmean;run;
proc means data=all_excl_ex;class maternal_smoking2;
  var meg3cbs1_cg1-meg3cbs1_cg8 meg3cbs1mean; run;   


proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: slc6a2_cg1"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MMP9_CG1"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MMP9_CG2"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MMP9_CG3"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MMP9_CG4"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MMP9MEAN"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEGIG_CG2"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEGIG_CG3"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEGIG_CG4"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEGIG_CG5"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEGIGMEAN"; run;


proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG1"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG2"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG3"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG4"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG5"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG6"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG7"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG8"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1MEAN"; run;


*** mixed model used ***;
data rev_fran;
  set ADJUSTVARS(keep=nestid slc6a2_cg1 mmp9_cg1 mmp9_cg2 mmp9_cg3 mmp9_cg4 megig_cg2 megig_cg3 megig_cg4 megig_cg5
            meg3cbs1_cg1 meg3cbs1_cg2 meg3cbs1_cg3 meg3cbs1_cg3 meg3cbs1_cg4 meg3cbs1_cg5 meg3cbs1_cg6 meg3cbs1_cg7 meg3cbs1_cg8
            MATERNAL_SMOKING2 MOM_AGE_DELV RACE_FINAL2 EDUCATION MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER);
 run;

proc corr data=rev_fran;
  var slc6a2_cg1 mmp9_cg1 mmp9_cg2 mmp9_cg3 mmp9_cg4 megig_cg2 megig_cg3 megig_cg4 megig_cg5
            meg3cbs1_cg1 meg3cbs1_cg2 meg3cbs1_cg3 meg3cbs1_cg3 meg3cbs1_cg4 meg3cbs1_cg5 meg3cbs1_cg6 meg3cbs1_cg7 meg3cbs1_cg8;
run;
data rev_fran_SLC6A2 rev_fran_MMP9 rev_fran_MEGIG rev_fran_MEG3CBS1;;
  set rev_fran;
    array cc SLC6A2_cg1;
	  do over cc;
	    SLC6A2 = cc;
		  if SLC6A2>. then output rev_fran_SLC6A2;
		  end; 
    array dd MMP9_CG1 MMP9_CG2 MMP9_CG3 MMP9_CG4;
	  do over dd;
	    mmp9 = dd;
		  if MMP9>. then output rev_fran_MMP9;
		  end;

     array ee megig_cg2 megig_cg3 megig_cg4 megig_cg5;
	  do over ee;
	    megig = ee;
		  if megig>. then output rev_fran_MEGIG;
		  end;

      array ff meg3cbs1_cg1 meg3cbs1_cg2 meg3cbs1_cg3 meg3cbs1_cg4 meg3cbs1_cg5 meg3cbs1_cg6 meg3cbs1_cg7 meg3cbs1_cg8;
	  do over ff;
	    meg3cbs1 = ff;
		  if meg3cbs1>. then output rev_fran_MEG3CBS1;
		  end;
run;

proc mixed data=rev_fran_SLC6A2 covtest ratio;	
  class maternal_smoking2 nestid;
   model slc6a2 = maternal_smoking2 /solution;
   lsmeans maternal_smoking2/diff;
   random intercept /sub=nestid type=vc;
   title2 "comparing mean SLC6A2_cg among smoke during pregnancy";
run;  
proc mixed data=rev_fran_MMP9 covtest ratio;	
  class maternal_smoking2 nestid;
   model MMP9 = maternal_smoking2 /solution;
   lsmeans maternal_smoking2/diff;
   random intercept /sub=nestid type=vc;
   title2 "comparing mean MMP9 among smoke during pregnancy";
run; 

proc mixed data=rev_fran_MEGIG covtest ratio;	
  class maternal_smoking2 nestid;
   model MEGIG = maternal_smoking2 /solution;
   lsmeans maternal_smoking2/diff;
   random intercept /sub=nestid type=vc;
   title2 "comparing mean MEGIG among smoke during pregnancy";
run;  
proc mixed data=rev_fran_MEG3CBS1 covtest ratio;	
  class maternal_smoking2 nestid;
   model MEG3CBS1 = maternal_smoking2 /solution;
   lsmeans maternal_smoking2/diff;
   random intercept /sub=nestid type=vc;
   title2 "comparing mean MEG3CBS1 among smoke during pregnancy";
run; 
/*%macro mm(wh1,wh2,wh3,pred1=,pred2=);
proc mixed data=rev_fran_dmr covtest ratio;	where(&wh3 &wh1 &wh2);
  class smoke_preg nestid;
   model dmr0 = smoke_preg /solution;
   lsmeans smoke_preg/diff;
   random intercept /sub=nestid type=vc;
   title2 "comparing mean H19_cg1 among smoke during pregnancy";
run;   /*
proc mixed data=rev_fran_dmr covtest ratio;	
  class smoke_cur nestid;
   model dmr0 = smoke_cur /solution;
   lsmeans smoke_cur/diff;
   random intercept /sub=nestid type=vc;
   title2 "comparing mean H19_cg1 among smoke during pregnancy";
run;  */
/*%mend; 	
%mm(age_maternal,<40,0<  ,pred1=,pred2=);   
%mm(age_maternal,<99,40<=,pred1=,pred2=);  
%mm(babywght_birth,<2500,0<,pred1=,pred2=); 	
%mm(babywght_birth,<3500,2500<=,pred1=,pred2=);  
%mm(babywght_birth,<50000,3500<=,pred1=,pred2=); 
%mm(baby_sex,="1_MALE  ",,pred1=,pred2=);  
%mm(baby_sex,="2_FEMALE",,pred1=,pred2=); 
proc freq data=in.all;tables babywght_birth;run;

*** table 3, 4 sensitivety analysis ***;
proc univariate data=in.all plot;
     var cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4 cbs1mean;
	 run;

proc freq data=in.all; tables cbs1mean;run;
data all_excl_extreme;
  set in.all;
    if cbs1_cg1>88 or cbs1_cg2>88 or cbs1_cg3>88 or cbs1_cg4>88 or cbs1mean > 88 then delete;
	run;*/
 
/*proc univariate data=all_excl_extreme plot;
     var cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4 cbs1mean;
	 run;
proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(all_excl_extreme,cbs1_cg1,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_extreme,cbs1_cg2,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_extreme,cbs1_cg3,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_extreme,cbs1_cg4,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_extreme,cbs1mean,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all_excl_extreme,cbs1_cg1,pred0=smoke_cur,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_extreme,cbs1_cg2,pred0=smoke_cur,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_extreme,cbs1_cg3,pred0=smoke_cur,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_extreme,cbs1_cg4,pred0=smoke_cur,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_extreme,cbs1mean,pred0=smoke_cur,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all_excl_ex,cbs1_cg1,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,cbs1_cg2,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,cbs1_cg3,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);   
%gg(all_excl_ex,cbs1_cg4,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,cbs1mean,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: dmr0*, exclude 5 pts"; run;
option ls = 160;
proc print data=stat;
title2 "outcome: cbs1*, exclude 11 pts"; run;*/


proc univariate data=adjustvars plot;
     var slc6a2_cg1 mmp9_cg1 mmp9_cg2 mmp9_cg3 mmp9_cg4 megig_cg2 megig_cg3 megig_cg4 megig_cg5
         meg3cbs1_cg1 meg3cbs1_cg2 meg3cbs1_cg3 meg3cbs1_cg4 meg3cbs1_cg5 meg3cbs1_cg6 meg3cbs1_cg7 meg3cbs1_cg8;
	 run;

*data all_excl_ex;
  *set in.all;
    *if dmr0_cg1>72 or dmr0_cg2>72 or dmr0_cg3>72 then delete;
	*    if dmr0_cg1>70 or dmr0_cg2>70 or dmr0_cg3>70 then delete;
	*run;
*proc univariate data=all_excl_ex plot;
     *var dmr0_cg1 dmr0_cg2 dmr0_cg3  dmr0mean;
	 *run;
proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(adjustvars,slc6a2_cg1,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);  

%gg(adjustvars,mmp9_cg1,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);  
%gg(adjustvars,mmp9_cg2,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=); 
%gg(adjustvars,mmp9_cg3,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=); 
%gg(adjustvars,mmp9_cg4,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);
%gg(adjustvars,mmp9mean,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=); 

%gg(adjustvars,megig_cg2,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);  
%gg(adjustvars,megig_cg3,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);  
%gg(adjustvars,megig_cg4,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);  
%gg(adjustvars,megig_cg5,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=); 
%gg(adjustvars,megigmean,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);

%gg(adjustvars,meg3cbs1_cg1,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);
%gg(adjustvars,meg3cbs1_cg2,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);
%gg(adjustvars,meg3cbs1_cg3,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);
%gg(adjustvars,meg3cbs1_cg4,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);
%gg(adjustvars,meg3cbs1_cg5,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);
%gg(adjustvars,meg3cbs1_cg6,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);
%gg(adjustvars,meg3cbs1_cg7,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);
%gg(adjustvars,meg3cbs1_cg8,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);
%gg(adjustvars,meg3cbs1mean,pred0=maternal_smoking2,pred1=mom_age_delv education race_final2 marital_status bmi_lmp_kgm2 baby_weight baby_gender, pred2=);


proc print data=stat;
title2 "outcome: slc6a2 mmp9 megig meg3cbs1"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,slc6a2_cg1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: slc6a2_cg1"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MMP9_CG1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MMP9_CG1"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MMP9_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MMP9_CG2"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MMP9_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MMP9_CG3"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MMP9_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MMP9_CG4"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MMP9MEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MMP9MEAN"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEGIG_CG2"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEGIG_CG3"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEGIG_CG4"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEGIG_CG5,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEGIG_CG5"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEGIGMEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEGIGMEAN"; run;


proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG1,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG1"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG2,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG2"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG3,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG3"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG4,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG4"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG5,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG5"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG6,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG6"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG7,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG7"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1_CG8,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1_CG8"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=EDUCATION,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=RACE_FINAL2,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=MARITAL_STATUS,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=BMI_LMP_KGM2,pred2=);  		
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_GENDER,pred2=);  	
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=BABY_WEIGHT BABY_GENDER,pred2=);  
%gg(ADJUSTVARS,MEG3CBS1MEAN,pred0=MATERNAL_SMOKING2,pred1=MOM_AGE_DELV EDUCATION RACE_FINAL2 MARITAL_STATUS BMI_LMP_KGM2 BABY_WEIGHT BABY_GENDER,pred2=);  
proc print data=stat;
title2 "outcome: MEG3CBS1MEAN"; run;


*** couldn't see any difference between offspring gender, maternal age and gestational age and birthwt ***;
proc freq data=adjustvars;
  tables mom_age_delv*baby_weight;
  run;
 
data a_female a_male a_ge40 a_lt40 a_LE36 a_gt36 a_bmilt30 a_bmige30 a_bwt_lt2500 a_bwt_GE2500;
  set adjustvars;
  if baby_gender= "1_MALE  "   then output a_male; 
  if baby_gender= "2_FEMALE  " then output a_female;
  if 40<=mom_age_delv       then output a_ge40;
  if 0< mom_age_delv <40   then output a_lt40;
  if bmi_lmp_kgm2 = "1___<30"       then output a_bmilt30;
  if bmi_lmp_kgm2 = "2__>=30"       then output a_bmiGE30; 
  if baby_weight = "1_LT2500" then output a_bwt_lt2500;	
  if baby_weight = "2_GE2500" then output a_bwt_ge2500;
run;

*proc freq data=a_male; 
*tables race_final2;
*run;
*proc univariate data=a_male plot;
*where(race_final2="1");
 * var slc6a2_cg1 mmp9_cg1 mmp9_cg2 mmp9_cg3 mmp9_cg4 megig_cg2 megig_cg3 megig_cg4 megig_cg5 megigmean 
      meg3cbs1_cg1 meg3cbs1_cg2 meg3cbs1_cg3 meg3cbs1_cg4 meg3cbs1_cg5 meg3cbs1_cg6 meg3cbs1_cg7 meg3cbs1_cg8 meg3cbsmean;
  *    run;

*data a_male_s; 
*set a_male;
   *if race_final2="1" then do;
 *     if .<slc6a2_cg1 < 20 or dmr0_cg1 > 70 
  *       or .<dmr0_cg2 < 33 or dmr0_cg2 > 70 	
         or .<dmr0_cg3 < 30 or dmr0_cg3 > 70 
         or .<dmr0mean < 36 or dmr0mean > 60  then output;
	*	 end;
*run;
*proc print data=chk;
*var nestid;
*run;
*proc print data=a_male_s ;
 * var nestid smoke_cur dmr0_cg1 dmr0_cg2 dmr0_cg3 dmr0mean race_3;
*run;
*proc genmod data=a_male ; 
 * class smoke_cur;
  *model dmr0mean=smoke_cur /d=n type3 ;
  *output out =x RESDEV=r;
*run;
*data x1;*set x(keep=nestid r); 
*if r > 20;
*run;
*proc print data=x1;
*run;
*proc univariate data=x1 plot;
*var r;
*run;
*proc print data=x; 
*var r;
*run;

*data all_a; *set all ;*if baby_sex^="00_MISS";
*run;
*proc genmod data=all_a;
 * class smoke_cur baby_sex;
 * model dmr0_cg3=smoke_cur baby_sex smoke_cur*baby_sex/d=n type3 ;
 * lsmeans baby_sex/pdiff; 
 *lsmeans smoke_cur/pdiff;
*run;

*data a_male_s; *set a_male; 
  *if nestid ^in (622,635);
 *  if nestid ^in (349 380 494 622,635 641);
*run;
*proc datasets;
 * delete stat;
  *run;
/*%let i  = 0;

%gg(a_male_s  ,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_male_s  ,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_male_s  ,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_male_s  ,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_male_s  ,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_male_s  ,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_male_s  ,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_male_s  ,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_male_s  ,dmr0mean,pred0=smoke_cur,pred1=,pred2=); 

proc print;
run;*/
 
/*
proc datasets;
  delete stat;
  run;
%let i  = 0;

%gg(a_female,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_female,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_female,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_female,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_female,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_female,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_female,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_female,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_female,dmr0mean,pred0=smoke_cur,pred1=,pred2=); 

%gg(a_male  ,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_male  ,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_male  ,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_male  ,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_male  ,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_male  ,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_male  ,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_male  ,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_male  ,dmr0mean,pred0=smoke_cur,pred1=,pred2=); */
/*

%gg(a_ge40,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_ge40,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_ge40,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_ge40,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_ge40,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_ge40,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_ge40,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_ge40,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_ge40,dmr0mean,pred0=smoke_cur,pred1=,pred2=); 

%gg(a_lt40,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_lt40,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_lt40,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_lt40,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_lt40,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_lt40,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_lt40,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_lt40,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_lt40,dmr0mean,pred0=smoke_cur,pred1=,pred2=); */
/*
%gg(a_le36,cbs1_cg1,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_le36,cbs1_cg2,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_le36,cbs1_cg3,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_le36,cbs1_cg4,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_le36,cbs1mean,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_le36,dmr0_cg1,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_le36,dmr0_cg2,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_le36,dmr0_cg3,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_le36,dmr0mean,pred0=smoke_preg,pred1=,pred2=); 

%gg(a_gt36,cbs1_cg1,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_gt36,cbs1_cg2,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_gt36,cbs1_cg3,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_gt36,cbs1_cg4,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_gt36,cbs1mean,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_gt36,dmr0_cg1,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_gt36,dmr0_cg2,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_gt36,dmr0_cg3,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_gt36,dmr0mean,pred0=smoke_preg,pred1=,pred2=); 

%gg(a_bmilt30,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmilt30,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmilt30,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmilt30,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmilt30,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmilt30,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmilt30,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmilt30,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmilt30,dmr0mean,pred0=smoke_cur,pred1=,pred2=); */
/*
%gg(a_bmige30,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmige30,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmige30,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmige30,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmige30,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmige30,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmige30,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmige30,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmige30,dmr0mean,pred0=smoke_cur,pred1=,pred2=); 

%gg(a_bwt_lt2500,cbs1_cg1,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_bwt_lt2500,cbs1_cg2,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_bwt_lt2500,cbs1_cg3,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_bwt_lt2500,cbs1_cg4,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_bwt_lt2500,cbs1mean,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_bwt_lt2500,dmr0_cg1,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_bwt_lt2500,dmr0_cg2,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_bwt_lt2500,dmr0_cg3,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_bwt_lt2500,dmr0mean,pred0=smoke_preg,pred1=,pred2=); 

%gg(a_bwt_GE2500,cbs1_cg1,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_bwt_GE2500,cbs1_cg2,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_bwt_GE2500,cbs1_cg3,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_bwt_GE2500,cbs1_cg4,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_bwt_GE2500,cbs1mean,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_bwt_GE2500,dmr0_cg1,pred0=smoke_preg,pred1=,pred2=); 	
%gg(a_bwt_GE2500,dmr0_cg2,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_bwt_GE2500,dmr0_cg3,pred0=smoke_preg,pred1=,pred2=); 
%gg(a_bwt_GE2500,dmr0mean,pred0=smoke_preg,pred1=,pred2=); 

%gg(a_bwt_lt2500,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bwt_lt2500,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bwt_lt2500,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bwt_lt2500,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bwt_lt2500,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bwt_lt2500,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bwt_lt2500,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bwt_lt2500,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bwt_lt2500,dmr0mean,pred0=smoke_cur,pred1=,pred2=); 

%gg(a_bwt_GE2500,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bwt_GE2500,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bwt_GE2500,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bwt_GE2500,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bwt_GE2500,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bwt_GE2500,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bwt_GE2500,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bwt_GE2500,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bwt_GE2500,dmr0mean,pred0=smoke_cur,pred1=,pred2=); */

proc print data=stat;
title2 "stratified analysis"; run; 

proc datasets;
  delete stat;
  run;
%let i  = 0;

%gg((adjustvars,slc6a2_cg1,pred0=art_curr,pred1=          age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg((in.all,cbs1_cg1,pred0=art_curr,pred1=smoke_cur age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all,cbs1_cg2,pred0=art_curr,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all,cbs1_cg2,pred0=art_curr,pred1=smoke_cur age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all,cbs1_cg3,pred0=art_curr,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all,cbs1_cg3,pred0=art_curr,pred1=smoke_cur age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all,cbs1_cg4,pred0=art_curr,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all,cbs1_cg4,pred0=art_curr,pred1=smoke_cur age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all,cbs1mean,pred0=art_curr,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all,cbs1mean,pred0=art_curr,pred1=smoke_cur age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all,dmr0_cg1,pred0=art_curr,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all,dmr0_cg1,pred0=art_curr,pred1=smoke_cur age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all,dmr0_cg2,pred0=art_curr,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all,dmr0_cg2,pred0=art_curr,pred1=smoke_cur age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all,dmr0_cg3,pred0=art_curr,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all,dmr0_cg3,pred0=art_curr,pred1=smoke_cur age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  


%gg(all,dmr0mean,pred0=art_curr,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all,dmr0mean,pred0=art_curr,pred1=smoke_cur age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "art use and not, table 3"; run; 

%ll(pred1=smoke_cur ,pred2=cbs1mean_hyper art_curr age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 baby_sex, pred3= ); 
data all_b_graph_susan(keep=nestid smoke_cur smoke_preg cbs1mean dmr0mean baby_sex );
  set in.all;
  run;
PROC EXPORT DATA= WORK.all_b_graph_susan 
       OUTFILE= "P:\Frances_Joellen_prostatestudy\Cathrine_HOYO\JULY_2010_SMKPAPER\graph_susan.xls" 
            DBMS=EXCEL REPLACE;
     SHEET="graph_susan"; 
RUN;
data all_b  
  set in.all; if . <  babywght_birth;
run;

%macro ll0(pred1=,pred2=,pred3=);
quit;
  %let i = %eval(&i + 1);
ods listing close;
ods output CLOddsPL=or;
ods output ParameterEstimates=p; 
ods output responseprofile=obs;

proc logistic data=all_b ;
  class &pred1  &pred2  ;
  model birth_wt_2500= &pred1 &pred2 &pred3/link=logit CLODDS=PL ;
run; 
ods listing;
quit;
*proc print data= or;
*proc print data=p;  run;
*proc print data=obs;
run;
data or1(drop=effect); set or; 
   variable = substr(effect,1,18);
proc sort data=or1; by variable;
proc sort data=p  ; by variable;
data all1; 
  merge p(drop=df estimate stderr waldchisq) or1(in=in1) ;
  by variable; *if in1;
run;
data all; set all1 obs(in=in1 drop=orderedvalue);
   if in1 then variable = "MODEL INFO";
   if variable = "Intercept" then delete;
   idd = &i;
run;
proc append base= stat data=all force;run;
%mend; 

%macro ll(pred1=,pred2=,pred3=);
quit;
  %let i = %eval(&i + 1);
ods listing close;
ods output CLOddsPL=or;
ods output ParameterEstimates=p; 
ods output responseprofile=obs;

proc logistic data=all_b ;
  class &pred1  &pred2  ;
  model birth_wt_2500= &pred1 &pred2 &pred3/link=logit CLODDS=PL ;
run; 
ods listing;
quit;
*proc print data= or;
*proc print data=p;  
*proc print data=obs;
run;
data or1(drop=effect); set or; 
   variable = substr(effect,1,18);
proc sort data=or1; by variable;
proc sort data=p  ; by variable;
data all1(drop=classval0); 
  merge p(drop=df estimate stderr waldchisq) or1(in=in1) ;
  by variable; *if in1;
   compare=substr(classval0||"__________",1,10);
run;
data all(drop=unit); set all1 obs(in=in1 drop=orderedvalue);
   if in1 then variable = "MODEL INFO";
   if variable = "Intercept" then delete;
   idd = &i;
run;
proc append base= stat data=all force;run;
%mend; 
proc datasets;
  delete stat; run;
%let i =0; 	

%ll(pred1=smoke_cur ,pred2=, pred3= ); 	
   
%ll(pred1=cbs1mean_hyper ,pred2=, pred3= ); 
%ll(pred1=smoke_cur ,pred2=cbs1mean_hyper, pred3= ); 	
%ll(pred1=smoke_cur ,pred2=cbs1mean_hyper art_curr age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 baby_sex, pred3= ); 
   
%ll(pred1=          ,pred2=dmr0mean_hypo, pred3= ); 	
%ll(pred1=smoke_cur ,pred2=dmr0mean_hypo, pred3= ); 	
%ll(pred1=smoke_cur ,pred2=dmr0mean_hypo art_curr age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 baby_sex, pred3= ); 	

proc print;title2 "modelling low birth weight ";
run;
 *** check the mediation effect of mythelation ***;

%include 'P:\Frances_Joellen_prostatestudy\Cathrine_HOYO\mediator\mixedmediationmacrobinary.sas';

 
*data all_mediator all_mediator_f all_mediator_m
    slc6a2_mediator slc6a2_mediator_f slc6a2_mediator_m
    mmp9_mediator mmp9_mediator_f mmp9_mediator_m
	megig_mediator megig_mediator_f megig_mediator_m
	meg3cbs1_mediator meg3cbs1_mediator_f meg3cbs1_mediator_m;
 * set in.all;
  *       if    . <  babywght_birth < 2500  then birth_wt = 1;
*	else if 2500 <= babywght_birth < 10000 then birth_wt = 0;
	   *  if .<cbs1mean < 62.57 then cbs1_hyper=0;
	*else if   cbs1mean >=62.57 then cbs1_hyper=1; 
	 *    if .<dmr0mean <= 43.205 then dmr0_hypo =1;
	*else if   dmr0mean > 43.205  then dmr0_hypo =0;
	*     if  smoke_cur = "9_NOT  " then smoke_c_n=0;
	*else if  smoke_cur = "1_YES  " then smoke_c_n=1;
	 *output all_mediator;
	 *if baby_sex="1_MALE" then output all_mediator_m; 
	 *if baby_sex="2_FEMALE" then output all_mediator_f;
	 *if dmr0mean>. then do;
	 *output dmr0_mediator;
	 *if baby_sex="1_MALE" then output dmr0_mediator_m; 
	 *if baby_sex="2_FEMALE" then output dmr0_mediator_f;
	 *  end;	   
	 *if cbs1mean>. then do;
	 *output cbs1_mediator;
*	 if baby_sex="1_MALE" then output cbs1_mediator_m; 
*	 if baby_sex="2_FEMALE" then output cbs1_mediator_f;
*	   end;
*run;

*%mediation(data= all_mediator, X=smoke_c_n, M=cbs1mean  , Y=birth_wt );	
*%mediation(data= all_mediator, X=smoke_c_n, M=cbs1_hyper, Y=birth_wt );	
*%mediation(data= all_mediator, X=smoke_c_n, M=dmr0mean  , Y=birth_wt ); 
*%mediation(data= all_mediator, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );

*%mediation(data= dmr0_mediator, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );

*%mediation(data= all_mediator_m, X=smoke_c_n, M=cbs1_hyper, Y=birth_wt );	
*%mediation(data= all_mediator_m, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );	

*%mediation(data= all_mediator_f, X=smoke_c_n, M=cbs1_hyper, Y=birth_wt );	
*%mediation(data= all_mediator_f, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );

*%mediation(data= dmr0_mediator_m, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );	
*%mediation(data= dmr0_mediator_f, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );


*** birth wt mediate dmr = smoke***;
*%mediation(data= dmr0_mediator_m, X=smoke_c_n, M=birth_wt,Y=dmr0_hypo );	
*%mediation(data= dmr0_mediator_f, X=smoke_c_n, M=birth_wt,Y=dmr0_hypo );	
*%mediation(data= dmr0_mediator,   X=smoke_c_n, M=birth_wt,Y=dmr0_hypo );



*proc freq data=all_mediator;
 * tables smoke_cur*cbs1mean_hyper*birth_wt;
*run;
*proc freq data=all_mediator;
*  tables smoke_cur*birth_wt/chisq;
*run;
*proc freq data=all_mediator;
 * tables birth_wt*cbs1mean_hyper/chisq;
*run;
*proc freq data=all_mediator;
 * tables smoke_cur*cbs1mean_hyper/chisq;
*run;
*proc freq data=all_mediator;
 * tables smoke_cur*birth_wt/chisq;
*run;
*proc freq data=all_mediator;
*  tables birth_wt*dmr0mean_hypo/chisq;
*run;
*proc freq data=all_mediator;
*  tables smoke_cur*dmr0mean_hypo/chisq;
*run;
*proc freq data=all_mediator;
*  tables dmr0mean_hypo*smoke_cur*birth_wt/all;
*run;

*proc freq data=all_mediator;*tables dmr0_hypo*smoke_preg*birth_wt/missing list;run;

*proc logistic data=cbs1_mediator descending;
*  class smoke_preg;
*  model birth_wt=smoke_preg;
*  run;
  
*proc logistic data=cbs1_mediator descending;
*  class smoke_preg;
*  model birth_wt=smoke_preg;
*  run;
  
*proc logistic data=dmr0_mediator descending;
 * class smoke_preg(param=ref);
  *model birth_wt=smoke_preg;
  *run;
*proc logistic data=dmr0_mediator descending;
*  class smoke_preg(param=ref) dmr0mean_hypo;
*  model birth_wt=smoke_preg  dmr0mean_hypo;
*  run; 
  
*%mediation(data= dmr0_mediator, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );

*proc logistic data=dmr0_mediator_m descending;
*  class smoke_preg(param=ref);
*  model birth_wt=smoke_preg;
 * run;
*proc logistic data=dmr0_mediator_m descending;
*  class smoke_preg(param=ref) dmr0mean_hypo;
*  model birth_wt=smoke_preg  dmr0mean_hypo;
 * run; 
  
*%mediation(data= dmr0_mediator_m, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt ); 

*proc logistic data=dmr0_mediator_f descending;
*  class smoke_preg(param=ref);
*  model birth_wt=smoke_preg;
*  run;
*proc logistic data=dmr0_mediator_f descending;
*  class smoke_preg(param=ref) dmr0mean_hypo;
*  model birth_wt=smoke_preg  dmr0mean_hypo;
 * run; 
  
*%mediation(data= dmr0_mediator_f, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );


*proc logistic data=dmr0_mediator descending;
*  class smoke_preg(param=ref) age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 baby_sex(param=ref);
*  model birth_wt=smoke_preg  race_3 bmi4_c age_gest_36 ;
*  run;
  
*proc logistic data=dmr0_mediator descending;
*  class smoke_preg(param=ref) dmr0mean_hypo(param=ref) age_ma_3(param=ref) edu_3(param=ref) race_3(param=ref) marital(param=ref) bmi4_c(param=ref) age_gest_36(param=ref) baby_sex(param=ref)  ;
*  model birth_wt=smoke_preg dmr0mean_hypo age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 baby_sex;
 * run; 
  
*proc logistic data=dmr0_mediator descending;
 * class smoke_preg(param=ref) dmr0mean_hypo(param=ref) age_ma_3(param=ref) edu_3(param=ref) race_3(param=ref) marital(param=ref) bmi4_c(param=ref) age_gest_36(param=ref) baby_sex(param=ref)  ;
 * model birth_wt=smoke_preg dmr0mean_hypo age_ma_3  race_3 bmi4_c age_gest_36 baby_sex;
 * run; 
*proc logistic data=dmr0_mediator descending;
*  class smoke_preg(param=ref) dmr0mean_hypo(param=ref) age_ma_3(param=ref) edu_3(param=ref) race_3(param=ref) marital(param=ref) bmi4_c(param=ref) age_gest_36(param=ref) baby_sex(param=ref)  ;
*  model birth_wt=smoke_preg dmr0mean_hypo age_ma_3  race_3 bmi4_c age_gest_36 ;
*  run; 
*proc logistic data=dmr0_mediator descending;
*  class smoke_preg(param=ref) dmr0mean_hypo(param=ref) age_ma_3(param=ref) edu_3(param=ref) race_3(param=ref) marital(param=ref) bmi4_c(param=ref) age_gest_36(param=ref) baby_sex(param=ref)  ;
*  model birth_wt=smoke_preg dmr0mean_hypo   race_3 bmi4_c age_gest_36 ;
*  run;

*proc logistic data=dmr0_mediator_m descending;
*  class smoke_preg(param=ref) dmr0mean_hypo(param=ref) age_ma_3(param=ref) edu_3(param=ref) race_3(param=ref) marital(param=ref) bmi4_c(param=ref) age_gest_36(param=ref) baby_sex(param=ref)  ;
*  model birth_wt=smoke_preg age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 ;
*  run;
  
*proc logistic data=dmr0_mediator_m descending;
*  class smoke_preg(param=ref) dmr0mean_hypo age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36   ;
 * model birth_wt=smoke_preg dmr0mean_hypo age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 ;
 * run;

*proc logistic data=dmr0_mediator_f descending;
*  class smoke_preg(param=ref) age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 (param=ref);
*  model birth_wt=smoke_preg age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 ;
*  run;
  
*proc logistic data=dmr0_mediator_f descending;
*  class smoke_preg(param=ref) dmr0mean_hypo age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36   ;
*  model birth_wt=smoke_preg dmr0mean_hypo age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 ;
*  run;
***stop here***; 
  
*proc logistic data=all_mediator descending;
* where(cbs1mean>. and smoke_cur>"");
*  class smoke_cur cbs1_hyper;
*  model birth_wt=smoke_preg cbs1_hyper ;
 * run;
*proc logistic data=all_mediator descending;
*where(dmr0mean>. and smoke_cur>"");
*  class smoke_cur dmr0_hypo;
*  model birth_wt=smoke_preg dmr0_hypo;
 * run;


	
