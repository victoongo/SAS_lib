data nest_merge;
	set nihtb.nest_merge;
	if niches_nihtb=1 or redcap_parent=1 then output;
run;
proc contents data=nest_merge; run;
proc freq data=nest_merge; tables smoker; run;
proc means data=nest_merge; class smoker; vars es0_pa_:; run;
proc means data=nest_merge; class smoker; vars ful_adj_child:; run;
