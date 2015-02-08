*==============================================================================================*
** PROGRAM: NEST II - Data Prep for Stack - Bernard 12-27-14.sas
** AUTHOR: Rachel Maguire
** DATE: 12/27/2014
** PURPOSE: Pull NEST II data for Fatu and prepare for stacking with NEST I data
	
** KEY INPUTS: NEST II Access Database, medical abstraction, age 1 survey, BLQ
** KEY OUTPUTS: 

MODIFICATION HISTORY                        
  Date        Name    		   Purpose/Modification
11/7/2013 		 	bernard workstation			modified to point to files on Bernard's workstation
11/20/2013			Rachel Maguire				add depression/stress variables
12/13/2013			Rachel Maguire				add questions on postnatal stress and depression
1/9/2014			Rachel Maguire				added updated UNC diet recall, age in months at SR survey & diet recall,
												and NEST I self reported vitamins from BLQ and vitamin blood levels from Craft
6/28/2014			Rachel Maguire				add "mat_bothered" variable and additional vars from medabs
8/5/2014			Rachel Maguire				add marital status
9/7/14				Rachel Maguire				rerun with most recent vitals for child
11/23/14			Rachel Maguire				rerun with most recent vitals for child & add mom diet during preg vars
12/5/14				Rachel Maguire				add source of vitals variable
12/27/14			Rachel Maguire				add baby length variable
*=============================================================================================*;
libname blq "&home.\NEST II\Baseline Questionnaire";
libname medabs "&home.\NEST II\Chart Abstraction";
libname vitals "&home.\NEST II\Vitals\";
libname meth2 "&home.\NEST II\NEST II_R21_DNA Methylation data";
libname enroll "&home.\NEST II\Enrollment Table";
libname diet "&home.\NEST II\UNC Diet Recall";
libname age1_new "&home.\NEST II\Age 1-2 Surveys\ITSEA Age 1 R01 Survey";
libname age1_old "&home.\NEST II\Age 1-2 Surveys\Age 1-2 R21 Survey";
libname Meth450k "&home.\NEST II\450k IDs";
libname out "&home.\NEST I, II, and SR Harmonized Vars";


/********************************************************************************************/
/*																							*/
/*							Import and Prep Methylation Data								*/
/*																							*/
/********************************************************************************************/
/*determine the number of births per mom*/
data num_births	(drop = nestid);
set enroll.Nest_ii_enroll_03nov13 (keep = nestid mom_nestid Twin_triplet);
if Twin_triplet = "" then multiples = 0;
else if Twin_triplet ne "" then multiples = 1;
run;

/*narrow to one record per mom*/
proc sort data=num_births nodupkey;
by mom_nestid;
run;

%macro meth (in, out, abv);
/*clean up IDs on methylation data*/
data &out (rename = (uniqid = mom_nestid));
set &in;
if uniqid=. then delete;
if uniqid in (119 143 177 531 439 ) then delete; /*NO CONSENT*/
if uniqid=7 then uniqid=10;
if uniqid=39 then uniqid=35;
if uniqid=53 then uniqid=50;
if uniqid=57 then uniqid=52;
if uniqid=63  or uniqid=74 then uniqid=64;
if uniqid=69 then uniqid=67;
if uniqid=71 then uniqid=68;
if uniqid=72 then uniqid=66;
if uniqid=87 then uniqid=86;
if uniqid=99 or uniqid=98 then uniqid=95;
if uniqid=110 then uniqid=104;
if uniqid=114 then uniqid=111;
if uniqid=133 then uniqid=128;
if uniqid=188 then uniqid=183;
if uniqid=218 then uniqid=215; /*both ids in genotype import*/
if uniqid=247 then uniqid=242 ; 
if uniqid=248 then uniqid=243;/*both ids in genotype import*/
if uniqid=299 then uniqid=269;/*both ids in genotype import*/
if uniqid=318 then uniqid=316;
if uniqid=325 then uniqid=323;
if uniqid=330 then uniqid=319;
if uniqid=360 then uniqid=358;
if uniqid=400 then uniqid=392;/*both ids in genotype import*/
if uniqid=401 then uniqid=395;/*both ids in genotype import*/
if uniqid in (438 315) then uniqid=427;/* both ids in genotype import*/
if uniqid=441 then uniqid=440;
if uniqid=476 then uniqid=467;
if uniqid=510 then uniqid=503;/*both ids in genotype import*/
if uniqid=552 then uniqid=550;
if uniqid=575 then uniqid=574;
if uniqid=583 then uniqid=582;
if uniqid=604 then uniqid=602;/*both ids in genotype import*/
if uniqid=771 then uniqid=768;
if uniqid=3942 then delete;
if uniqid=3941 then uniqid=394;
run;

