x 'cd U:\ExportedData\NIHTB';
%include "D:\dropbox\projects\sas_lib\all_macros.sas";
%csvtosas('FBFF68E1-8148-4D5E-AF5D-DB04E3C4FDF2_AssessmentScores.csv',nihtb.scoredata,3);
%csvtosas('FBFF68E1-8148-4D5E-AF5D-DB04E3C4FDF2_RegistrationData.csv',nihtb.registrationdata,3);
data nihtb.registrationdata; set nihtb.registrationdata(rename=(Column1=PIN CustomNumberField=nest_id)); run;
%csvtosas('FBFF68E1-8148-4D5E-AF5D-DB04E3C4FDF2_AssessmentData.csv',nihtb.rawdata,3);
data nihtb.rawdata; set nihtb.rawdata(rename=(inst=form)); run;
*%csvtosas('FBFF68E1-8148-4D5E-AF5D-DB04E3C4FDF2_PivotedAssessmentData.csv',nihtb.prawdata,3);

proc sort data=nihtb.scoredata out=scoredata; by PIN; run;
proc sort data=nihtb.registrationdata out=registrationdata; by PIN; run;
proc sort data=nihtb.rawdata out=rawdata; by PIN; run;

data registrationdata;
	set registrationdata(keep=PIN nest_id gender age race ethncty);
	if age>50 then age=.;
	pcage=1;
	if age>16 & age~=. then pcage=0;
run;
data scoredata;
	merge scoredata(rename=(computed_score=cmp_score
		unadjusted_scale_score=unadj_scl
		age_adjusted_scale_score=age_adj_scl
		national_percentile__age_adjust=pct_age_adj
		fully_adjusted_scale_score=ful_adj)) 
		registrationdata;
	by pin;
	if nest_id=9999 then delete;
	length form_s $32.;
	form_s='';
	if form='Cognition Crystallized Composite' then form_s='cog crst';
	if form='Cognition Early Childhood Composite' then form_s='cog early ch';
	if form='Cognition Fluid Composite' then form_s='cog fluid';
	if form='Cognition Total Composite Score' then form_s='cog total';
	if form='NIH TB Dimensional Change Card Sort Age 3+' then form_s='tb dccs 3';
	if form='NIH TB Flanker Inhibitory Control and Attn Age 3+' then form_s='tb fica 3';
	if form='NIH TB List Sorting Working Memory Age 7+' then form_s='tb lswm 7';
	if form='NIH TB Oral Reading Recognition ENG Age 7+' then form_s='tb orr en 7';
	if form='NIH TB Oral Reading Recognition SPA Age 7+' then form_s='tb orr sp 7';
	if form='NIH TB Pattern Comparison Process Speed 7+ v 1.1' then form_s='tb pcps 7 ';
	if form='NIH TB Picture Sequence Memory Age 3+' then form_s='tb psm 3';
	if form='NIH TB Picture Vocabulary Age 3+' then form_s='tb pv 3';
run;
data rawdata;
	merge rawdata registrationdata(keep=PIN nest_id);
	by pin;
	if nest_id=9999 then delete;
run;

%let use_data=rawdata;

%countof_c_by_b2(&use_data.,pin,form);
%countof_c_by_b2(&use_data.,nest_id,pin);
%indx_c_by_b(&use_data.,nest_id,pin)
%parent_ind(&use_data.)
proc sort data=tmpf1; by pin; run;
data pccheck;
	merge tmpf1 registrationdata;
	by pin;
	if nest_id=9999 then delete;
	if pc=. then pc=0;
	if pc~=pcage then dif=1;
	if age~=. & age<=16 & pc=0 then pc=1;
	if age=. & gender=1 & pc=0 then pc=1;
	if age=. & gender=2 & pc=0 then pc=.;
run;
proc sort data=pccheck; by gender; run;
proc freq data=pccheck; by gender; tables pc pcage; run;

proc sort data=pccheck; by nest_id pin; run;
proc sort data=&use_data.; by nest_id pin; run;
data &use_data.;
	merge pccheck &use_data.(rename=(pc=pcold));
	by nest_id pin;
