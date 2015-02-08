/******************************************************************************
this pgm is for Cathrine, data from Francine Overcash, Oct 01, 2009

   smoking paper, association between methylation shifts and smoking

Frances Wang July 2010 for research fellow  under Cathrine.
*******************************************************************************/
libname CC "p:\frances_joellen_HOYO\Cathrine_HOYO\nest\data_original";
libname in "p:\frances_joellen_HOYO\Cathrine_HOYO\data_sas";
option ls = 120 ps = 160 nocenter nodate nonumber;
title "Cathrine, Joellen, &Sysdate";
%macro mm(dat);
PROC IMPORT OUT= WORK.&dat 
           datafile="P:\Frances_Joellen_hoyo\Cathrine_HOYO\nest\data_original\allaledata_dataforimport_093009_forFrances.xls"
            DBMS=EXCEL REPLACE;
     SHEET="&dat.$"; 
     GETNAMES=YES;     MIXED=YES;     SCANTEXT=YES;     USEDATE=YES;     SCANTIME=YES;
RUN; 
title2 "data=&dat."; 
*proc contents data=&dat;run;
proc sort data=&dat; by nestid;
data &dat._m chk; set &dat;
  by nestid; 
    if first.nestid                then output &dat._m;	 *** need check if first.id is right ***;
    if first.nestid+last.nestid^=2 then output chk;
 run;
proc print data=chk;title3 "duplicate"; run; 
*proc freq data=&dat._m; run;
%mend;
%mm(medabs_f);	***859***;
/*proc print data=medabs_f_m;where(nestid in (309,337,479,525,596,654,679,867,9046,9061,9068));*/
%mm(infectabs_f);	***791****;
/*proc print data=infectabs_f_m;where(nestid in (118,128,358)); */
run;
%mm(Questionnaire);	***900****;
*proc contents data=medabs_f;run;
proc sort data=cc.methylcomplete4;by nestid;run;

/*proc contents data=Questionnaire;run;
proc freq data=all;where(smoke_preg="2__QUIT");tables smokestopage*smokebehaveafterpreg/list missing;run;*/
data in.all chk_notepi;
   merge cc.methylcomplete4(in=inm keep=nestid cbs1mean cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4
         dmr0mean dmr0_cg1 dmr0_cg2 dmr0_cg3 finalsmk finalsmk2 bmi2 bmiusual gestdiab race 
   	     hispanic education  pregfolate prepregfolate apgarscore
         vitintak prevituse pregvituse alcoholbefore alcoholafter alcobef alcoaft)
         medabs_f_m(in=inmed keep=nestid delidate_medabst momdob_medabst ga_medabst babygen_medabst 
                        babywght_birth mom_lastwght mom_frstwght diabetes prediab  ) 
		 Questionnaire(in=inq keep=nestid weeksatdelivery_ques smoke100cigs currentsmoke smokestopage 
                        smokeyearpreg smokebehaveafterpreg artuse artcurrentbaby arttype matstatus
                        contraceptive12month typehormonalcontraceptive usingcontatconception hormonestop)
            ;
		 * infectabs_f_m(in=ininf );
     by nestid;
	if inmed then idd ="inmed ";
	*if ininf then iddf="ininf ";
    if inq   then iddq="inque ";
    if inm   then iddm="inmet ";	
	***define hyper CBS1 and hypo DMR0***;
	     if .<cbs1mean < 62.57 then cbs1mean_hyper="0_NORM";
	else if   cbs1mean >=62.57 then cbs1mean_hyper="1_YES "; 
	     if .<dmr0mean <=43.205 then dmr0mean_hypo ="1_YES ";
	else if   dmr0mean > 43.205 then dmr0mean_hypo ="0_NORM";

