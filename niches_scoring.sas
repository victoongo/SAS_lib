%let redcap='D:\Projects\redcap';
x 'cd D:\Projects\redcap';
libname redcap &redcap.;

%include "D:\sas_lib\all_macros.sas";
/*
* teacher survey;
%include "D:\Projects\redcap\NICHESTeacherSurvey_SAS_2014-09-19_1301.sas";
data redcap.redcap_teacher;
	set redcap;
run;
*/
* Parent survey;
%include "D:\Projects\redcap\NICHESParentSurvey_SAS_2014-09-19_1301.sas";
data redcap.redcap_parent;
	set redcap;
run;

proc format;
	value basc_ 0='Never' 1='Sometimes' 2='Often' 3='Always';
run;
%let basc_hy = basc005 basc017 basc027 basc033 basc045 basc055 basc061 basc083 basc089 basc111 basc117;
%let basc_hy = basc005 basc017 basc027 basc033 basc045 basc055 basc061 basc083 basc089 basc111 basc117;
%let basc_ag = basc012 basc018 basc021 basc040 basc046 basc049 basc068 basc074 basc077 basc096 basc124;
%let basc_ax = basc020 basc023 basc028 basc035 basc048 basc051 basc056 basc063 basc076 basc091 basc104 basc119 basc132;
%let basc_dp = basc014 basc016 basc022 basc024 basc042 basc044 basc050 basc052 basc072 basc100 basc128;
%let basc_sm = basc003 basc010 basc013 basc025 basc031 basc038 basc041 basc053 basc066 basc081 basc094 basc109 basc122;
%let basc_at = basc008 basc036 basc064 basc070 basc073 basc092 basc098 basc101 basc120 basc126;
%let basc_wd = basc009 basc026 basc037 basc054r basc065 basc078 basc082 basc093r basc106 basc110 basc134r;
%let basc_ap = basc006 basc034r basc062r basc080r basc090 basc108r;
%let basc_ad = basc001 basc029 basc057 basc069 basc085 basc097 basc113 basc125;
%let basc_ss = basc004 basc019 basc032 basc047 basc060 basc075 basc088 basc103 basc116;
%let basc_dl = basc039 basc059r basc067r basc087r basc095r basc102r basc115r basc123r basc130r;
%let basc_fc = basc002r basc015 basc030 basc043 basc058 basc071 basc086 basc099 basc105 basc114 basc133r;

%let basc_scales = basc_hy basc_hy basc_ag basc_ax basc_dp basc_sm basc_at basc_wd basc_ap basc_ad basc_ss basc_dl basc_fc;

%let brief_in = brief03 brief08 brief13 brief18 brief23 brief28 brief33 brief38 brief43 brief48 brief52 brief54 brief56 brief58 brief60 brief62;
%let brief_sf = brief05 brief10 brief15 brief20 brief25 brief30 brief35 brief40 brief45 brief50;
%let brief_ec = brief01 brief06 brief11 brief16 brief21 brief26 brief31 brief36 brief41 brief46;
%let brief_wm = brief02 brief07 brief12 brief17 brief22 brief27 brief32 brief37 brief42 brief47 brief51 brief53 brief55 brief57 brief59 brief61 brief63;
%let brief_po = brief04 brief09 brief14 brief19 brief24 brief29 brief34 brief39 brief44 brief49;

%let brief_isci = brief_in brief_ec;
%let brief_fi = brief_sf brief_ec;
%let brief_emi = brief_wm brief_po;
%let brief_gec = brief_in brief_sf brief_ec brief_wm brief_po;

%let brief_sub_scales = brief_in brief_sf brief_ec brief_wm brief_po; 
%let brief_scales = brief_isci brief_fi brief_emi brief_gec;

data redcap_parent;
	set redcap.redcap_parent;
	array basc(*) basc001-basc134;
	do i = 1 to dim(basc);
		basc(i) = basc(i) - 1;
		*format basc(i) basc_.;
	end;
	array basco(*) basc002 basc034 basc054 basc059 basc062 basc067 basc080 basc087 basc093 basc095 basc102 basc108 basc115 basc123 basc130 basc133 basc134;
	array bascr(*) basc002r basc034r basc054r basc059r basc062r basc067r basc080r basc087r basc093r basc095r basc102r basc108r basc115r basc123r basc130r basc133r basc134r;
	do i = 1 to dim(bascr);
		bascr(i) = 3 - basco(i);
		*format bascr(i) basc.;
	end;

	array brief(*) brief01-brief63;
	do i = 1 to dim(brief);
		brief(i) = brief(i) - 1;
	end;
run;

%scale_pctmiss_cutoff(redcap_parent,basc_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,brief_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,brief_scales,0)

data redcap_parent; 
	set redcap_parent;
	label basc_hy = 'hyperactivity';
	label basc_ag = 'aggression';
	label basc_ax = 'anxiety';
	label basc_dp = 'depression';
	label basc_sm = 'somatization';
	label basc_at = 'atypicality';
	label basc_wd = 'withdrawl';
	label basc_ap = 'attention problem';
	label basc_ad = 'adaptability';
	label basc_ss = 'social skills';
	label basc_dl = 'activities of daily living';
	label basc_fc = 'functional communication';

	label brief_in = 'inhibit subscale';
	label brief_sf = 'shift subscale';
	label brief_ec = 'emotional control subscale';
	label brief_wm = 'working memory subscale';
	label brief_po = 'plan/organize subscale';
	label brief_isci = 'inhibitory self-control index';
	label brief_fi = 'flexibility index';
	label brief_emi = 'emergent metacognition index';
	label brief_gec = 'global consecutive composite';
run;

%alpha(redcap_parent,basc_scales)
%alpha(redcap_parent,brief_sub_scales)
%alpha(redcap_parent,brief_scales)


data redcap_parent(drop=nestid rename=(nestidn=nestid));
	set redcap_parent;
	*nestid=trim(nestid);
	*if nestid='.' then nestid='';
	nestidn=.;
	nestidn=nestid;
run;
proc freq data=redcap_parent; tables nestid; run;
data nihtb.nest_merge;
	set nihtb.nest_merge;
	nestid=nestid+0;
run;
proc sort data=redcap_parent; by nestid; run;
data nihtb.nest_merge;
	merge nihtb.nest_merge redcap_parent(in=r keep=nestid &basc_scales. &brief_sub_scales. &brief_scales.);
	by nestid;
	if r=1 then redcap_parent=1;
run;

proc summary data=redcap_parent print; var _numeric_; run;

