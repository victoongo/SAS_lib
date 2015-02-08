*==============================================================================================*
** PROGRAM: NEST I - Data Prep for Stack - Bernard 12-27-14.sas
** AUTHOR: Rachel Maguire
** DATE: 12/27/2014
** PURPOSE: Pull NEST I data for Bernard and prepare for stacking with NEST II data
	
** KEY INPUTS: NEST I Access Database, medical abstraction, age 1 survey, BLQ
** KEY OUTPUTS: 

MODIFICATION HISTORY                        
  Date        Name    		   Purpose/Modification
11/7/2013 		 	bernard workstation			modified to point to files on Bernard's workstation
11/20/2013			Rachel Maguire				add depression/stress variables
12/11/2013			Rachel Maguire				add updated Nest I medabs data
12/13/2013			Rachel Maguire				add questions on postnatal stress and depression
1/9/2014			Rachel Maguire				added updated UNC diet recall, age in months at SR survey & diet recall,
												and NEST I self reported vitamins from BLQ and vitamin blood levels from Craft
1/23/2014			Rachel Maguire				add additional UNC diet recall variables and metals data
6/28/2014			Rachel Maguire				add "mat_bothered" variable and additional vars from medabs
8/5/2014			Rachel Maguire				add marital status
9/7/14				Rachel Maguire				rerun with most recent vitals for child
11/23/14			Rachel Maguire				rerun with most recent vitals for child & add mom diet during preg vars
12/5/14				Rachel Maguire				add source of vitals variable
12/27/14			Rachel Maguire				add baby length variable
*=============================================================================================*;
libname blq "&home.\NEST I\Baseline Questionnaire";
libname medabs "&home.\NEST I\Chart Abstraction";
libname vitals "&home.\NEST I\Vitals";
libname cross "&home.\NEST I\Cross Dataset Calculations";
libname enroll "&home.\NEST I\Enrollment Table";
libname diet "&home.\NEST I\UNC Diet Recall";
libname age1 "&home.\NEST I\age 1 survey";
libname meth "&home.\NEST I\Methylation";
libname craft "&home.\NEST I\Craft Analysis";
libname metal "&home.\NEST I\Trace metals";
libname m_diet "&home.\NEST I\Maternal Diet During Preg Data\Stacked Maternal FFQ-BFFQ";
libname out "&home.\NEST I, II, and SR Harmonized Vars";

options nofmterr;run;


/********************************************************************************************/
/*																							*/
/*							Import and Prep Methylation Data								*/
/*																							*/
/********************************************************************************************/
/*import dmr data*/
/*PROC IMPORT OUT= WORK.dmr*/
/*            DATAFILE= "&home.\NEST I\Methylation\9DMRs_p1-14_all_clean.xlsx" */
/*            DBMS=EXCEL REPLACE;*/
/*     RANGE="Sheet1$"; */
/*     GETNAMES=YES;*/
/*     MIXED=YES;*/
/*     SCANTEXT=YES;*/
/*     USEDATE=YES;*/
/*     SCANTIME=YES;*/
/*RUN;*/

/*create vars in NestII but not in NestI*/
data dmr; 
set meth.Nest_i_dmr_clean; 
plate_num_cbs1 = .;				num_plates_used_for_ID_cbs1 = .;
plate_num_dmr0 = .;				num_plates_used_for_ID_dmr0 = .;
plate_num_meg3_cbs1 = .;		num_plates_used_for_ID_meg3_cbs1 = .;
plate_num_meg3_ig = .;			num_plates_used_for_ID_meg3_ig = .;
plate_num_mestit1 = .;			num_plates_used_for_ID_mestit1 = .;
plate_num_nnat1 = .;			num_plates_used_for_ID_nnat1 = .;
plate_num_peg3 = .;				num_plates_used_for_ID_peg3 = .;
plate_num_plagl1 = .;			num_plates_used_for_ID_plagl1 = .;
plate_num_sgce = .;				num_plates_used_for_ID_sgce = .;
run;


/********************************************************************************************/
/*																							*/
/*								Prepare SR Survey Dates										*/
/*																							*/
/********************************************************************************************/
data Nest_SR_data;
set nest_SR.Nest_sr_survdate_01082014;