***collect variables used in the analysis, age_ma_3(maternal age), BMI(bmiusual,bmi3_c)
		smoke(smoke_preg smoke_cur)	***;
          age_maternal = round((delidate_medabst - momdob_medabst)/365.25,.1);
	      if .<age_maternal  < 30 then age_ma_3 ="1__LT30";
	 else if 30<=age_maternal< 40 then age_ma_3 ="2_30_39";
	 else if 40<=age_maternal     then age_ma_3 ="3__GE40";
	 *else age_ma_3 = "00_MISS  "; 

	***define smoke status during pregnancy ***;
	         if smoke100cigs=1 and currentsmoke =1 and smokeyearpreg^=0 and smokebehaveafterpreg ^in (1,2,3) then smoke_preg="1_SMOKE";
		else if smoke100cigs=0 and currentsmoke^=1 then smoke_preg="9_NEVER";
		else if 0<smokestopage<99 or (smokeyearpreg=1 and smokebehaveafterpreg in (1,2,3)) then smoke_preg="2__QUIT";
		*else smoke_preg="00_MISS";
   if smoke_preg="" then do;
			 if finalsmk2 = 1 then 	smoke_preg="9_NEVER";
			 if finalsmk2 in (2,3) then do;
			         if smokebehaveafterpreg = 4 then smoke_preg="1_SMOKE";
					 else smoke_preg="2__QUITE";
					                   end;
                               end;
					if smoke_preg = "9_NEVER" then smoke_preg_d="9__NEVER"; 
					if smoke_preg in ("1_SMOKE","2__QUIT") then smoke_preg_d="1_ALLSMK";
		*** define current smokeing ***;
				if (smoke100cigs = 0 and currentsmoke = 994) or currentsmoke = 0 then smoke_cur = "0_NOT  ";
				else if  currentsmoke = 1 then smoke_cur = "1_YES  ";
				*else smoke_cur = "00_MISS";
	  
		  if .<ga_medabst<999            then age_gest_wk=round(ga_medabst/7);
	 else if weeksatdelivery_ques ^= 995 then age_gest_wk=weeksatdelivery_ques;

	      if  . <  age_gest_wk < 37 then age_gest_36 = "1_LE36wk";
	 else if 37 <= age_gest_wk < 45 then age_gest_36 = "2_GT36wk";
	 *else age_gest_36 = "00_MISS    "; 

   		  if    . <  babywght_birth < 2500  then birth_wt_2500 = "1_LT2500";
	 else if 2500 <= babywght_birth < 10000 then birth_wt_2500 = "2_GE2500";
	 *else birth_wt_2500 = "00_MISS    ";

                  if babygen_medabst = 1 then baby_sex= "1_MALE  ";
             else if babygen_medabst = 2 then baby_sex= "2_FEMALE";

       	 if education = 1 then edu_5 = "1_LTHS";
	 else if education = 2 then edu_5 = "2_HS  ";
     else if education = 3 then edu_5 = "3<COLL";
	 else if education = 4 then edu_5 = "4_COLL";
	 else if education = 5 then edu_5 = "5_GRAD";
          if education in (1,2) then edu_3 = "1_UPTOHS";
     else if education = 3      then edu_3 = "3_LTCOLL";
	 else if education in (4,5) then edu_3 = "5_GECOLL";
	 *else edu_3 = "00_MISS  ";

	      if hispanic = 1 then race_5 = "4_HISP ";
	 else if race = 1 then race_5 = "1_AA  ";
     else if race = 2 then race_5 = "7_CAU ";
	 else if race = 3 then race_5 = "3_AIS ";
	 else if race in (4,5) then race_5 = "5_OTH ";
	*else race_5 = "00_MISS  ";

	      if race_5 ^in ("1_AA   ","7_CAU ") then race_3 = "9_OHTERS";
	    else race_3=race_5;
		
			 if . <bmiusual	<30 then bmi3_c = "1___<30";
		else if 30<=bmiusual<35 then bmi3_c = "2_30_35"; 
		else if 35<=bmiusual    then bmi3_c = "3__>=35";
	 *else bmi3_c = "00_MISS  ";
		
			 if  . <bmiusual<25 then bmi4_c = "1___<25";
		else if 25<=bmiusual<30 then bmi4_c = "2_25_29"; 
		else if 30<=bmiusual<35 then bmi4_c = "3_30_35"; 
		else if 35<=bmiusual    then bmi4_c = "4__>=35";	

		  if 0<= apgarscore < 9 then apgar_c = "1_0_8  ";	
	 else if 9<= apgarscore <11 then apgar_c = "2_9_10 ";	
	 *else                            apgar_c = "00_MISS";
	  if matstatus = 1      then marital = "1_SINGLE   ";
	  else if matstatus in (2,4) then marital = "2_NOTSINGLE"; 
	  else if matstatus in (3,5) then marital = "3_DIV_WIDOW";

/*** the followings are not use any more ***;
		  

             if . <bmiusual	<30 then bmi2_c = "1___<30";
		else if 30<=bmiusual    then bmi2_c = "2__>=30";
	 *else bmi2_c = "00_MISS  ";
	  
          if 0<= apgarscore < 5 then apgar_c = "1_0_4  ";
	 else if 5<= apgarscore < 9 then apgar_c = "2_5_8  ";	
	 else if 9<= apgarscore <10 then apgar_c = "3_9    ";	
	 else if 10<= apgarscore<11 then apgar_c = "4_10   ";	
	 *else                            apgar_c = "00_MISS";     
   

			 if artcurrentbaby = 1 and artuse=1 then art_curr = "1_YES";
			 else art_curr = "0_NO "; */
			if nestid in (137) then smoke_cur = "1_YES   "; 
			if nestid in (332) then smoke_cur = "0_NOT   ";
			if smoke_cur = "0_NOT" then smoke_cur="9_NOT";
			if nestid in (277, 514,460) then delete;  ***due to miscoding ***;
         if inmed and inm and cbs1_cg1> . then output in.all;
	run;
/*
PROC IMPORT OUT= WORK.r21
       DATAFILE= "P:\Frances_Joellen_prostatestudy\Cathrine_HOYO\igf2\data_sas\igf2dmrnestr21.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="fran_passed$"; 
     GETNAMES=YES;
     MIXED=YES;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

PROC IMPORT OUT= WORK.H19 
            DATAFILE= "P:\Frances_Joellen_prostatestudy\Cathrine_HOYO\IGF2\data_sas\h19dmrnestr21.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="Fran_passed$"; 
     GETNAMES=YES;
     MIXED=YES;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
data h19_a; set h19;
  if substr(nest_id,4,1) in ("-","A","B") then nestid=1*substr(nest_id,1,3);
  else  nestid = 1*substr(nest_id,1,4);
  if nestid>.;
run;
proc freq data=h19_a; tables nestid;run; 
proc sql;
  create table h19_m as
  select distinct(nestid),well,plate
  from h19_a;

data r21_a; set r21;
  if substr(nest_id,4,1) in ("-","A","B") then nestid=1*substr(nest_id,1,3);
  else  nestid =1*substr(nest_id,1,4);
run;

proc freq data=r21_a; tables nestid;run;

proc sql;
  create table r21_m as
  select distinct(nestid),well,plate
  from r21_a;

data chk_in19 chk_in21 missing19 missing21;
   merge in.all(in=inall) h19_m(in=in19) r21_m(in=in21);
    by nestid;
	if inall and ^in19 then output missing19;
	if inall and ^in21 then output missing21; 
	if inall and in19 then output chk_in19;	
	if inall and in21 then output chk_in21;
run;

proc freq data=chk_in19;tables well plate;title2 "in both smk and h19";
proc freq data=chk_in21;tables well plate;title2 "in both smk and r21";
run;
*/
proc freq data=in.all; where(cbs1_cg1>.); 
  tables smoke_cur*(cbs1mean_hyper dmr0mean_hypo);
