data nest_merge;
	set nihtb.nest_merge;
	smoker_b=smoker;
	if smoker=2 then smoker_b=1;
	es0_pa_basc_hyap=(es0_pa_basc_hy + es0_pa_basc_ap) / 2;
	if niches_nihtb=1 or redcap_parent=1 then output;
run;
proc contents data=nest_merge; run;
proc freq data=nest_merge; tables smoker_b; run;
proc means data=nest_merge; class smoker_b; vars es0_pa_:; run;
proc means data=nest_merge; class smoker; vars ful_adj_child:; run;


proc means data=nest_merge; class smoker_b; vars es0_pa_basc_hy es0_pa_basc_ap es0_pa_brief_gec; run;
proc means data=nest_merge; class maternal_smoking2; vars es0_pa_basc_hy es0_pa_basc_ap es0_pa_basc_hyap es0_pa_brief_gec; run;
proc means data=nest_merge; 
	class smoker_b; 
	vars age_adj_scl_child_tb_dccs_3 age_adj_scl_child_tb_fica_3 age_adj_scl_parent_tb_dccs_3 age_adj_scl_parent_tb_fica_3; 
run;
proc means data=nest_merge; 
	class maternal_smoking2; 
	vars age_adj_scl_child_tb_dccs_3 age_adj_scl_child_tb_fica_3 age_adj_scl_parent_tb_dccs_3 age_adj_scl_parent_tb_fica_3; 
run;

proc glm data=nest_merge; 
	class maternal_smoking2 race_final; 
	model age_adj_scl_child_tb_dccs_3_glm = maternal_smoking2 baby_gender race_final; 
	lsmeans maternal_smoking2; 
run;



data redcap;
	set nihtb.nest_merge;
	smoker_b=smoker;
	if smoker=2 then smoker_b=1;
	if niches_nihtb=1 or redcap_parent=1 then output;
run;

proc means data=redcap; vars brief:; run;
proc means data=redcap; vars; run;
proc means data=redcap; vars smoke:; run;
proc freq data=redcap; tables shs:; run;

proc freq data=redcap; tables smoke03 ; run;
