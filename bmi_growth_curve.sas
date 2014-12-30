
data n1weight (rename=(wt_reference_date=ref_date weight_kg=weight source=wt_source));
	set "P:\NEST I\Vitals\nest_r01_all_weight_28nov14.sas7bdat" (keep=nestid mom_nestid final_child_dob wt_reference_date weight_kg sex source);
run;
data n2weight (rename=(wt_reference_date=ref_date weight_kg=weight source=wt_source));
	set "P:\NEST II\Vitals\nest_r21_all_weight_28nov14.sas7bdat" (keep=nestid mom_nestid final_child_dob wt_reference_date weight_kg sex source);
run;
data n1height (rename=(ht_reference_date=ref_date height_length_cm=height source=ht_source));
	set "P:\NEST I\Vitals\nest_r01_all_height_28nov14.sas7bdat" (keep=nestid mom_nestid final_child_dob ht_reference_date height_length_cm sex source);
run;
data n2height (rename=(ht_reference_date=ref_date height_length_cm=height source=ht_source));
	set "P:\NEST II\Vitals\nest_r21_all_height_28nov14.sas7bdat" (keep=nestid mom_nestid final_child_dob ht_reference_date height_length_cm sex source);
run;
data merged(keep=nestid mom_nestid weight height);
	set "P:\NEST I, II, and SR Harmonized Vars\nest_i_ii_sr_merge_27dec14.sas7bdat"
		(keep=nestid mom_nestid baby_weight LENGTH_BABY LENGTH_IN_OR_CM baby_gender rename=(baby_weight=weight length_baby=height baby_gender=sex));
	agemos=0;
	weight=weight/1000;
	if LENGTH_IN_OR_CM=1 then height=height/0.39370;
	wt_source="birth_weight";
	ht_source="birth_height";
	if weight~=. | height~=. then output;
run;
proc contents data=merged; run;
proc sort data=n1weight; by nestid mom_nestid ref_date; run;
proc sort data=n2weight; by nestid mom_nestid ref_date; run;
proc sort data=n1height; by nestid mom_nestid ref_date; run;
proc sort data=n2height; by nestid mom_nestid ref_date; run;
proc sort data=merged; by nestid mom_nestid; run;

data mydata (keep=nestid mom_nestid final_child_dob ref_date weight height sex ht_source wt_source agemos);
	merge n1weight n2weight n1height n2height;
	by nestid mom_nestid ref_date;
	agemos=(ref_date-final_child_dob)/30;
	if agemos~=0 then output;
run;
data mydata;
	set mydata merged;
run;
proc means data=mydata; var agemos; run;
libname refdir 'd:\dropbox\projects\sas_lib\';
%include 'd:\dropbox\projects\sas_lib\CDC-source-code.sas'; run;

data merged_var (keep=nestid mom_nestid BMI_LMP_kgm2 mat_gest_wt_gain_category2
					  gest_weight_gain_kg parity_3cat mom_age_delv race_final4 education4 GestAge_TotalDays smoker);
	set "P:\NEST I, II, and SR Harmonized Vars\nest_i_ii_sr_merge_27dec14.sas7bdat"
		(keep=nestid mom_nestid BMI_LMP_kgm2 mat_gest_wt_gain_category
			  gest_weight_gain_kg medabs_parity mom_age_delv race_final2 education GestAge_TotalDays smoker);
	if education = 1 then education4 = 1; /* 1=LT High School */
	else if education= 2 then education4 = 2; /*2 = High School or GED*/
	else if education =3 then education4 = 3; /*Some College  */
	else if education in(4,5 ) then education4=4; /*College Graduate */

	if race_final2 = 1 then race_final4 = 1; /* 1=White */
	else if race_final2= 2 then race_final4 = 2; /*2 = Hispanic*/
	else if race_final2 =3 then race_final4 = 3; /*Black */
	else if race_final2 in(4,5 ) then race_final4=4; /*Asian, NA and Other*/

	if medabs_parity = 0 then parity_3cat = 0; 
	else if medabs_parity = 1 then parity_3cat = 1; 
	else if medabs_parity in (2 3 4 5 6 7 8)  then parity_3cat = 2; 
	else if medabs_parity = 999 then parity_3cat=.; 
	else if medabs_parity = . then parity_3cat=. ; 

	mat_gest_wt_gain_category2=.;
	if mat_gest_wt_gain_category="Less than adequate" then mat_gest_wt_gain_category2=1;
	else if mat_gest_wt_gain_category="adequate" then mat_gest_wt_gain_category2=2;
	else if mat_gest_wt_gain_category="excessive" then mat_gest_wt_gain_category2=3;
run;
/*
One model would examine the relationship between pre-pregnancy BMI (BMI_LMP_kgm2 ) and weight controlling for the following: 
gest_weight_gain_kg  ib0.parity_3cat mom_age_delv ib1.race_final4 i.BABY_GENDER  i.education4 GestAge_TotalDays i.smoker 
The other would examine WHO gestational weight gain categories (mat_gest_wt_gain_category2) controlling for the following: 
ib0.parity_3cat mom_age_delv ib1.race_final4 i.BABY_GENDER  i.education4 GestAge_TotalDays i.smoker
*/
proc sort data=merged_var; by nestid mom_nestid; run;
proc sort data=_cdcdata; by nestid mom_nestid; run;
data _cdcdata; 
	merge _cdcdata  merged_var; 
	by nestid mom_nestid; 
run;
proc contents data=_cdcdata; run;
proc means data=_cdcdata; var agemos; run;
proc export data=_cdcdata outfile="D:\Projects\Box\Box Sync\Home Folder lw182\proj_data\bmi\bmi.csv" dbms=csv replace; run;

*proc hlm data=vital_all;
*run;

