/*PRIOR TO RUNNING - RUN THE CODE FOR SUMMAYR VARIABELS IN NESTSR*/

/*PREPARING DATABASES FOR ED IVERSEN*/

%include "D:\Dropbox\Projects\sas_lib\Code for Summary Variables for NESTSR analyses.sas";

data nestsr.NESTSR_iversen; 
	set nestsr (keep =  
		es0: 
		nestid mom_nestID in_450K age_mo_sr_surv agemos baby_gender birthwt_kg gestAge_weeks GestAge_TotalDays education4 education_3CAT
		race_final mom_age_delv smoker maternal_smoking2 asrs_ADHD bmi_LMP_kgm2 medabs_parity parity_3cat
		BMIz BMIPCT
		BRF_ISCI BRF_FI BRF_EMI BRF_GEC BRF_IN BRF_SF BRF_WM BRF_EC BRF_PO /*measures of BRIEF*/
		BASC_HY BASC_AG BASC_AX
		BASC_DP BASC_SM BASC_AT
		BASC_WD BASC_AP 
		BASC_AD BASC_SS BASC_DL
		BASC_FC
		BASC_EXT BASC_INT BASC_BSI BASC_ADA BASC_APHY
		SWAN_HI SWAN_IN SWAN_SUM 
		CEBQ_SRSE CEBQ_FR CEBQ_EOE CEBQ_EF CEBQ_SE CEBQ_SR /*CHILD EATING BEHAVIOR QUESTIONNAIRE */
		TFEQ_CR TFEQ_UE TFEQ_EE TFEQ_TOT ); /*MATERNAL EATING BEHAVIORS*/; 
	race_final_n=.;
	if race_final='Black' then race_final_n=3;
	if race_final='White' then race_final_n=1;
	if race_final='Hispanic' then race_final_n=2;
	if race_final='Other' then race_final_n=4;
	if age_mo_sr_surv<=72 and age_mo_sr_surv>=22 then output;
run; 
/*proc freq data=nestsr.nestsr_iversen; tables race_final4*race_final_n; run;*/
%let datenow=%sysfunc(date(), date9.);
%put &datenow.;
proc export data=nestsr.nestsr_iversen outfile="D:\Dropbox\Projects\epigenetics\data\nestsr_iversen.csv" dbms=csv replace;
run;


/*
data temperament_iversen; set nestsr ; 
file  'P:\Bernard Fuemmeler\NEST SR Executive Functions and BMI paper\Iversen.dat';
if INTERNAL >=. then put
nestid mom_nestID age_mo_sr_surv agemos baby_gender birthwt_kg gestAge_weeks GestAge_TotalDays education4 education_3CAT
race_final  mom_age_delv smoker asrs_ADHD bmi_LMP_kgm2 medabs_parity parity_3cat
BMIz BMIPCT
IMPULSIVITY AGGRESSION PEERAGGRESSION EXTERNAL DEPRESSION ANXIETY SEPERATION INHIBITION INTERNAL surgency negative_affect effort_control /*measures for 1 year temperament*/
; run; 
*/;


proc means data=nestsr; 
where age_mo_sr_surv<=66 ;
var  
age_mo_sr_surv agemos baby_gender birthwt_kg gestAge_weeks GestAge_TotalDays education4 education_3CAT
race_final  mom_age_delv smoker asrs_ADHD bmi_LMP_kgm2 medabs_parity parity_3cat
BMIz BMIPCT
BRF_ISCI BRF_FI BRF_EMI BRF_GEC BRF_IN BRF_SF BRF_WM BRF_EC BRF_PO /*measures of BRIEF*/
BASC_HY BASC_AG BASC_AX /*BASC*/
BASC_DP BASC_SM BASC_AT
BASC_WD BASC_AP 
BASC_AD BASC_SS BASC_DL
BASC_FC
SWAN_HI SWAN_IN SWAN_SUM 
BASC_EXT BASC_INT BASC_BSI BASC_ADA 
CEBQ_SRSE CEBQ_FR CEBQ_EOE CEBQ_EF CEBQ_SE  /*CHILD EATING BEHAVIOR QUESTIONNAIRE */
TFEQ_CR TFEQ_UE TFEQ_EE TFEQ_TOT ;/*MATERNAL EATING BEHAVIORS*/ run; 