/*corrections to survey dates*/
if NEST_ID = 1343 and SURVEY_DATE = "02jan2014"d then survey_date = "02jan2013"d;
if NEST_ID = 1777 and SURVEY_DATE = "04dec2013"d then survey_date = "12apr2013"d;
if NEST_ID = 1049 and SURVEY_DATE = "02dec2013"d then survey_date = "02dec2012"d;
if NEST_ID in (1384, 1523, 1601, 1655) and SURVEY_DATE = "02dec2013"d then survey_date = "12feb2013"d;

if nest_id = 1031 then do;
	nest_id = 10311;
	DELIVERY_DATE = "11mar2010"d;
	end;
if nest_id = 682 then do;
	nest_id = 6821;
	DELIVERY_DATE = "06aug2008"d;
	end;
if nest_id = 2392 then delivery_date = "22JUN2011"d;
if nest_id = 2661 then delivery_date = "17NOV2011"d;
if nest_id = 2662 then delivery_date = "22OCT2011"d;

/*fill in estimated delivery dates for missing dobs*/
if nest_id = 1586 then delivery_date = "19oct2010"d;
run;

data medabs;
set medabs.Nest_r01_baseline_medabs_22jan14;
/*change delivery date here to match estimated delivery date in SR survey dates above*/
if nestid = 1586 then delivery_date = "19oct2010"d;
run;

/*select only NEST I Ids from the SR data*/
proc sql;
create table SR_Survey_date as
select b.*,
(intck('month', a.DELIVERY_DATE, b.SURVEY_DATE) - 
	(day(b.SURVEY_DATE) < day(a.DELIVERY_DATE)))   as age_mo_SR_Surv
from
medabs										as A left join
Nest_sr_data								as b on a.nestID = b.nest_id and a.DELIVERY_DATE = b.DELIVERY_DATE
where survey_date ne .;
quit;	


/********************************************************************************************/
/*																							*/
/*										Prep Diet Recall									*/
/*																							*/
/********************************************************************************************/
/*average total calories in diet recall data by nestid*/
proc sort data=diet.Nest_i_r01_dailytotal_29aug14 out=NEST_I_diet;
by nestid cproject cpjname;
run;

/*this will average by ID and project for all variables with automatic names*/
proc means data=NEST_I_diet noprint;
var _numeric_;
by nestid cproject cpjname;
where ireliabl = 0;
output out =NEST_I_diet_recall_byid mean= /autoname;
run; 


/*calculate the number of days between the NEST SR survey and the diet recall*/
proc sql;
create table diet_surveyDate_merge as
select A.*, abs(intck('day', b.SURVEY_DATE, a.dintake_Mean)) as days_survey_to_diet
from 
NEST_I_diet_recall_byid as a left join
Sr_survey_date as B on a.nestid = b.NEST_ID
order by a.nestid, calculated days_survey_to_diet;
quit;

/*keep the diet recall which is closest to the NEST SR survey date*/
proc sort data=diet_surveyDate_merge out=NEST_I_diet_recall_byid nodupkey;
by nestid;
run;




/********************************************************************************************/
/*																							*/
/*									Prep Vitals-BMI Data									*/
/*																							*/
/********************************************************************************************/
/*stack all dates and IDs together to create a master list for merging*/
data all_ID_refdate (keep = nestid reference_date);
set 
vitals.Nest_r01_all_weight_28nov14 (rename = (wt_reference_date = reference_date))
vitals.Nest_r01_all_height_28nov14 (rename = (ht_reference_date = reference_date))
vitals.Nest_r01_all_head_circ_28nov14 (rename = (head_circ_reference_date = reference_date));
run;

/*narrow to one record for each ID and reference date*/
proc sort data=all_ID_refdate nodupkey;
by nestid reference_date;
run;