run;
/*
proc sort data=&use_data.; by pc; run;
proc freq data=&use_data.;
	by pc;
	tables form;
	output out=form_count n;
run;
*/
proc sort data=&use_data.; by pc; run;
proc summary data=&use_data. print;
	var countof_form_by_pin;
	by pc;
run;
proc sort data=&use_data.; by pin; run;
data temp_sum;
	set &use_data.(keep=nest_id pin countof_pin_by_nest_id countof_form_by_pin indx_pin_by_nest_id pc);
	by pin;
	if first.pin then output;
run;
proc sort data=temp_sum; by nest_id pin; run;
proc freq data=temp_sum; tables countof_pin_by_nest_id countof_form_by_pin; run;
proc sort data=temp_sum; by pc; run;
proc freq data=temp_sum; tables countof_form_by_pin; by pc; run;
data pc;
	set temp_sum(keep=pin pc);
run;
proc sort data=pc; by pin; run;
proc sort data=scoredata; by pin; run;
data scoredata;
	merge scoredata pc;
	by pin;
run;



%let use_data=scoredata;
%let scores=cmp_score unadj_scl age_adj_scl pct_age_adj ful_adj;
%countof_c_by_b2(&use_data.,nest_id,pin);
%countof_c_by_b2(&use_data.,pin,form);
%indx_c_by_b(&use_data.,nest_id,pin)
%pick_high(scoredata,pc,nest_id,pin,countof_form_by_pin)

proc format;
	value pc_ 0='parent' 1='child';
run;
data scoredata(rename=(gender=tb_gender age=tb_age race=tb_race ethncty=tb_ethncty));
	set scoredata(keep=nest_id pin pc gender age race ethncty form form_s &scores.);
	if form='' then delete;
	if computed_score=-99 then computed_score=.;
	*if pc=. then pc=0;
	if pc=. then delete;
	format pc pc_.;
run;
proc sort data=scoredata; by form pc; run;
proc summary data=scoredata print;
	var &scores.;
	class form pc;
	*output out=sumout n= nmiss= mean= std= min= max= / autoname;
run;
proc sort data=scoredata; by pin form; run;
data scoredata;
	set scoredata;
	by pin form;
	if first.form then output;
run;
proc sort data=scoredata; by form nest_id pc; run;
proc transpose data=scoredata out=scoredata_t(rename=(_NAME_=score_type));
	var &scores. tb_age tb_gender tb_race tb_ethncty;
	by form nest_id;
	id pc;
run;
proc sort data=scoredata_t; by form score_type; run;
proc corr data=scoredata_t pearson /*spearman kendall hoeffding*/
		/*plots=matrix(histogram)*/ ;
	var parent child;
	by form score_type;
	ods output PearsonCorr=pearsoncorr; 
run;
data pearsoncorr(drop=variable parent pparent rename=(child=pearson_pc pchild=pvalue));
	set pearsoncorr;
	if variable='child' | parent=. | child=. then delete;
run;
proc print data=pearsoncorr; run;


%reshape_wide(scoredata,scoredata_w,form_s nest_id,pc,&scores. tb_age tb_gender tb_race tb_ethncty)
%lst_post(&scores.,pcscores,parent child)
%put &pcscores.;
%reshape_wide(scoredata_w,scoredata_ww,nest_id,form_s,&pcscores.)

proc sort data=scoredata_w; by nest_id descending tb_age_child; run;
data scoredata_w_demo;
	set scoredata_w(keep=nest_id tb_gender: tb_age: tb_race: tb_ethncty:);
	by nest_id;
	if first.nest_id then output;
run;

data scoredata_ww;
	merge scoredata_w_demo scoredata_ww;
	by nest_id;
run;

data nihtb.scoredata_ww;
	set scoredata_ww(rename=(nest_id=nestid));
run;

proc sort data=nihtb.scoredata_ww out=scoredata_ww; by nestid; run;
proc sort data=nihtb.nest_i_ii_sr_merge_05aug14 out=nest_merge; by nestid; run;
data nihtb.nest_merge_tb;
	merge scoredata_ww(in=s) nest_merge;
	by nestid;
	if s=1 then niches_nihtb=1;
run;
proc freq data=nest_merge; tables niches_nihtb; run;