run;
/*
data for_ed(keep=nestid cbs1_cg1-cbs1_cg4 cbs1mean cbs1mean_hyper dmr0_cg1-dmr0_cg3 dmr0mean dmr0mean_hypo
          smoke_cur age_ma_3 race_5 race_3  edu_3 marital bmi4_c bmi2_c age_gest_36 birth_wt_2500 baby_sex apgar_c art_curr        )
     for_ed_incl_raw_variable
            (keep=nestid cbs1_cg1-cbs1_cg4 cbs1mean cbs1mean_hyper dmr0_cg1-dmr0_cg3 dmr0mean dmr0mean_hypo
          smoke_cur smoke_preg smoke100cigs currentsmoke smokeyearpreg smokebehaveafterpreg finalsmk2 smokebehaveafterpreg 
          age_ma_3 age_maternal race_5 race_3 hispanic race edu_3 education marital matstatus 
          bmi4_c bmi2_c  bmiusual age_gest_36 ga_medabst weeksatdelivery_ques birth_wt_2500 babywght_birth apgar_c apgarscore
          baby_sex babygen_medabst art_curr artcurrentbaby artuse);
retain nestid cbs1_cg1-cbs1_cg4 cbs1mean cbs1mean_hyper dmr0_cg1-dmr0_cg3 dmr0mean dmr0mean_hypo
          smoke_cur smoke_preg smoke100cigs currentsmoke smokeyearpreg smokebehaveafterpreg finalsmk2 smokebehaveafterpreg 
          age_ma_3 age_maternal race_5 race_3 hispanic race edu_3 education marital matstatus 
          bmi4_c bmi2_c bmiusual age_gest_36 ga_medabst weeksatdelivery_ques birth_wt_2500 babywght_birth apgar_c apgarscore
          baby_sex babygen_medabst art_curr artcurrentbaby artuse  ;
  set in.all;
         ;
run;
PROC EXPORT DATA= WORK.for_ed 
            OUTFILE= "p:\frances_joellen_prostatestudy\Cathrine_HOYO\july_2010_smkpaper\data_for_ED.txt" 
            DBMS=TAB REPLACE;
RUN; 
PROC EXPORT DATA= WORK.for_ed_incl_raw_variable 
            OUTFILE= "p:\frances_joellen_prostatestudy\Cathrine_HOYO\july_2010_smkpaper\data_for_ED_incl_raw_variable.txt" 
            DBMS=TAB REPLACE;
RUN; */
***check smoking definition ***;
/*proc freq data=in.all; where(cbs1_cg1>.); 
  tables smoke_cur*smoke_preg*smoke100cigs*currentsmoke*smokeyearpreg*smokebehaveafterpreg*finalsmk2/list missing;
  tables smoke_preg*finalsmk2;
  run;*/
** table 1 ask cathrine about current smoking definition***;
*tables smoke_cur*finalsmk2*smoke100cigs*currentsmoke/list;
proc freq data=in.all;
  tables smoke_preg*(age_ma_3 race_5 edu_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex apgar_c)/nopercent nocol;
  tables smoke_preg_d*(age_ma_3 race_5 edu_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex apgar_c)/nopercent nocol;
  run; 
 
%MACRO ff(VAR);
PROC freq DATA=in.all;where(&var ^="00_MISS");
  tables smoke_cur*&VAR/chisq nocol;
  RUN;
%MEND;
%ff(age_ma_3);
%ff(edu_3);	
%ff(race_5);
%ff(race_3);
%ff(marital);
%ff(bmi4_c); 
%ff(bmi2_c);
%ff(age_gest_36);
%ff(birth_wt_2500);
%ff(baby_sex);
%ff(apgar_c); 
%ff(art_curr); 
%ff(cbs1mean_hyper);
%ff(dmr0mean_hypo);
proc means data=in.all; var age_maternal;run;
proc freq data=all;tables finalsmk2*smoke100cigs*currentsmoke/list;run;
/*** table 2 ***;
proc means data=in.all fw=5; class smoke_preg;
  var cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4 cbs1mean
      dmr0_cg1 dmr0_cg2 dmr0_cg3 dmr0mean;
		 run;  
proc means data=in.all fw=5; 
  var cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4 cbs1mean
      dmr0_cg1 dmr0_cg2 dmr0_cg3 dmr0mean;
		 run; 
proc ttest data=all; class smoke_cur;
  var cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4 cbs1mean
      dmr0_cg1 dmr0_cg2 dmr0_cg3 dmr0mean;
		 run;		  
***wilcoxon rank sum test is for location shifts 
median scores test is powerful for distributions that are symmetric and heavy tailed***;
proc means data=all mean std median min max fw=5; 
  class art_curr;
  var cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4 cbs1mean
      dmr0_cg1 dmr0_cg2 dmr0_cg3 dmr0mean;
		 run;
PROC NPAR1WAY data=all wilcoxon median anova;
Class art_curr;	
  var cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4 cbs1mean
      dmr0_cg1 dmr0_cg2 dmr0_cg3 dmr0mean;
Run;  

proc glm data=all;
  class smoke_preg;
  model cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4	cbs1mean=smoke_preg/solution;
run;
proc glm data=all;
  class smoke_preg;
    model dmr0_cg1 dmr0_cg2 dmr0_cg3 dmr0mean=smoke_preg/solution;
run;  
data x; set in.all; if dmr0mean>.;
proc logistic data=in.all;where(dmr0mean>.);
  class smoke_cur;
    model birth_wt_2500=smoke_cur;
run; 
proc logistic data=in.all;
  class smoke_cur;
    model birth_wt_2500=smoke_cur;
run;
proc univariate data=in.all plot; var dmr0mean cbs1mean;	run;
proc corr data=in.all alpha;
  var  dmr0_cg1 dmr0_cg2 dmr0_cg3;
proc corr data=in.all alpha vardef=df out=data1;
  var  cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4;run;
  proc factor data=in.all method=ml priors=smc rotate=varimax reorder; 
  var  dmr0_cg1 dmr0_cg2 dmr0_cg3;
  run;
  proc factor data=in.all method=ml priors=smc; 	
  var  cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4;run;	
  data x; set in.all;  if dmr0mean>.;
  proc factor data=x method=ml rotate=varimax ; 
  var  dmr0_cg1 dmr0_cg2 dmr0_cg3;
  run;
  proc factor data=in.all method=ml priors=smc; 	
  var  cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4;run;
    /*** one factor, no need for this**;
proc calis data=in.all cov stderr all kurtosis modification residual;
lineqs
cbs1_cg1 =lcbs1_cg1F1+e1;
cbs1_cg2 =lcbs1_cg2F1+e2;
cbs1_cg3 =lcbs1_cg3F1+e3;
cbs1_cg4 =lcbs1_cg4F1+e4;
std e1-e4=ve1-ve4, F1=1; 
  var  cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4;
run; **/
*** table 2, 3***;
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
data miss; set in.all;
  if smoke_preg ="" or age_ma_3="" or edu_3="" or race_3="" or   
       bmi4_c="" or  age_gest_36="" or  birth_wt_2500="" or  baby_sex="" ;
  run;
