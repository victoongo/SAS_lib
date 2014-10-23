x 'cd D:\Projects\redcap';
%include "D:\dropbox\projects\sas_lib\all_macros.sas";
/*
* teacher survey;
%include "D:\Projects\redcap\NICHESTeacherSurvey_SAS_2014-09-19_1301.sas";
data redcap.redcap_teacher;
	set redcap;
run;
*/
* Parent survey;
%include "D:\Projects\redcap\NICHESParentSurvey_SAS_2014-10-16_1529.sas";
data redcap.redcap_parent;
	set redcap;
run;
proc contents data=redcap.redcap_parent; run;

proc format;
	value basc_ 0='Never' 1='Sometimes' 2='Often' 3='Always';
run;

%include "D:\dropbox\projects\sas_lib\niches_redcap_scoring.sas";

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
	array caars(*) caars01-caars63;
	do i = 1 to dim(caars);
		caars(i) = caars(i) - 1;
	end;
	array sdq(*) sdq01-sdq25;
	do i = 1 to dim(sdq);
		sdq(i) = sdq(i) - 1;
	end;
	array psi(*) psi01-psi36;
	do i = 1 to dim(psi);
		psi(i) = 6 - psi(i);
	end;
run;

%scale_pctmiss_cutoff(redcap_parent,basc_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,brief_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,brief_scales,0)
%scale_pctmiss_cutoff(redcap_parent,caars_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,caars_scales,0)
%scale_pctmiss_cutoff(redcap_parent,swan_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,swan_scales,0)
%scale_pctmiss_cutoff(redcap_parent,sdq_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,sdq_scales,0)
%scale_pctmiss_cutoff(redcap_parent,psi_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,psdqs_sub_scales,0)
%scale_pctmiss_cutoff(redcap_parent,psdqo_sub_scales,0.2)

data redcap_parent; 
	set redcap_parent;
	%include "D:\dropbox\projects\sas_lib\niches_redcap_scoring_labels.sas";
run;
/*
%alpha(redcap_parent,basc_sub_scales)
%alpha(redcap_parent,brief_sub_scales)
%alpha(redcap_parent,brief_scales)
%alpha(redcap_parent,caars_sub_scales)
%alpha(redcap_parent,caars_scales)
%alpha(redcap_parent,swan_sub_scales)
%alpha(redcap_parent,swan_scales)
%alpha(redcap_parent,sdq_sub_scales)
%alpha(redcap_parent,sdq_scales)
%alpha(redcap_parent,psi_sub_scales)
%alpha(redcap_parent,psdqs_sub_scales)
%alpha(redcap_parent,psdqo_sub_scales)
*/
%let scores = &basc_sub_scales. &brief_sub_scales. &brief_scales. 
			  &caars_sub_scales. &caars_scales. &swan_sub_scales. &swan_scales. &sdq_sub_scales. &sdq_scales. 
			  &psi_sub_scales. &psdqs_sub_scales. &psdqo_sub_scales.
			  mom_degre ;
%put &scores.;
%lst_pre(&scores.,pscores_pre,es0_pa)
%put &pscores_pre.;
%lst_rename(&scores.,pscores,es0_pa)
%put &pscores.;

data redcap_parent(drop=nestid rename=(nestidn=nestid &pscores.));
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
proc sort data=redcap_parent out=redcap.redcap_parent; by nestid; run;
data nihtb.nest_merge_tb_rc;
	merge redcap.redcap_parent(in=r keep=nestid &pscores_pre.) nihtb.nest_merge_tb;
	by nestid;
	if r=1 then redcap_parent=1;
run;

proc summary data=nihtb.nest_merge_tb_rc print; var _numeric_; run;
proc summary data=redcap_parent print; var _numeric_; run;