/*sort by mom_nestid in preparation for merge*/
proc sort data=&out ;
by mom_nestid;
run;

/*merge with data on twins*/
data &out;
merge &out (in = a) num_births;
by mom_nestid;
if a;

/*assign approrpriate NESTID*/
if multiples in  (.,0) then nestid = mom_nestid;
else if multiples = 1 then nestid = input(cats(mom_nestid, baby), 8.);

/*separate plate number*/
plate_num = input(SUBSTR(plate, 11, 1), 8.);
run;

/*sort by nestid and plate number - eliminating duplicate plates*/
proc sort data=&out out=plate nodupkey;
by nestid plate_num; 
run;

/*count the number of plates per ID*/
proc freq data= plate noprint;
table nestid /out=num_plates_per_ID (drop = percent rename = (count = num_plates_used_for_ID_&ABV));
run;

/*sort to prepare for averaging*/
proc sort data=&out;
by nestid;
run;

/*this will average by ID for all variables with automatic names*/
proc means data=&out noprint;
var _numeric_;
by nestid ;
output out = Meth_avg_by_ID_&out (drop = _type_ _freq_ run_mean baby_mean multiples_mean nestid_mean 
		mom_nestid_mean rename = (plate_num_mean = plate_num_&ABV)) 
	mean= /autoname ;
run; 

data Meth_avg_by_ID_&out;
merge Meth_avg_by_ID_&out num_plates_per_ID;
by nestid;
run;

%mend;
%meth(meth2.cbs1, cbs1_2nd_set, cbs1);
%meth(meth2.dmr0, dmr0_2nd_set, dmr0);
%meth(meth2.meg3_cbs1, meg3_cbs1_2nd_set, meg3_cbs1);
%meth(meth2.meg3_ig, meg3_ig_2nd_set, meg3_ig);
%meth(meth2.mestit1, mestit1_2nd_set, mestit1);
%meth(meth2.nnat1, nnat1_2nd_set, nnat1);
%meth(meth2.peg3, peg3_2nd_set, peg3);
%meth(meth2.plagl1, plagl1_2nd_set, plagl1);
%meth(meth2.sgce, sgce_2nd_set, sgce);


/*stack all methylation data together to get a list of IDs*/
data id_list (keep = nestid );
set Meth_avg_by_ID_cbs1_2nd_set (in = c)					Meth_avg_by_ID_dmr0_2nd_set (in = d)	
	Meth_avg_by_ID_meg3_cbs1_2nd_set (in = e)				Meth_avg_by_ID_meg3_ig_2nd_set (in = f) 
	Meth_avg_by_ID_mestit1_2nd_set (in = g)					Meth_avg_by_ID_nnat1_2nd_set (in = h)			
	Meth_avg_by_ID_peg3_2nd_set (in = i)					Meth_avg_by_ID_plagl1_2nd_set (in = j)		
	Meth_avg_by_ID_sgce_2nd_set (in = k);
run;

/*remove duplicate IDs*/
proc sort data=id_list nodupkey;
by nestid;
run;

/*merge all methylation data together*/
proc sql;
create table NEST_R21_meth_data (drop = rn_nest:)  as
SELECT  
/*identifiers*/ a.nestid, 
/*methylation data*/
f.*, g.*, h.*, I.*, j.*, k.*, l.*, m.*, n.*

