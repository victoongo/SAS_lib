
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
proc sort data=n1weight; by nestid mom_nestid ref_date; run;
proc sort data=n2weight; by nestid mom_nestid ref_date; run;
proc sort data=n1height; by nestid mom_nestid ref_date; run;
proc sort data=n2height; by nestid mom_nestid ref_date; run;

data mydata (keep=nestid mom_nestid final_child_dob ref_date weight height sex source agemos);
	merge n1weight n2weight n1height n2height;
	by nestid mom_nestid ref_date;
	agemos=(ref_date-final_child_dob)/30;
run;

libname refdir 'd:\dropbox\projects\sas_lib\';
%include 'd:\dropbox\projects\sas_lib\CDC-source-code.sas'; run

proc contents data=_cdcdata; run;
proc export data=_cdcdata outfile="D:\Projects\bmi\bmi.csv" dbms=csv replace; run;

*proc hlm data=vital_all;
*run;

