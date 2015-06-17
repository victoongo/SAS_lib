x 'cd p:\niches\redcap';
%include "D:\dropbox\projects\sas_lib\all_macros.sas";
* LIBNAME library 'P:\NICHES\redcap\';

proc sort data="P:\NEST I, II, and SR Harmonized Vars\nest_i_ii_sr_merge.sas7bdat" out=nest_merge; by nestid; run;
data nest_merge; set nest_merge; nestid=nestid+0; run;
%include "D:\Dropbox\Projects\sas_lib\Code for Summary Variables for NESTSR analyses.sas";

* teacher survey;
*%include "D:\Projects\redcap\NICHESTeacherSurvey_SAS_2014-09-19_1301.sas";
/*data redcap.redcap_teacher; set redcap; run;*/

* Parent survey;
%include "p:\NICHES\redcap\NICHESParentSurvey_SAS_2015-06-16_1352.sas";
data redcap.redcap_parent; 
	set redcap; 
	if participant_id in ('113', '118', '162', '164') then delete;
run;

/*proc contents data=redcap.redcap_parent; run;*/

proc format;
	value basc_ 0='Never' 1='Sometimes' 2='Often' 3='Always';
run;

%include "D:\dropbox\projects\sas_lib\niches_redcap_scoring_parent.sas";

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

	array sbasc(*) sbasc001-sbasc160;
	do i = 1 to dim(sbasc);
		sbasc(i) = sbasc(i) - 1;
	end;
	array sbasco(*) sbasc16 sbasc80 sbasc17 sbasc41 sbasc49 sbasc105 sbasc142 sbasc3 sbasc103 sbasc131 sbasc66 sbasc81 sbasc98 sbasc145;
	array sbascr(*) sbasc16r sbasc80r sbasc17r sbasc41r sbasc49r sbasc105r sbasc142r sbasc3r sbasc103r sbasc131r sbasc66r sbasc81r sbasc98r sbasc145r;
	do i = 1 to dim(sbascr);
		sbascr(i) = 3 - sbasco(i);
	end;

	array brief(*) brief01-brief63;
	do i = 1 to dim(brief);
		brief(i) = brief(i);* - 1;
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
%scale_pctmiss_cutoff(redcap_parent,basc_scales,0)
%scale_pctmiss_cutoff(redcap_parent,brief_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,brief_scales,0)
%scale_pctmiss_cutoff(redcap_parent,sbasc_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,sbasc_scales,0)
%scale_pctmiss_cutoff(redcap_parent,sbrief_sub_scales,0.2)
%scale_pctmiss_cutoff(redcap_parent,sbrief_scales,0)
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
	%include "D:\dropbox\projects\sas_lib\niches_redcap_scoring_labels_parent.sas";
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
%let scores = &basc_sub_scales. &basc_scales. &brief_sub_scales. &brief_scales. 
			  &sbasc_sub_scales. &sbasc_scales. &sbrief_sub_scales. &sbrief_scales. 
			  &caars_sub_scales. &caars_scales. &swan_sub_scales. &swan_scales. &sdq_sub_scales. &sdq_scales. 
			  &psi_sub_scales. &psdqs_sub_scales. &psdqo_sub_scales.
			  mom_degre ;
%put &scores.;
%lst_pre(&scores.,pscores_pre,es0_pa)
%put &pscores_pre.;
%lst_rename(&scores.,pscores,es0_pa)
%put &pscores.;

data redcap_parent(drop=nestid rename=(nestidn=nestid age=es0_age wasi_age=es0_wasi_age &pscores.));
	set redcap_parent;
	*nestid=trim(nestid);
	*if nestid='.' then nestid='';
	nestidn=.;
	nestidn=nestid;
run;
/*proc freq data=redcap_parent; tables nestid; run;*/

proc sort data=redcap_parent out=redcap.redcap_parent; by nestid; run;