FROM 			
id_list									as A full join
Meth_avg_by_ID_cbs1_2nd_set (rename = (nestid = rn_nestid_1))			as F on a.nestid = F.rn_nestid_1 full join
Meth_avg_by_ID_dmr0_2nd_set	(rename = (nestid = rn_nestid_2))			as G on a.nestid = G.rn_nestid_2 full join
Meth_avg_by_ID_meg3_cbs1_2nd_set (rename = (nestid = rn_nestid_3))		as H on a.nestid = H.rn_nestid_3 full join
Meth_avg_by_ID_meg3_ig_2nd_set	(rename = (nestid = rn_nestid_4))		as I on a.nestid = I.rn_nestid_4 full join
Meth_avg_by_ID_mestit1_2nd_set	(rename = (nestid = rn_nestid_5))		as J on a.nestid = J.rn_nestid_5 full join
Meth_avg_by_ID_nnat1_2nd_set	(rename = (nestid = rn_nestid_6))		as K on a.nestid = K.rn_nestid_6 full join
Meth_avg_by_ID_peg3_2nd_set		(rename = (nestid = rn_nestid_7))		as L on a.nestid = L.rn_nestid_7 full join
Meth_avg_by_ID_plagl1_2nd_set	(rename = (nestid = rn_nestid_8))		as M on a.nestid = M.rn_nestid_8 full join
Meth_avg_by_ID_sgce_2nd_set		(rename = (nestid = rn_nestid_9))		as N on a.nestid = N.rn_nestid_9
order by a.nestid;
quit;



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

/*correct ID 302 to be 302 so that rest of data will merge correctly*/
if nest_id = 302 then do;
	 nest_id = 301;
	 delivery_date = "01may2007";
	 end;

/*fill in estimated delivery dates for missing dobs*/
if nest_id = 1586 then delivery_date = "19oct2010"d;
run;



proc sql;
create table SR_Survey_date as
select b.*,
(intck('month', a.DOB_of_infant, b.SURVEY_DATE) - 
	(day(b.SURVEY_DATE) < day(a.DOB_of_infant)))   as age_mo_SR_Surv
from
enroll.Nest_ii_enroll_03nov13				as A left join
Nest_sr_data								as b on a.nestID = b.nest_id and a.DOB_of_infant = b.delivery_date
where survey_date ne .;
quit;	


/********************************************************************************************/
/*																							*/
/*										Prep Diet Recall									*/
/*																							*/
/********************************************************************************************/
/*delete duplicate from differnet project for the same record*/
data NEST_II_diet; 
set diet.Nest_ii_r21_dailytotal_10aug14;
if cproject in
('21Hoyo11A','11Hoyo11A','11Hoyo12C','11Hoyo12B','11Hoyo12E','2NEST1B','2NEST1A','2NEST1C') and nestid ~=422
then delete;
if nestid=820 and cproject= 'NESTSRQA2' then delete;
if nestid=422 and cproject='2NEST1A' then delete;
run;

/*average total calories in diet recall data by nestid*/
proc sort data=NEST_II_diet;
by nestid cproject cpjname;
run;

/*this will average by ID and project for all variables with automatic names*/
proc means data=NEST_II_diet noprint;
var _numeric_;
by nestid cproject cpjname;
where ireliabl = 0;
output out =NEST_II_diet_recall_byid mean= /autoname;
run; 

/*calculate the number of days between the NEST SR survey and the diet recall*/
proc sql;
create table diet_surveyDate_merge as
select A.*, abs(intck('day', b.SURVEY_DATE, a.dintake_Mean)) as days_survey_to_diet
from 
NEST_II_diet_recall_byid as a left join
Sr_survey_date as B on a.nestid = b.NEST_ID
order by a.nestid, calculated days_survey_to_diet;
quit;