proc print data=miss;
  var nestid smoke_preg age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex;
  title2 "at one missing values in variables used in the MV";
  run; 
proc print data=miss;where(dmr0_cg1> .);
  var nestid smoke_preg age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex;
  title2 "at one missing values in variables used in the MV";
  run;

proc datasets;
  delete stat;
  run;
%let i  = 0;

%gg(in.all,cbs1_cg1,pred0=smoke_preg,pred1=,pred2=);  	
%gg(in.all,cbs1_cg2,pred0=smoke_preg,pred1=,pred2=);  	
%gg(in.all,cbs1_cg3,pred0=smoke_preg,pred1=,pred2=);  	
%gg(in.all,cbs1_cg4,pred0=smoke_preg,pred1=,pred2=);  	
%gg(in.all,cbs1mean,pred0=smoke_preg,pred1=,pred2=);  	

%gg(in.all,dmr0_cg1,pred0=smoke_preg,pred1=,pred2=);  	
%gg(in.all,dmr0_cg2,pred0=smoke_preg,pred1=,pred2=);  	
%gg(in.all,dmr0_cg3,pred0=smoke_preg,pred1=,pred2=);  	
%gg(in.all,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  	

proc print data=stat;
title2 "unajusted for table 2"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(in.all,cbs1_cg1,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(in.all,cbs1_cg2,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(in.all,cbs1_cg3,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(in.all,cbs1_cg4,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(in.all,cbs1mean,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(in.all,dmr0_cg1,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(in.all,dmr0_cg2,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(in.all,dmr0_cg3,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(in.all,dmr0mean,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "ajusted for table 3"; run;
*** double check controlled variables ***;


data a_female a_male a_ge40 a_lt40 a_bwt_lt2500 a_bwt_GE2500;
  set in.all; if dmr0mean>.;
  if baby_sex= "1_MALE  "   then output a_male; 
  if baby_sex= "2_FEMALE"   then output a_female;
  if 40<=age_maternal       then output a_ge40;
  if 0<  age_maternal <40   then output a_lt40;
  if birth_wt_2500 = "1_LT2500" then output a_bwt_lt2500;	
  if birth_wt_2500 = "2_GE2500" then output a_bwt_ge2500;
run;


proc datasets;
  delete stat;
  run;
%let i  = 0; 
%gg(a_lt40,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  
%gg(a_ge40,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  
%gg(a_bwt_lt2500,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  
%gg(a_bwt_Ge2500,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  
%gg(a_male,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  
%gg(a_female,dmr0mean,pred0=smoke_preg,pred1= ,pred2=);  
 

data a_female a_male a_ge40 a_lt40 a_bwt_lt2500 a_bwt_GE2500;
  set in.all; if cbs1mean>.;
  if baby_sex= "1_MALE  "   then output a_male; 
  if baby_sex= "2_FEMALE"   then output a_female;
  if 40<=age_maternal       then output a_ge40;
  if 0<  age_maternal <40   then output a_lt40;
  if birth_wt_2500 = "1_LT2500" then output a_bwt_lt2500;	
  if birth_wt_2500 = "2_GE2500" then output a_bwt_ge2500;
run;
proc datasets;
  delete stat;
  run;
%let i  = 0; 
%gg(a_male,cbs1mean,pred0=smoke_preg,pred1=,pred2=);  
%gg(a_female,cbs1mean,pred0=smoke_preg,pred1= ,pred2=);  

proc print data=stat;
title2 "stratified, unajusted for table 3a"; run;

data all_excl_ex a_male_ex a_female_ex a_ge40_ex a_lt40_ex a_bwt_lt2500_ex a_bwt_ge2500_ex;
  set in.all;
    if dmr0_cg1>72 or dmr0_cg2>72 or dmr0_cg3>72 then delete;
	output all_excl_ex;
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

%gg(all_excl_ex,dmr0_cg1,pred0=smoke_preg,pred1=,pred2=);  	
%gg(all_excl_ex,dmr0_cg2,pred0=smoke_preg,pred1=,pred2=);  	
%gg(all_excl_ex,dmr0_cg3,pred0=smoke_preg,pred1=,pred2=);  	
%gg(all_excl_ex,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  

%gg(a_lt40_ex      ,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  
%gg(a_ge40_ex      ,dmr0mean,pred0=smoke_preg,pred1=,pred2=);   
%gg(a_bwt_lt2500_ex,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  
%gg(a_bwt_ge2500_ex,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  
%gg(a_male_ex      ,dmr0mean,pred0=smoke_preg,pred1=,pred2=);   
%gg(a_female_ex    ,dmr0mean,pred0=smoke_preg,pred1=,pred2=);  
option ls = 160;
proc print data=stat;
title2 "sensitivty analysis for table 2 and 3";
run;
proc means data=all_excl_ex;class smoke_preg;
  var dmr0_cg1-dmr0_cg3 dmr0mean;run;

%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=,pred2=);  	
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=age_ma_3,pred2=);  	
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=edu_3,pred2=);  	
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=race_3,pred2=);  	
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=marital,pred2=);  	
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=bmi2_c,pred2=);  	
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=bmi4_c,pred2=);  	
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=age_gest_36,pred2=);  
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=birth_wt_2500,pred2=);  
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=baby_sex,pred2=);  	
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all,cbs1_cg1,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: cbs1_cg1"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=,pred2=);  	
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=age_ma_3,pred2=);  	
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=edu_3,pred2=);  	
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=race_3,pred2=);  	
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=marital,pred2=);  	
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=bmi4_c,pred2=);  	
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=bmi2_c,pred2=);  	
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=age_gest_36,pred2=);  
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=birth_wt_2500,pred2=);  
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=baby_sex,pred2=);  	
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all,cbs1_cg2,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: cbs1_cg2"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=,pred2=);  
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=age_ma_3,pred2=);  	
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=edu_3,pred2=);  	
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=race_3,pred2=);  	
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=marital,pred2=);  	
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=bmi4_c,pred2=);  	
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=bmi2_c,pred2=);  	
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=age_gest_36,pred2=);  
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=birth_wt_2500,pred2=);  
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=baby_sex,pred2=);  	
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all,cbs1_cg3,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: cbs1_cg3"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=,pred2=);  
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=age_ma_3,pred2=);  	
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=edu_3,pred2=);  	
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=race_3,pred2=);  	
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=marital,pred2=);  	
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=bmi4_c,pred2=);  	
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=bmi2_c,pred2=);  	
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=age_gest_36,pred2=);  
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=birth_wt_2500,pred2=);  
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=baby_sex,pred2=);  	
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all,cbs1_cg4,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: cbs1_cg4"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(all,cbs1mean,pred0=smoke_preg,pred1=,pred2=);
%gg(all,cbs1mean,pred0=smoke_preg,pred1=age_ma_3,pred2=);  	
%gg(all,cbs1mean,pred0=smoke_preg,pred1=edu_3,pred2=);  	
%gg(all,cbs1mean,pred0=smoke_preg,pred1=race_3,pred2=);  	
%gg(all,cbs1mean,pred0=smoke_preg,pred1=marital,pred2=);  	
%gg(all,cbs1mean,pred0=smoke_preg,pred1=bmi4_c,pred2=);   	
%gg(all,cbs1mean,pred0=smoke_preg,pred1=bmi2_c,pred2=);  	
%gg(all,cbs1mean,pred0=smoke_preg,pred1=age_gest_36,pred2=);  
%gg(all,cbs1mean,pred0=smoke_preg,pred1=birth_wt_2500,pred2=);  
%gg(all,cbs1mean,pred0=smoke_preg,pred1=baby_sex,pred2=);  	
%gg(all,cbs1mean,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all,cbs1mean,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: cbs1mean"; run;
*** mixed model used ***;
data rev_fran;
  set in.all(keep=nestid cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4 dmr0_cg1 dmr0_cg2 dmr0_cg3
          age_maternal edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex
          smoke_preg smoke_cur babywght_birth);
 run;

proc corr data=rev_fran;
  var cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4 dmr0_cg1 dmr0_cg2 dmr0_cg3 ;
run;
data rev_fran_cbs rev_fran_dmr;;
  set rev_fran;
    array cc cbs1_cg1 cbs1_cg2 cbs1_cg3 cbs1_cg4;
	  do over cc;
	    cbs1 = cc;
		  if cbs1>. then output rev_fran_cbs;
		  end; 
    array dd dmr0_cg1 dmr0_cg2 dmr0_cg3 ;
	  do over dd;
	    dmr0 = dd;
		  if dmr0>. then output rev_fran_dmr;
		  end;
run;

proc mixed data=rev_fran_cbs covtest ratio;	
  class smoke_preg nestid;
   model cbs1 = smoke_preg /solution;
   lsmeans smoke_preg/diff;
   random intercept /sub=nestid type=vc;
   title2 "comparing mean H19_cg among smoke during pregnancy";
run;  
proc mixed data=rev_fran_cbs covtest ratio;	
  class smoke_cur nestid;
   model cbs1 = smoke_cur /solution;
   lsmeans smoke_cur/diff;
   random intercept /sub=nestid type=vc;
   title2 "comparing mean H19_cg1 among smoke during pregnancy";
run; 

proc mixed data=rev_fran_dmr covtest ratio;	
  class smoke_preg nestid;
   model dmr0 = smoke_preg /solution;
   lsmeans smoke_preg/diff;
   random intercept /sub=nestid type=vc;
   title2 "comparing mean H19_cg1 among smoke during pregnancy";
run;  
proc mixed data=rev_fran_dmr covtest ratio;	
  class smoke_cur nestid;
   model dmr0 = smoke_cur /solution;
   lsmeans smoke_cur/diff;
   random intercept /sub=nestid type=vc;
   title2 "comparing mean H19_cg1 among smoke during pregnancy";
run; 
%macro mm(wh1,wh2,wh3,pred1=,pred2=);
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
%mend; 	
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
	run; 
proc univariate data=all_excl_extreme plot;
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
title2 "outcome: cbs1*, exclude 11 pts"; run;


proc univariate data=in.all plot;
     var dmr0_cg1 dmr0_cg2 dmr0_cg3  dmr0mean;
	 run;

data all_excl_ex;
  set in.all;
    if dmr0_cg1>72 or dmr0_cg2>72 or dmr0_cg3>72 then delete;
	*    if dmr0_cg1>70 or dmr0_cg2>70 or dmr0_cg3>70 then delete;
	run; 
proc univariate data=all_excl_ex plot;
     var dmr0_cg1 dmr0_cg2 dmr0_cg3  dmr0mean;
	 run;
proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(all_excl_ex,dmr0_cg1,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,dmr0_cg2,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,dmr0_cg3,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,dmr0mean,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all_excl_ex,dmr0_cg1,pred0=smoke_cur,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,dmr0_cg2,pred0=smoke_cur,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,dmr0_cg3,pred0=smoke_cur,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,dmr0mean,pred0=smoke_cur,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

%gg(all_excl_ex,dmr0_cg1,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,dmr0_cg2,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,dmr0_cg3,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all_excl_ex,dmr0mean,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: dmr0*, exclude 5 pts"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=,pred2=);  
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=age_ma_3,pred2=);  	
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=edu_3,pred2=);  	
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=race_3,pred2=);  	
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=marital,pred2=);  	
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=bmi4_c,pred2=);  	
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=bmi2_c,pred2=);  	
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=age_gest_36,pred2=);  
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=birth_wt_2500,pred2=);  
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=baby_sex,pred2=);  	
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all,dmr0_cg1,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: dmr0_cg1"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=,pred2=);  
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=age_ma_3,pred2=);  	
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=edu_3,pred2=);  	
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=race_3,pred2=);  	
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=marital,pred2=);  	
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=bmi4_c,pred2=);  	
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=bmi2_c,pred2=);  	
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=age_gest_36,pred2=);  
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=birth_wt_2500,pred2=);  
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=baby_sex,pred2=);  	
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all,dmr0_cg2,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: dmr0_cg2"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=,pred2=);  	
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=age_ma_3,pred2=);  	
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=edu_3,pred2=);  	
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=race_3,pred2=);  	
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=marital,pred2=);  	
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=bmi4_c,pred2=);  	
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=bmi2_c,pred2=);  	
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=age_gest_36,pred2=);  
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=birth_wt_2500,pred2=);  
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=baby_sex,pred2=);  	
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  
%gg(all,dmr0_cg3,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: dmr0_cg3"; run;

proc datasets;
  delete stat;
  run;
%let i  = 0;
%gg(all,dmr0mean,pred0=smoke_preg,pred1=,pred2=); 
%gg(all,dmr0mean,pred0=smoke_preg,pred1=age_ma_3,pred2=);  	
%gg(all,dmr0mean,pred0=smoke_preg,pred1=edu_3,pred2=);  	
%gg(all,dmr0mean,pred0=smoke_preg,pred1=race_3,pred2=);  	
%gg(all,dmr0mean,pred0=smoke_preg,pred1=marital,pred2=);  	
%gg(all,dmr0mean,pred0=smoke_preg,pred1=bmi4_c,pred2=);  	
%gg(all,dmr0mean,pred0=smoke_preg,pred1=bmi2_c,pred2=);  	
%gg(all,dmr0mean,pred0=smoke_preg,pred1=age_gest_36,pred2=);  
%gg(all,dmr0mean,pred0=smoke_preg,pred1=birth_wt_2500,pred2=);  
%gg(all,dmr0mean,pred0=smoke_preg,pred1=baby_sex,pred2=);  	
%gg(all,dmr0mean,pred0=smoke_preg,pred1=birth_wt_2500 baby_sex,pred2=);  	
%gg(all,dmr0mean,pred0=smoke_preg,pred1=age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  

proc print data=stat;
title2 "outcome: dmr0mean"; run; 

*** couldn't see any difference between offspring gender, maternal age and gestational age and birthwt ***;
proc freq data=all;
  tables age_gest_36 *birth_wt_2500;run;
 
data a_female a_male a_ge40 a_lt40 a_LE36 a_gt36 a_bmilt30 a_bmige30 a_bwt_lt2500 a_bwt_GE2500;
  set in.all;
  if baby_sex= "1_MALE  "   then output a_male; 
  if baby_sex= "2_FEMALE  " then output a_female;
  if 40<=age_maternal       then output a_ge40;
  if 0<  age_maternal <40   then output a_lt40;
  if age_gest_36 = "1_LE36wk" then output a_le36;
  if age_gest_36 = "2_GT36wk" then output a_gt36;
  if bmi2_c = "1___<30"       then output a_bmilt30;
  if bmi2_c = "2__>=30"       then output a_bmiGE30; 
  if birth_wt_2500 = "1_LT2500" then output a_bwt_lt2500;	
  if birth_wt_2500 = "2_GE2500" then output a_bwt_ge2500;
run;

proc freq data=a_male; tables race_3;run;
proc univariate data=a_male plot;where(race_3="1_AA");
  var dmr0_cg1 dmr0_cg2 dmr0_cg3 dmr0mean;run;

data a_male_s; set a_male;
   if race_3="1_AA" then do;
      if .<dmr0_cg1 < 20 or dmr0_cg1 > 70 
         or .<dmr0_cg2 < 33 or dmr0_cg2 > 70 	
         or .<dmr0_cg3 < 30 or dmr0_cg3 > 70 
         or .<dmr0mean < 36 or dmr0mean > 60  then output;
		 end;
run;
proc print data=chk;var nestid;run;
proc print data=a_male_s ;
  var nestid smoke_cur dmr0_cg1 dmr0_cg2 dmr0_cg3 dmr0mean race_3;
run;
proc genmod data=a_male ; 
  class smoke_cur;
  model dmr0mean=smoke_cur /d=n type3 ;
  output out =x RESDEV=r;
run;
data x1;set x(keep=nestid r); if r > 20;run;
proc print data=x1;run;
proc univariate data=x1 plot;var r;run;
proc print data=x; var r;run;

data all_a; set all ;if baby_sex^="00_MISS";run;
proc genmod data=all_a;
  class smoke_cur baby_sex;
  model dmr0_cg3=smoke_cur baby_sex smoke_cur*baby_sex/d=n type3 ;
  lsmeans baby_sex/pdiff; 
  lsmeans smoke_cur/pdiff;
run;

data a_male_s; set a_male; 
  *if nestid ^in (622,635);
   if nestid ^in (349 380 494 622,635 641);
run;
proc datasets;
  delete stat;
  run;
%let i  = 0;

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
run;
 

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
%gg(a_male  ,dmr0mean,pred0=smoke_cur,pred1=,pred2=); 


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
%gg(a_lt40,dmr0mean,pred0=smoke_cur,pred1=,pred2=); 
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
*/
%gg(a_bmilt30,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmilt30,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmilt30,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmilt30,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmilt30,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmilt30,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmilt30,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmilt30,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmilt30,dmr0mean,pred0=smoke_cur,pred1=,pred2=); 

%gg(a_bmige30,cbs1_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmige30,cbs1_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmige30,cbs1_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmige30,cbs1_cg4,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmige30,cbs1mean,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmige30,dmr0_cg1,pred0=smoke_cur,pred1=,pred2=); 	
%gg(a_bmige30,dmr0_cg2,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmige30,dmr0_cg3,pred0=smoke_cur,pred1=,pred2=); 
%gg(a_bmige30,dmr0mean,pred0=smoke_cur,pred1=,pred2=); 

/*
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
*/
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
%gg(a_bwt_GE2500,dmr0mean,pred0=smoke_cur,pred1=,pred2=); 

proc print data=stat;
title2 "stratified analysis"; run; 

proc datasets;
  delete stat;
  run;
%let i  = 0;

%gg((in.all,cbs1_cg1,pred0=art_curr,pred1=          age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 birth_wt_2500 baby_sex,pred2=);  
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

 
data all_mediator all_mediator_f all_mediator_m
    dmr0_mediator dmr0_mediator_f dmr0_mediator_m
    cbs1_mediator cbs1_mediator_f cbs1_mediator_m;
  set in.all;
         if    . <  babywght_birth < 2500  then birth_wt = 1;
	else if 2500 <= babywght_birth < 10000 then birth_wt = 0;
	     if .<cbs1mean < 62.57 then cbs1_hyper=0;
	else if   cbs1mean >=62.57 then cbs1_hyper=1; 
	     if .<dmr0mean <= 43.205 then dmr0_hypo =1;
	else if   dmr0mean > 43.205  then dmr0_hypo =0;
	     if  smoke_cur = "9_NOT  " then smoke_c_n=0;
	else if  smoke_cur = "1_YES  " then smoke_c_n=1;
	 output all_mediator;
	 if baby_sex="1_MALE" then output all_mediator_m; 
	 if baby_sex="2_FEMALE" then output all_mediator_f;
	 if dmr0mean>. then do;
	 output dmr0_mediator;
	 if baby_sex="1_MALE" then output dmr0_mediator_m; 
	 if baby_sex="2_FEMALE" then output dmr0_mediator_f;
	   end;	   
	 if cbs1mean>. then do;
	 output cbs1_mediator;
	 if baby_sex="1_MALE" then output cbs1_mediator_m; 
	 if baby_sex="2_FEMALE" then output cbs1_mediator_f;
	   end;
run;

%mediation(data= all_mediator, X=smoke_c_n, M=cbs1mean  , Y=birth_wt );	
%mediation(data= all_mediator, X=smoke_c_n, M=cbs1_hyper, Y=birth_wt );	
%mediation(data= all_mediator, X=smoke_c_n, M=dmr0mean  , Y=birth_wt ); 
%mediation(data= all_mediator, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );

%mediation(data= dmr0_mediator, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );

%mediation(data= all_mediator_m, X=smoke_c_n, M=cbs1_hyper, Y=birth_wt );	
%mediation(data= all_mediator_m, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );	

%mediation(data= all_mediator_f, X=smoke_c_n, M=cbs1_hyper, Y=birth_wt );	
%mediation(data= all_mediator_f, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );

%mediation(data= dmr0_mediator_m, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );	
%mediation(data= dmr0_mediator_f, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );


*** birth wt mediate dmr = smoke***;
%mediation(data= dmr0_mediator_m, X=smoke_c_n, M=birth_wt,Y=dmr0_hypo );	
%mediation(data= dmr0_mediator_f, X=smoke_c_n, M=birth_wt,Y=dmr0_hypo );	
%mediation(data= dmr0_mediator,   X=smoke_c_n, M=birth_wt,Y=dmr0_hypo );



proc freq data=all_mediator;
  tables smoke_cur*cbs1mean_hyper*birth_wt;
run;
proc freq data=all_mediator;
  tables smoke_cur*birth_wt/chisq;
run;
proc freq data=all_mediator;
  tables birth_wt*cbs1mean_hyper/chisq;
run;
proc freq data=all_mediator;
  tables smoke_cur*cbs1mean_hyper/chisq;
run;
proc freq data=all_mediator;
  tables smoke_cur*birth_wt/chisq;
run;
proc freq data=all_mediator;
  tables birth_wt*dmr0mean_hypo/chisq;
run;
proc freq data=all_mediator;
  tables smoke_cur*dmr0mean_hypo/chisq;
run;
proc freq data=all_mediator;
  tables dmr0mean_hypo*smoke_cur*birth_wt/all;
run;

proc freq data=all_mediator;tables dmr0_hypo*smoke_preg*birth_wt/missing list;run;

proc logistic data=cbs1_mediator descending;
  class smoke_preg;
  model birth_wt=smoke_preg;
  run;
  
proc logistic data=cbs1_mediator descending;
  class smoke_preg;
  model birth_wt=smoke_preg;
  run;
  
proc logistic data=dmr0_mediator descending;
  class smoke_preg(param=ref);
  model birth_wt=smoke_preg;
  run;
proc logistic data=dmr0_mediator descending;
  class smoke_preg(param=ref) dmr0mean_hypo;
  model birth_wt=smoke_preg  dmr0mean_hypo;
  run; 
  
%mediation(data= dmr0_mediator, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );

proc logistic data=dmr0_mediator_m descending;
  class smoke_preg(param=ref);
  model birth_wt=smoke_preg;
  run;
proc logistic data=dmr0_mediator_m descending;
  class smoke_preg(param=ref) dmr0mean_hypo;
  model birth_wt=smoke_preg  dmr0mean_hypo;
  run; 
  
%mediation(data= dmr0_mediator_m, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt ); 

proc logistic data=dmr0_mediator_f descending;
  class smoke_preg(param=ref);
  model birth_wt=smoke_preg;
  run;
proc logistic data=dmr0_mediator_f descending;
  class smoke_preg(param=ref) dmr0mean_hypo;
  model birth_wt=smoke_preg  dmr0mean_hypo;
  run; 
  
%mediation(data= dmr0_mediator_f, X=smoke_c_n, M=dmr0_hypo , Y=birth_wt );


proc logistic data=dmr0_mediator descending;
  class smoke_preg(param=ref) age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 baby_sex(param=ref);
  model birth_wt=smoke_preg  race_3 bmi4_c age_gest_36 ;
  run;
  
proc logistic data=dmr0_mediator descending;
  class smoke_preg(param=ref) dmr0mean_hypo(param=ref) age_ma_3(param=ref) edu_3(param=ref) race_3(param=ref) marital(param=ref) bmi4_c(param=ref) age_gest_36(param=ref) baby_sex(param=ref)  ;
  model birth_wt=smoke_preg dmr0mean_hypo age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 baby_sex;
  run; 
  
proc logistic data=dmr0_mediator descending;
  class smoke_preg(param=ref) dmr0mean_hypo(param=ref) age_ma_3(param=ref) edu_3(param=ref) race_3(param=ref) marital(param=ref) bmi4_c(param=ref) age_gest_36(param=ref) baby_sex(param=ref)  ;
  model birth_wt=smoke_preg dmr0mean_hypo age_ma_3  race_3 bmi4_c age_gest_36 baby_sex;
  run; 
proc logistic data=dmr0_mediator descending;
  class smoke_preg(param=ref) dmr0mean_hypo(param=ref) age_ma_3(param=ref) edu_3(param=ref) race_3(param=ref) marital(param=ref) bmi4_c(param=ref) age_gest_36(param=ref) baby_sex(param=ref)  ;
  model birth_wt=smoke_preg dmr0mean_hypo age_ma_3  race_3 bmi4_c age_gest_36 ;
  run; 
proc logistic data=dmr0_mediator descending;
  class smoke_preg(param=ref) dmr0mean_hypo(param=ref) age_ma_3(param=ref) edu_3(param=ref) race_3(param=ref) marital(param=ref) bmi4_c(param=ref) age_gest_36(param=ref) baby_sex(param=ref)  ;
  model birth_wt=smoke_preg dmr0mean_hypo   race_3 bmi4_c age_gest_36 ;
  run;

proc logistic data=dmr0_mediator_m descending;
  class smoke_preg(param=ref) dmr0mean_hypo(param=ref) age_ma_3(param=ref) edu_3(param=ref) race_3(param=ref) marital(param=ref) bmi4_c(param=ref) age_gest_36(param=ref) baby_sex(param=ref)  ;
  model birth_wt=smoke_preg age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 ;
  run;
  
proc logistic data=dmr0_mediator_m descending;
  class smoke_preg(param=ref) dmr0mean_hypo age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36   ;
  model birth_wt=smoke_preg dmr0mean_hypo age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 ;
  run;

proc logistic data=dmr0_mediator_f descending;
  class smoke_preg(param=ref) age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 (param=ref);
  model birth_wt=smoke_preg age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 ;
  run;
  
proc logistic data=dmr0_mediator_f descending;
  class smoke_preg(param=ref) dmr0mean_hypo age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36   ;
  model birth_wt=smoke_preg dmr0mean_hypo age_ma_3 edu_3 race_3 marital bmi4_c age_gest_36 ;
  run;
***stop here***; 
  
proc logistic data=all_mediator descending;where(cbs1mean>. and smoke_cur>"");
  class smoke_cur cbs1_hyper;
  model birth_wt=smoke_preg cbs1_hyper ;
  run;
proc logistic data=all_mediator descending;where(dmr0mean>. and smoke_cur>"");
  class smoke_cur dmr0_hypo;
  model birth_wt=smoke_preg dmr0_hypo;
  run;