/*merge height, weight and head circumference data*/
proc sql;
create table merge_ht_wt_headcir as
select distinct
coalesce(a.nestid, b.nestid, c.nestid) as nestid,
coalesce(a.ht_reference_date, b.wt_reference_date, c.head_circ_reference_date) as reference_date format date9., 
coalesce(a.age_months_height, b.age_months_weight, c.age_months_head_circ) as AGEMOS,
coalesce(a.sex, b.sex, c.sex) as sex,
a.height_length_cm as HEIGHT, a.height_length_type, . as RECUMBNT, a.source as height_source,
b.weight_kg as weight,  b.source as weight_source,
c.head_circ_cm as HEADCIR, c.source as head_circ_source,
abs(intck('day', e.SURVEY_DATE, calculated reference_date)) as days_survey_to_htwt
from 
all_ID_refdate							as D full join
vitals.Nest_r01_all_height_28nov14 		as a on d.nestid = a.nestid and a.ht_reference_date = d.reference_date full join
vitals.Nest_r01_all_weight_28nov14 		as B on d.nestid = b.nestid and b.wt_reference_date = d.reference_date full join
vitals.Nest_r01_all_head_circ_28nov14 	as c on d.nestid = c.NESTID and c.head_circ_reference_date = d.reference_date full join
SR_Survey_date							as E on d.nestid = e.nest_id 	
where d.nestid ne . and d.reference_date ne . and a.height_length_cm ne . and b.weight_kg ne .
order by calculated nestid, calculated days_survey_to_htwt, calculated reference_date desc;
quit;

/*run the CDC growth chart calculations*/
data _INDATA (drop = height_length_type); 
set merge_ht_wt_headcir;
if strip(upcase(height_length_type)) = "L" then RECUMBNT = 1;
else if strip(upcase(height_length_type)) = "H" or height_length_type = "" then RECUMBNT = 0;

%include "&home.\NEST I, II, and SR Harmonized Vars\Supporting Programs\gc-calculate-BIV.sas";

data NEST_I_CDCgrowthchart; 
set _INDATA;
run;


/*keep one record per ID keeping the height-weight closest to the survey date or the most recent one if the survey date is missing*/
/*only look at records with a BMI which is a biologically plausible value*/
proc sort data=NEST_I_CDCgrowthchart;
by nestid days_survey_to_htwt decending reference_date;
where _BIVBMI = 0;
run;
proc sort data=NEST_I_CDCgrowthchart nodupkey;
by nestid;
run;

/********************************************************************************************/
/*																							*/
/*										Prep BLQ											*/
/*																							*/
/********************************************************************************************/
/*prep blq data*/
data blq ;
set blq.Nest_i_blq_05aug14;

if MAT_HISPANIC in (97,98) then MAT_HISPANIC = .;
if MAT_RACE in (97,98) then MAT_RACE = .;
if MAT_TYPE_1_DIABETES in (97,98) then MAT_TYPE_1_DIABETES = .;
if MAT_TYPE_II_DIABETES in (97,98) then MAT_TYPE_II_DIABETES = .;
if MAT_GEST_DIABETES in (97,98) then MAT_GEST_DIABETES = .;
if HOUSEHOLD_INCOME in (97, 98) then HOUSEHOLD_INCOME = .;
if BLQ_HIGHBLDPRESSURE in (97,98) then BLQ_HIGHBLDPRESSURE = .;
if no_births = 999 then no_births = .;
if no_births = 19 and mom_nestid = 2129 then no_births = .;

/*converting shool_list to education level from blqn1 using same measure system in blqn2 */
 if school_hist ne . and school_hist< 12 then education = 1;
 else if school_hist =12 then education =2;
 else if  13<=school_hist<=15 then education =3;
 else if school_hist =16  then education=4;
 else if  school_hist ne .  and 20>=school_hist then education =5;

/*converting race to race_final in blqn1( Non-Hispanic White =1 , Hispanic =2 , African American =3, Asian =4, Other =5 )
      1.Black/African American =3(African American)
	  2. non-Hispanic white= 1(non-hispanic white)
	  3. Hispanic white =2(Hispanice)
	  4. Asian/Pacific Islander =4(Asian)
	  5. American indian/Native American, 6 Biracial or multiracial , 7 other = 5(oter)*/  
if mat_hispanic=1 and mat_race ^=1 then race_final2=2;
else if mat_race =1 then race_final2=3;
else if mat_race =2 then race_final2=1;
else if mat_race =3 then race_final2=2;
else if mat_race =4 then race_final2=4;
else if mat_race in (5,6,7) then race_final2=5;

/*smoking variable*/
if cigs_100_mat=2 then smoker=0;
else if cigs_100_mat=1 and smk_now_mat=2 then smoker=1;
else if cigs_100_mat=1 and smk_now_mat=1 then smoker=2; 
run;




/********************************************************************************************/
/*																							*/
/*										Merge Data											*/
/*																							*/
/********************************************************************************************/
proc sql;
create table  Nest_R01_BLQ_Med_&sysdate (drop=in_enroll rn_nestid rn2_nestid d_mom_nestid) as
select distinct
/*IDs*/ 
coalesce(a.mom_nestid, b.mom_nestid, d.mom_nestid) as mom_nestid, 
coalesce(d.nestid) as nestid,