/*keep the diet recall which is closest to the NEST SR survey date*/
proc sort data=diet_surveyDate_merge out=NEST_II_diet_recall_byid nodupkey;
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
vitals.Nest_r21_all_weight_28nov14 (rename = (wt_reference_date = reference_date))
vitals.Nest_r21_all_height_28nov14 (rename = (ht_reference_date = reference_date))
vitals.Nest_r21_all_head_circ_28nov14 (rename = (head_circ_reference_date = reference_date));
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
vitals.Nest_r21_all_height_28nov14 		as a on d.nestid = a.nestid and a.ht_reference_date = d.reference_date full join
vitals.Nest_r21_all_weight_28nov14 		as B on d.nestid = b.nestid and b.wt_reference_date = d.reference_date full join
vitals.Nest_r21_all_head_circ_28nov14 	as c on d.nestid = c.NESTID and c.head_circ_reference_date = d.reference_date full join
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

data NEST_II_CDCgrowthchart; 
set _INDATA;
run;

/*keep one record per ID keeping the height-weight closest to the survey date or the most recent one if the survey date is missing*/
/*only look at records with a BMI which is a biologically plausible value*/
proc sort data=NEST_II_CDCgrowthchart;
by nestid days_survey_to_htwt decending reference_date;
where _BIVBMI = 0;
run;
proc sort data=NEST_II_CDCgrowthchart nodupkey;
by nestid;
run;

/********************************************************************************************/
/*																							*/
/*										Prep BLQ											*/
/*																							*/
/********************************************************************************************/
/*prep blq data*/
data blq (rename = (Depression = MAT_DEPRESSION anxiety_panic = MAT_ATTACKS MatStatus = MARITAL_STATUS));
set blq.Nest_r21_blq_05aug14;
/*recode missing codes*/
if MatStatus = 0 then MatStatus = .;

/*fill in race from medical records where it is missing*/
/*converting race to race_final in blqn2( Non-Hispanic White =1 , Hispanic =2 , African American =3, Asian =4, Other =5 )
   1  African American  = 3(African American)
   2  Caucasian  and 2  No(Hispanic) =1(Non-Hispanic white)
   3  Asian=4(Asian)
   4  Native American  and  5  Other  = 5(other)
   1  Yes (Hispanic) = 2(Hispanic) */
if hispanic = 1 and race ^=1 then race_final2 = 2;
else if race = 1 then race_final2 = 3;
else if race= 2 and hispanic=2 then race_final2 = 1;
else if race =3 then race_final2 = 4;
else if race in(4,5 ) then race_final2=5;

/*recode depression and stress variables to match coding on NESt I*/
if Depression = 0 then Depression = 2;
if anxiety_panic = 0 then anxiety_panic = 2;

/*create smoking variable which matches the categories of the NEST I variable*/
if smoke100cigs=0 then smoker=0;
else if smoke100cigs=1 and currentsmoke=0 then smoker=1;
else if smoke100cigs=1 and currentsmoke=1 then smoker=2;

run;


/*smoking behavior after preg missing in blq data - import from excel*/
PROC IMPORT OUT= WORK.BLQ_from_excel 
            DATAFILE= "X:\Nest II - R21\Datasets\DataforImport_091511.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Ques$"; 
     GETNAMES=YES;
     MIXED=YES;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

/*correct ID issues found in Excel spreadsheet*/
data BLQ_from_excel;
set BLQ_from_excel;
if nestid = 212 then nestid = 229; /*229 and 212 have same mom DOB and MFMID in infection chart abs*/
if nestid = 427 then nestid = 315; /*survey data for 427 matches 315's race and height - current weight is a few lbs less than weight at delv*/
if nestid = 701 then nestid = 695; /*survey data for 701 matches 695's race and height - current weight is a few lbs less than weight at delv - 
	usual weight is a few pounds less than weight prior to pregnancy*/
if nestid = 1691 then nestid = 169; /*this isn't twins so change the ID to 169*/
if nestid = 1692 then delete; /*this isn't twins and the data is already under 1691 so delete this record*/
if nestid = 9040 then delete; /*confirmed - these IDS had the same data*/
if nestid = 195 then nestid = 216;

/*clean multivitamin-prenatal vitamin variables and create a daily vitamin indicator*/
if pregmultvitareg in (1,2) or pregmultvitextra in (1,2) or pregprenat in (1,2) then prenatal_vitamin = 1;
else prenatal_vitamin = 0;

run;



