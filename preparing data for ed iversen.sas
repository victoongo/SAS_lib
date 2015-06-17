/*PRIOR TO RUNNING - RUN THE CODE FOR SUMMAYR VARIABELS IN NESTSR*/

/*PREPARING DATABASES FOR ED IVERSEN*/

LIBNAME nestsr 'P:\NICHES\';

data nestsr.nestsr_iversen; 
	set nestsr.nest_merge_tb_rc (keep =  
		es0: 
		nestid mom_nestID in_450K age_mo_sr_surv agemos baby_gender birthwt_kg gestAge_weeks GestAge_TotalDays education4 education_3CAT
		race_final mom_age_delv smoker_do_not_use maternal_smoking2 asrs_ADHD bmi_LMP_kgm2 medabs_parity parity_3cat
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