/*indicators for presence on table*/
(a.mom_nestid ~=.) as in_enroll, 

/*add nestid SR survey date and age in months at SR survey*/
m.SURVEY_DATE as SR_SURVEY_DATE, m.age_mo_SR_Surv,

/*consent date and gestational age at enrollment*/
datepart(a.ConsentDate) as ConsentDate format date9., a.GestationalAge_enroll,

/*race and ethnitiy*/ 
b.MAT_HISPANIC, b.MAT_RACE, /*from blq*/
a.Race as race_enroll, a.Ethnic as hispanic_enroll, /*from enrollment table*/
b.race_final2, b.MARITAL_STATUS,

/*income, education, martial status, smoking status*/
b.SCHOOL_HIST, b.education, b.maternal_smoking2, b.smoker,

/*mom age delivery*/
datepart(a.DOB) as mom_dob format date9., floor((intck('month', datepart(a.dob), d.DELIVERY_DATE) - 
	(day(d.DELIVERY_DATE) < day(datepart(a.dob)))) / 12)  as  mom_age_delv,

/*parity*/
coalesce(b.no_births /*blq*/, d.parity /*medabs*/) as parity_blq_medabs,
b.no_births as blq_partiy, d.parity as medabs_parity,


/*depression/stress*/
b.MAT_DEPRESSION, b.MAT_ATTACKS,

b.MAT_BOTHERED,
b.BOTHERED_PREG,				b.MAT_APPETITE,					b.APPETITE_PREG,
b.MAT_BLUES,					b.BLUES_PREG,					b.MAT_EQUAL,
b.EQUAL_PREG,					b.MAT_FOCUS,					b.FOCUS_PREG,
b.MAT_DEPRESSED,				b.DEPRESSED_PREG,				b.MAT_EFFORT,
b.EFFORT_PREG,					b.MAT_HOPEFUL,					b.HOPEFUL_PREG,
b.MAT_FAILURE,					b.FAILURE_PREG,					b.MAT_FEARFUL,
b.FEARFUL_PREG,					b.MAT_RESTLESS,					b.RESTLESS_PREG,
b.MAT_HAPPY,					b.HAPPY_PREG,					b.MAT_LESS_TALK,
b.LESS_TALK_PREG,				b.MAT_LONELY,					b.LONELY_PREG,
b.MAT_UNFRIENDLY,				b.UNFRIENDLY_PREG,				b.MAT_ENJOYED_LIFE,
b.ENJOYED_LIFE_PREG,			b.MAT_CRYING_SPELLS,			b.CRYING_SPELLS_PREG,
b.MAT_SAD,						b.SAD_PREG,						b.MAT_DISLIKED,
b.DISLIKED_PREG,				b.MAT_GET_GOING,				b.GET_GOIND_PREG,

b.STRESS_UNEXPECTED,			b.STRESS_IMP_THINGS,			b.STRESS_NERVOUS,
b.STRESS_PERSONAL,				b.STRESS_YOUR_WAY,				b.STRESS_NOT_COPE,
b.STRESS_IRRITATION,			b.STRESS_ON_TOP,				b.STRESS_ANGER,
b.ATRESS_DIFFICULTY,


/*vitamins from blq*/
b.MULTIVIT_REG,					b.MULTIVIT_NAME,				b.MULTIVIT_FREQ,
b.MULTIVIT_ADD,					b.MULTIVIT_ADD_NAME,			b.MULTIVIT_ADD_FREQ,
b.PRENATALVIT,					b.PRENATALVIT_NAME,				b.PRENATALVIT_FREQ,
b.IRON,							b.IRON_NAME,					b.IRON_FREQ,
b.CALCIUM,						b.CALCIUM_NAME,					b.CALCIUM_FREQ,
b.FOLATE,						b.FOLATE_NAME,					b.FOLATE_FREQ,
b.VIT_C,						b.VIT_C_NAME,					b.VIT_C_FREQ,
b.VIT_D,						b.VIT_D_NAME,					b.VIT_D_FREQ,
b.VIT_B6,						b.VIT_B6_NAME,					b.VIT_B6_FREQ,
b.VIT_B12,						b.VIT_B12_NAME,					b.VIT_B12_FREQ,
b.METHIONONE,					b.METHIONONE_NAME,				b.METHIONONE_FREQ,
b.VITAMIN_E,					b.VIT_E_NAME,					b.VIT_E_FREQ,
b.CHOLINE,						b.CHOLINE_NAME,					b.CHOLINE_FREQ,
b.VITAMIN_A,					b.VIT_A_NAME,					b.VIT_A_FREQ,
b.BETAINE,						b.BETAINE_NAME,					b.BETAINE_FREQ,
b.RETINOL,						b.RETINOL_NAME,					b.RETINOL_FREQ,
b.ZINC,							b.ZINC_NAME,					b.ZINC_FREQ,
b.SELENIUM,						b.SELENIUM_NAME,				b.SELENIUM_FREQ,
b.OTHER_SUPPLEMENT,				b.OTHER_SUPP_NAME,				b.OTHER_SUPP_FREQ,