/********************************************************************************************/
/*																							*/
/*									Merge Individual Tables									*/
/*																							*/
/*																							*/
/********************************************************************************************/
/*merge enrollment, blq, missing heights, and medical abstraction*/
proc sql;
create table merge (drop = rn_nestid) as
select distinct
	/*IDs*/
coalesce(a.nestid, b.mom_nestid,  d.nestid) as nestid, 
a.mom_nestid,
	/*indicators for presence on table*/
 (a.nestid ~=.) as in_pt_contact, n.in_450k,

/*add nestid SR survey date and age in months at SR survey*/
o.SURVEY_DATE as SR_SURVEY_DATE, o.age_mo_SR_Surv,

 /*consent date and gestational age at enrollment*/
 a.consentdate format date9., 
sum((input(scan(a.GAatConsent, 1, '/\'),8.)*7), input(scan(a.GAatConsent, 2, '/\'),8.)) as GestationalAge_Enroll,

	/*demographics and background*/
/*mom race and education*/
a.Race as race_enroll, b.race as race_blq, b.hispanic, b.race_final2,
b.Education, /*b.finalsmk,*/
b.smoker, 

/*maternal smoking*/
b.smoke100cigs,  
b.CurrentSmoke, 
b.SmokeYearPreg, 
input(b.SmokeYearPregNum, 8.) as SmokeYearPregNum,
p.SmokeBehaveAfterPreg, /*missing in current blq dataset so imported from excel*/
input(b.SmokeAfterPregNum, 8.) as SmokeAfterPregNum, 
. as maternal_smoking2,


/*depression/stress*/
b.MAT_DEPRESSION, b.MAT_ATTACKS,

/*mom pre-preg BMI*/
 d.bmiusual as BMI_LMP_kgm2, b.Heightinches, b.WeightUsual, d.MomLastWght,

/*baby gender*/
a.sex as sex_enroll, d.BirthWt as BABY_WEIGHT, d.BirthLength, . as LENGTH_IN_OR_CM,
a.DOB_of_infant as DELIVERY_DATE format date9.,

/*parity*/
d.Parity as medabs_parity, 

 /* gestational age at delivery*/
d.GA_MedAbst, b.weeksatdelivery_ques,

/*other medabs vars*/
d.CHRONIC_HYPERTENSION, d.PREGNANCY_HYPERTENSION, d.Unknown_Type_Hypertension, 
d.PRE_ECLAMPSIA, d.ECLAMPSIA__SEVERITY, 
d.PRE_PREGNANCY_DIABETES, d.PPREG_DIABETES_TYPE, d.GEST_DIABETES, 
d.MetabolicSyndr as METABOLIC_SYNDROME, d.Cholest as CHOLESTACIS, 
d.InsulRes as INSULIN_RESISTANCE, d.Hospital as HOSPITALIZED_DURING_PREG, 
d.FetalGrowth as FETAL_GROWTH_RESTRICTION, 

/*dates*/
a.dob as mom_dob, floor((intck('month', a.dob, a.DOB_of_infant) - 
	(day(a.DOB_of_infant) < day(a.dob))) / 12)  as  mom_age_delv,

/*age 1 NEST survey date*/
coalesce(L.YR1_QUEST_DATE, M.oneYrSurveyDate) as YR1_QUEST_DATE format date9.,

/*your (mom) feelings - section j*/
l.yr1_ABLE_TO_LAUGH,				l.yr1_LOOK_FORWARD_TO_ENJOY,		l.yr1_BLAMED_MYSELF_UNNECESSARILZ,
l.yr1_ANXIOUS_OR_WORRIED,			l.yr1_SCARED_OR_PANICKY,			l.yr1_THINGS_OVERWHELM_ME,
l.yr1_UNHAPPY_DIFFICULTY_SLEEQ,		l.yr1_FELT_SAD_OR_MISERABLE,		l.yr1_SO_UNHAPPY_CRYING,
l.yr1_THOUGHT_OF_HARMING_MYSELG,

/*mom perceived stress - section k*/
l.yr1_STRESS_UNEXPECTED,			l.yr1_STRESS_IMP_THINGS,			l.yr1_STRESS_NERVOUS,
l.yr1_STRESS_PERSONAL,				l.yr1_STRESS_YOUR_WAY,				l.yr1_STRESS_NOT_COPE,
l.yr1_STRESS_IRRITATION,			l.yr1_STRESS_ON_TOP,				l.yr1_STRESS_ANGER,
l.yr1_STRESS_DIFFICULTY,

/*childs social and emotional behavior - section B Q1-4*/
l.yr1_HOW_MUCH_CHILD_CRIES,			l.yr1_HOW_HARD_TO_CALM,				l.yr1_CRYING_AS_A_PROBLEM,
l.yr1_EVER_BEEN_IN_AGONY,			l.yr1_IF_AGONY__HOW_OFTEN,

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

/*DMRs*/
k.*

from 
enroll.Nest_ii_enroll_03nov13 							as A full join 
blq		 												as B on A.mom_nestid = B.mom_nestid full join 
medabs.Nest_r21_medabs_27dec14							as D on A.NESTID = d.nestid full join
NEST_II_diet_recall_byid								as E on a.nestid = e.nestid full join
NEST_II_CDCgrowthchart									as F on a.nestid = f.nestid full join
NEST_R21_meth_data	(rename = (nestid = rn_nestid))		as k on a.nestid = k.rn_nestid full join
age1_new.Nest_r21_r01age1_surv_01may13					as L on a.nestid = l.nestid full join
age1_old.Nest_r21_age1_r21_itsea_06apr13				as M on a.nestid = m.nestid full join
Meth450k.Nest_ii_r21_450k_19nov13						as N on a.nestid = n.nestid full join
Sr_survey_date											as o on a.nestid = o.nest_id full join
BLQ_from_excel											as p on a.mom_nestid = p.nestid 
where calculated in_pt_contact = 1
ORDER BY a.mom_nestid, calculated nestid;
quit;




/********************************************************************************************/
/*																							*/
/*									Clean Merged Data										*/
/*																							*/
/*																							*/
/********************************************************************************************/
data out.Nest_R21_BLQ_Med_&sysdate (rename = (GA_MedAbst = GestAge_TotalDays BirthLength = LENGTH_BABY)
	drop = in_pt_contact race_enroll race_blq Hispanic Heightinches WeightUsual MomLastWght
	sex_enroll weeksatdelivery_ques cbsmean_MISSING_Mean dmrmean_MISSING_Mean cbs1_missing_Mean
	ig_missing_Mean mestit1_MISSING_Mean NNAT1_MISSING_Mean peg3_MISSING_Mean PLAGL1_missing_Mean
	SGCE_missing_Mean smoke100cigs CurrentSmoke SmokeYearPreg SmokeBehaveAfterPreg  SmokeAfterPregNum SmokeYearPregNum);
set merge;

/*set unit of length to 2 (cm) for all records with baby length on nest ii*/
if BirthLength ne . then LENGTH_IN_OR_CM = 2;

/*recode missing codes*/
if medabs_parity = 999 then medabs_parity = .;

/*clean gestational ages at delivery*/
/*/*calculate gestational age at blood draw*/*/;
/*subtract days from blood draw to delivery from GA at birth in days to get GA in days when blood was collected*/
/*data cleaning - correct gestational age - looked up in ebrowser*/
if nestid = 764 then GA_MedAbst = ((41*7)+2);
if GA_MedAbst = 999 then GA_MedAbst = .;
if GA_MedAbst = . and weeksatdelivery_ques not in (4, 995) then GA_MedAbst = weeksatdelivery_ques* 7;

/*determine sex of baby*/
if upcase(sex_enroll) in ("M","MALE") then BABY_GENDER = 1;
else if upcase(sex_enroll) = "F" then BABY_GENDER = 2;

/*data cleaning on smoking variables*/
	/*reported regular smoking in later questions*/
if mom_nestid in (596, 9056) then smoke100cigs = 1; 
/*	blq was taken after delv and reported quitting smoking in first trimester so not a current smoker*/
if mom_nestid in (137) then CurrentSmoke = 0;
/*clean missing indicators*/
if SmokeAfterPregNum in (994, 99) then SmokeAfterPregNum = .;

/*smoking in pregnancy
	0 = no smoke during preg - not smoked 100+ cigs or no reported smoking during pregnancy as of baseline questionnaire
	1 = smoked during preg - reported smoking during pregnancy
	.m = insufficient data to make determination*/
if CurrentSmoke = 1 or SmokeBehaveAfterPreg in (1,2,3,4) or SmokeAfterPregNum not in (0, .)
	then maternal_smoking2 = 1; /*smoked during preg*/
else if (smoke100cigs = 0 and SmokeAfterPregNum in (.,0)) or (CurrentSmoke = 0 and SmokeYearPreg in (.,0) and 
	SmokeBehaveAfterPreg = . and SmokeAfterPregNum in (.,0)) 
	then maternal_smoking2 = 0; /*no smoke during preg*/
else maternal_smoking2 = .; /*insufficient data to make determination*/

/*gestatational weight gain data cleaning and calculation*/
if MomLastWght = 999 then MomLastWght = .;

if nestid in (9016, 9042, 9057, 783, 285) then WeightUsual = .;
if nestid = 875 then weightusual = 375;
if nestid = 6541 then do;
	MomLastWght = 185;
	WeightUsual = 152;
	end;
if nestid = 638 then WeightUsual = 414;
if nestid = 598 then WeightUsual = 118;

BMI_LMP_kgm2= (WeightUsual*.453592)/((Heightinches*0.0254)*(Heightinches*0.0254)); /*weight in kg over height in meters squared*/
gest_weight_gain_kg = (MomLastWght*.453592) - (WeightUsual*.453592);

/*determine adequate vs excessive maternal weight gain*/
length mat_gest_wt_gain_category $40.;
if BMI_LMP_kgm2 = . or gest_weight_gain_kg = . then mat_gest_wt_gain_category = "missing BMI LMP or Gest wt gain";
else if (BMI_LMP_kgm2 lt 18.5 and gest_weight_gain_kg lt 12.5) OR
		(BMI_LMP_kgm2 ge 18.5 and BMI_LMP_kgm2 lt 25 and gest_weight_gain_kg lt 11.5) OR
		(BMI_LMP_kgm2 ge 25 and BMI_LMP_kgm2 lt 30 and gest_weight_gain_kg lt 7) OR
		(BMI_LMP_kgm2 ge 30 and gest_weight_gain_kg lt 5)	
	then mat_gest_wt_gain_category = "Less than adequate";
else if (BMI_LMP_kgm2 lt 18.5 and gest_weight_gain_kg ge 12.5 and gest_weight_gain_kg le 18) OR
		(BMI_LMP_kgm2 ge 18.5 and BMI_LMP_kgm2 lt 25 and gest_weight_gain_kg ge 11.5 and gest_weight_gain_kg le 16) OR
		(BMI_LMP_kgm2 ge 25 and BMI_LMP_kgm2 lt 30 and gest_weight_gain_kg ge 7 and gest_weight_gain_kg le 11.5) OR
		(BMI_LMP_kgm2 ge 30 and gest_weight_gain_kg ge 5 and gest_weight_gain_kg le 9)
	then mat_gest_wt_gain_category = "adequate";
else if (BMI_LMP_kgm2 lt 18.5 and gest_weight_gain_kg gt 18) OR
		(BMI_LMP_kgm2 ge 18.5 and BMI_LMP_kgm2 lt 25 and gest_weight_gain_kg gt 16) OR
		(BMI_LMP_kgm2 ge 25 and BMI_LMP_kgm2 lt 30 and gest_weight_gain_kg gt 11.5) OR
		(BMI_LMP_kgm2 ge 30 and gest_weight_gain_kg gt 9)
	then mat_gest_wt_gain_category = "excessive";


if upcase(race_enroll) = "H" or Hispanic = 1 then race_final = "Hispanic";
else if race_blq = 1 then race_final = "Black";
else if race_blq = 2 then race_final = "White";
else if race_blq in (3,4,5) then race_final = "Other";
else if upcase(race_enroll) = "B" then race_final = "Black";
else if upcase(race_enroll) = "W" then race_final = "White";
else if upcase(race_enroll) in ("A", "BIRACIAL", "NATIVE AM", "PI", "MIXED",
	"OTHER") then race_final = "Other";


	/*ID cleanup*/
if nestid in (1691, 1692) then delete;
else if mom_nestid = . then mom_nestid = nestid;

/*collapse education variable*/
length education_final $60.;
if education in(1) then education_final = "Less than high school";
else if education in (2) then education_final = "High school grad/GED";
else if education in (3) then education_final = "Some college";
else if education in (4,5) then education_final = "College graduate";


/*rename nest II variables to match NEST I names*/
rename
cbs1_1_Mean	=	igf2_cbs1_pos1
cbs1_2_Mean	=	igf2_cbs1_pos2
cbs1_3_Mean	=	igf2_cbs1_pos3
cbs1_4_Mean	=	igf2_cbs1_pos4
cbs1mean_Mean	=	igf2_cbs1_mean
dmr0_1_Mean	=	igf2_dmr_pos1
dmr0_2_Mean	=	igf2_dmr_pos2
dmr0_3_Mean	=	igf2_dmr_pos3
dmr0mean_Mean	=	igf2_dmr_mean
MEG3_cbs1_1_Mean	=	meg3_cbs_pos1
MEG3_cbs1_2_Mean	=	meg3_cbs_pos2
MEG3_cbs1_3_Mean	=	meg3_cbs_pos3
MEG3_cbs1_4_Mean	=	meg3_cbs_pos4
MEG3_cbs1_5_Mean	=	meg3_cbs_pos5
MEG3_cbs1_6_Mean	=	meg3_cbs_pos6
MEG3_cbs1_7_Mean	=	meg3_cbs_pos7
MEG3_cbs1_8_Mean	=	meg3_cbs_pos8
meg3_cbs1mean_Mean	=	meg3_cbs_mean
MEG3_ig_1_Mean	=	meg3_ig_pos1
MEG3_ig_2_Mean	=	meg3_ig_pos2
MEG3_ig_3_Mean	=	meg3_ig_pos3
MEG3_ig_4_Mean	=	meg3_ig_pos4
MEG3_igmean_Mean	=	meg3_ig_mean
MESTIT1_1_Mean	=	mestit1_pos1
MESTIT1_2_Mean	=	mestit1_pos2
MESTIT1_3_Mean	=	mestit1_pos3
MESTIT1_4_Mean	=	mestit1_pos4
mestit1mean_Mean	=	mestit1_mean
NNAT1_1_Mean	=	nnat_pos1
NNAT1_2_Mean	=	nnat_pos2
NNAT1_3_Mean	=	nnat_pos3
nnat1mean_Mean	=	nnat_mean
PEG3_1_Mean	=	peg3_pos1
PEG3_2_Mean	=	peg3_pos2
PEG3_3_Mean	=	peg3_pos3
PEG3_4_Mean	=	peg3_pos4
PEG3_5_Mean	=	peg3_pos5
PEG3_6_Mean	=	peg3_pos6
PEG3_7_Mean	=	peg3_pos7
PEG3_8_Mean	=	peg3_pos8
PEG3_9_Mean	=	peg3_pos9
PEG3_10_Mean	=	peg3_pos10
peg3mean_Mean	=	peg3_mean
SGCE_1_Mean	=	sgce_pos1
SGCE_2_Mean	=	sgce_pos2
SGCE_3_Mean	=	sgce_pos3
SGCE_4_Mean	=	sgce_pos4
SGCE_5_Mean	=	sgce_pos5
SGCE_6_Mean	=	sgce_pos6
sgcemean_Mean	=	sgce_mean
PLAGL1_1_Mean	=	zac_pos1
PLAGL1_2_Mean	=	zac_pos2
PLAGL1_3_Mean	=	zac_pos3
PLAGL1_4_Mean	=	zac_pos4
PLAGL1_5_Mean	=	zac_pos5
PLAGL1_6_Mean	=	zac_pos6
plagl1mean_Mean	=	zac_mean
;



run;