%let daswasi = pdas_summ_2 pdas_summ_test_dt pdas_age pdas_summ_hand vcom_as_low vcom_tscore_low vcom_verbal_low vcom_gca_low vcom_perc_low vcom_age_eq_low vcom_age_yr_low vcom_age_mo_low psim_as_low psim_tscore_low psim_nonverbal_low psim_gca_low psim_perc_low psim_age_eq_low psim_age_yr_low psim_age_mo_low nvoc_as_low nvoc_tscore_low nvoc_verbal_low nvoc_gca_low nvoc_perc_low nvoc_age_eq_low nvoc_age_yr_low nvoc_age_mo_low pcon_std_alt_low pcon_as_low pcon_tscore_low pcon_nonverbal_low pcon_gca_low pcon_perc_low pcon_age_eq_low pcon_age_yr_low pcon_age_mo_low vcom_as_up vcom_tscore_up vcom_verbal_up vcom_gca_up vcom_perc_up vcom_age_eq_up vcom_age_yr_up vcom_age_mo_up psim_as_up psim_tscore_up psim_nonverbal_up psim_gca_up psim_snc_up psim_perc_up psim_age_eq_up psim_age_yr_up psim_age_mo_up nvoc_as_up nvoc_tscore_up nvoc_verbal_up nvoc_gca_up nvoc_perc_up nvoc_age_eq_up nvoc_age_yr_up nvoc_age_mo_up pcon_std_alt_up pcon_as_up pcon_tscore_up pcon_spatial_up pcon_gca_up pcom_snc_up pcon_perc_up pcon_age_eq_up pcon_age_yr_up pcon_age_mo_up mat_as_up mat_tscore_up mat_nonverbal_up mat_gca_up mat_snc_up mat_perc_up mat_age_eq_up mat_age_yr_up mat_age_mo_up copy_as_up copy_tscore_up copy_spatial_up copy_gca_up copy_snc_up copy_perc_up copy_age_eq_up copy_age_yr_up copy_age_mo_up cc_verbal_ss cc_verbal_perc cc_verbal_ci_low cc_verbal_ci_up cc_nonverbal_ss cc_nonverbal_perc cc_nonverbal_ci_low cc_nonverbal_ci_up cc_spatial_ss cc_spatial_perc cc_spatial_ci_low cc_spatial_ci_up cc_gca_ss cc_gca_perc cc_gca_ci_low cc_gca_ci_up cc_gca_meant_up cc_snc_ss cc_snc_perc cc_snc_ci_low cc_snc_ci_up cc_snc_meant_up das_complete wasi_test_dt wasi_handiness wasi_visual_hearing___1 wasi_visual_hearing___2 wasi_visual_hearing___3 wasi_visual_hearing___4 wasi_glasses wasi_prescript wasi_assist wasi_other wasi_block_raw wasi_block_t wasi_vocab_raw wasi_vocab_t wasi_matrix_raw wasi_matrix_t wasi_similar_raw wasi_similar_t verbal_cs verbal_pr verbal_ci_low verbal_ci_up pr_cs pr_pr pr_ci_low pr_ci_up fs4_cs fs4_pr fs4_ci_low fs4_ci_up fs2_cs fs2_pr fs2_ci_low fs2_ci_up wasi_ii_complete;

data redcap_parent;
	set redcap.redcap_parent(keep=nestid es0_age es0_wasi_age &pscores_pre. &daswasi.);
run;

proc sort data=redcap_parent out=redcap_parent; by nestid; run;

data scoredata_ww; set nihtb.scoredata_ww; run;

%dupvars(redcap_parent, scoredata_ww)
%dupvars(redcap_parent, nest_merge)
%dupvars(scoredata_ww, nest_merge)

data niches.nest_merge_tb_rc;
	merge redcap_parent(in=r) redcap_teacher(in=t) nihtb.scoredata_ww(in=s) nest_merge(in=nm);
	by nestid;
	if r=1 then redcap_parent=1;
	if t=1 then redcap_teacher=1;
	if s=1 then niches_nihtb=1;
	if nm=1 then output;
run;
/*
proc summary data=niches.nest_merge_tb_rc print; var _numeric_; run;
proc summary data=redcap_parent print; var _numeric_; run;
*/