l.*,

n.Cd_ng_per_g,

/* mom height, weight, and BMI*/
/*c.Weight_LMP_kg,*/ c.BMI_LMP_kgm2, /*c.weight_kg_final_beforedelv, c.days_wtmeasure_to_delv,*/
c.gest_weight_gain_kg, c.mat_gest_wt_gain_category,

/*MED ABS*/
d.DELIVERY_DATE, (d.GEST_AGE_WKS*7) + d.GEST_AGE_DAYS as GestAge_TotalDays, 
d.BABY_GENDER, d.BABY_WEIGHT, d.LENGTH_BABY, d.LENGTH_IN_OR_CM,

d.CHRONIC_HYPERTENSION,
d.PREGNANCY_HYPERTENSION,
d.PRE_ECLAMPSIA,
d.ECLAMPSIA__SEVERITY,
d.METABOLIC_SYNDROME,
d.PRE_PREGNANCY_DIABETES,
d.PPREG_DIABETES_TYPE,
d.GEST_DIABETES,
d.GEST_DIAB_CONTROL,
d.CHOLESTACIS,
d.INSULIN_RESISTANCE,
d.HOSPITALIZED_DURING_PREG,
d.FETAL_GROWTH_RESTRICTION,


/*age 1 NEST survey date*/
k.YR1_QUEST_DATE,

/*your (mom) feelings - section j*/
k.yr1_ABLE_TO_LAUGH,				k.yr1_LOOK_FORWARD_TO_ENJOY,		k.yr1_BLAMED_MYSELF_UNNECESSARILZ,
k.yr1_ANXIOUS_OR_WORRIED,			k.yr1_SCARED_OR_PANICKY,			k.yr1_THINGS_OVERWHELM_ME,
k.yr1_UNHAPPY_DIFFICULTY_SLEEQ,		k.yr1_FELT_SAD_OR_MISERABLE,		k.yr1_SO_UNHAPPY_CRYING,
k.yr1_THOUGHT_OF_HARMING_MYSELG,


/*mom perceived stress - section k*/
k.yr1_STRESS_UNEXPECTED,			k.yr1_STRESS_IMP_THINGS,			k.yr1_STRESS_NERVOUS,
k.yr1_STRESS_PERSONAL,				k.yr1_STRESS_YOUR_WAY,				k.yr1_STRESS_NOT_COPE,
k.yr1_STRESS_IRRITATION,			k.yr1_STRESS_ON_TOP,				k.yr1_STRESS_ANGER,
k.yr1_STRESS_DIFFICULTY,

/*childs social and emotional behavior - section B Q1-4*/
k.yr1_HOW_MUCH_CHILD_CRIES,			k.yr1_HOW_HARD_TO_CALM,				k.yr1_CRYING_AS_A_PROBLEM,
k.yr1_EVER_BEEN_IN_AGONY,			k.yr1_IF_AGONY__HOW_OFTEN,


/*diet recall*/
e.cproject, e.ireliabl_Mean, 
e.rikcal_Mean, e.rifat_Mean, e.ritcho_Mean, e.ripro_Mean,
e.ripctfat_Mean, e.ripctcho_Mean, e.ripctpro_Mean, e.ritsugar_Mean, e.riasugar_Mean, 
e.riapro_mean, e.rivpro_mean, e.rialc_mean, e.richol_mean, e.risfa_mean, e.rimfa_mean, e.ripfa_mean, e.ridfib_mean, e.riwsdf_mean, 
e.riifib_mean, e.ripctsfa_mean, e.ripctmfa_mean, e.ripctpfa_mean, e.rips_mean,
e.days_survey_to_diet as days_SRsurvey_to_diet,

