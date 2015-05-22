x 'cd p:\niches\redcap';
%include "D:\dropbox\projects\sas_lib\all_macros.sas";
* LIBNAME library 'P:\NICHES\redcap\';

* teacher survey;
*%include "D:\Projects\redcap\NICHESTeacherSurvey_SAS_2014-09-19_1301.sas";
/*data redcap.redcap_teacher; set redcap; run;*/

* teacher survey;
%include "p:\NICHES\redcap\NICHESteacherSurvey_SAS_2015-05-04_1615.sas";
data redcap.redcap_teacher; set redcap; run;

/*proc contents data=redcap.redcap_teacher; run;*/

proc format;
	value basc_ 0='Never' 1='Sometimes' 2='Often' 3='Always';
run;

%include "D:\dropbox\projects\sas_lib\niches_redcap_scoring_teacher.sas";

data redcap_teacher;
	set redcap.redcap_teacher;
	array tbasc(*) tbasc001-tbasc134;
	do i = 1 to dim(tbasc);
		tbasc(i) = tbasc(i) - 1;
		*format tbasc(i) tbasc_.;
	end;
	array tbasco(*) tbasc28 tbasc53 tbasc75 tbasc100 tbasc52 tbasc87;
	array tbascr(*) tbasc28r tbasc53r tbasc75r tbasc100r tbasc52r tbasc87r;
	do i = 1 to dim(tbascr);
		tbascr(i) = 3 - tbasco(i);
		*format tbascr(i) tbasc.;
	end;

	array stbasc(*) stbasc001-stbasc134;
	do i = 1 to dim(stbasc);
		stbasc(i) = stbasc(i) - 1;
		*format stbasc(i) stbasc_.;
	end;
	array stbasco(*) stbasc029 stbasc033 stbasc044 stbasc072 stbasc128 stbasc050 stbasc059 stbasc087 stbasc035 stbasc063;
	array stbascr(*) stbasc029r stbasc033r stbasc044r stbasc072r stbasc128r stbasc050r stbasc059r stbasc087r stbasc035r stbasc063r;
	do i = 1 to dim(stbascr);
		stbascr(i) = 3 - stbasco(i);
	end;

	array tsdq(*) tsdq01-tsdq25;
	do i = 1 to dim(tsdq);
		tsdq(i) = tsdq(i) - 1;
	end;
	
run;

%scale_pctmiss_cutoff(redcap_teacher,tbasc_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_teacher,tbasc_scales,0)
%scale_pctmiss_cutoff(redcap_teacher,tbrief_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_teacher,tbrief_scales,0)
%scale_pctmiss_cutoff(redcap_teacher,stbasc_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_teacher,stbasc_scales,0)
%scale_pctmiss_cutoff(redcap_teacher,stbrief_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_teacher,stbrief_scales,0)
%scale_pctmiss_cutoff(redcap_teacher,tswan_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_teacher,tswan_scales,0)
%scale_pctmiss_cutoff(redcap_teacher,tsdq_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_teacher,tsdq_scales,0)

data redcap_teacher; 
	set redcap_teacher;
	*%include "D:\dropbox\projects\sas_lib\niches_redcap_scoring_labels_teacher.sas";
run;
/*
%alpha(redcap_teacher,basc_sub_scales)
%alpha(redcap_teacher,brief_sub_scales)
%alpha(redcap_teacher,brief_scales)
%alpha(redcap_teacher,caars_sub_scales)
%alpha(redcap_teacher,caars_scales)
%alpha(redcap_teacher,swan_sub_scales)
%alpha(redcap_teacher,swan_scales)
%alpha(redcap_teacher,sdq_sub_scales)
%alpha(redcap_teacher,sdq_scales)
%alpha(redcap_teacher,psi_sub_scales)
%alpha(redcap_teacher,psdqs_sub_scales)
%alpha(redcap_teacher,psdqo_sub_scales)
*/
%let scores = &tbasc_sub_scales. &tbasc_scales. &tbrief_sub_scales. &tbrief_scales. 
			  &stbasc_sub_scales. &stbasc_scales. &stbrief_sub_scales. &stbrief_scales. 
			  &tswan_sub_scales. &tswan_scales. &tsdq_sub_scales. &tsdq_scales.;
%put &scores.;
%lst_pre(&scores.,pscores_pre,es0_te)
%put &pscores_pre.;
%lst_rename(&scores.,pscores,es0_te)
%put &pscores.;

data redcap_teacher(drop=nestid rename=(nestidn=nestid &pscores.));
	set redcap_teacher;
	*nestid=trim(nestid);
	*if nestid='.' then nestid='';
	nestidn=.;
	nestidn=nestid;
run;
/*proc freq data=redcap_teacher; tables nestid; run;*/

proc sort data=redcap_teacher out=redcap.redcap_teacher; by nestid; run;

data redcap_teacher;
	set redcap.redcap_teacher(keep=nestid &pscores_pre.);
run;

proc sort data=redcap_teacher out=redcap_teacher; by nestid; run;


/*
proc summary data=niches.nest_merge_tb_rc print; var _numeric_; run;
proc summary data=redcap_teacher print; var _numeric_; run;
*/