/*cdc growth chart variables*/
f.reference_date, f.AGEMOS, f.height, f.RECUMBNT, f.height_source, f.weight, f.weight_source, 
	f.headcir, f.head_circ_source, f.days_survey_to_htwt,
f.BMI, f._SDLGZLO, f._SDLGZHI, f._FLAGLG, f._SDSTZLO, f._SDSTZHI, f._FLAGST, 
f.WAZ, f.WTPCT, f._SDWAZLO, f._SDWAZHI, f._FLAGWT, f._BIVWT, 
f.BMIZ, f.BMIPCT, f._SDBMILO, f._SDBMIHI, f._FLAGBMI, f._BIVBMI, 
f.HCZ, f.HCPCT, f._SDHCZLO, f._SDHCZHI, f._FLAGHC, f._BIVHC,
f._FLAGWLG, f._FLAGWST, f.HAZ, f.HTPCT, f._BIVHT, 
f.WHZ, f.WHPCT, f._BIVWHT,

/*DMR*/
j.*,

/*maternal diet estimates - simply an average of all FFQs or taken from first ffq - no additional cleaning*/
o.*

from 
enroll.Nest_r01_access_enroll_tbl					as A full join 
blq 												as B on A.mom_nestid = B.mom_nestid full join
cross.Nest_r01_mom_gest_wtgain_bmi_lmp				as C on a.mom_nestid = c.mom_nestid full join
medabs.Nest_r01_baseline_medabs_22jan14				as D on A.mom_nestid = D.mom_nestid full join
NEST_I_diet_recall_byid								as E on d.nestid = e.nestid full join
NEST_I_CDCgrowthchart								as F on d.nestid = f.nestid full join
dmr	(rename = (nestid = rn_nestid))					as J on D.nestid = J.rn_nestid full join
age1.Nest_age1_surv_01may13							as K on d.nestid = k.nestid full join
craft.Craft_120111 (rename = (nestid = rn2_nestid)) as L on a.mom_nestid = l.rn2_nestid full join
Sr_survey_date										as M on d.nestid = m.nest_id full join
metal.Nest_1_tracemetals_28sep12					as n on a.mom_nestid = n.nestid full join
m_diet.Nest_i_ffq_bffq_diet_est	(rename = (mom_nestid = d_mom_nestid))	as o on a.mom_nestid = o.d_mom_nestid
where a.consentdate not in ("01JAN1900:00:00:00"dt,.)
ORDER BY calculated mom_nestid, calculated nestid;
quit;


/********************************************************************************************/
/*																							*/
/*					Perform Additional Cleaning and Calculate Follow-up Categories			*/
/*																							*/
/*																							*/
/********************************************************************************************/
data  out.Nest_R01_BLQ_Med_&sysdate
	(drop = 		MAT_HISPANIC MAT_RACE race_enroll hispanic_enroll SCHOOL_HIST race_enroll);
set  Nest_R01_BLQ_Med_&sysdate;

if GestationalAge_enroll = 998 then GestationalAge_enroll = .;

/*fill in race from medical records where it is missing*/
length race_final $30.;
if MAT_HISPANIC = 1 or MAT_RACE = 3 then race_final = "Hispanic";
else if MAT_RACE = 1 then race_final = "Black";
else if MAT_RACE = 2 then race_final = "White";
else if Mat_race in (4, 5, 6, 7) then race_final = "Other";
else if upcase(hispanic_enroll) = "YES" then race_final = "Hispanic"; 
else if upcase(Race_enroll) in("AMINDIAN/ALASKANATIVE", "ASIAN", "NATIVEHAWAII/PACISLANDER", "MORE THAN 1 RACE") 
		then race_final = "Other";
else if upcase(race_enroll) = "BLACK/AFAM" then race_final = "Black";
else if upcase(race_enroll) = "WHITE" then race_final = "White";

/*collapse education variable*/
length education_final $60.;
if school_hist in(1,2,3,4,5,6,7,8,9,10,11) then education_final = "Less than high school";
else if school_hist in (12) then education_final = "High school grad/GED";
else if school_hist in (13,14,15) then education_final = "Some college";
else if school_hist in (16,17,18,19,20) then education_final = "College graduate";
run;



