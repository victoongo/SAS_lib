* pick one with highest cout of d by b and c ;
%macro reshape_wide(inname,outname,bylst,idv,vlst);
	proc sort data=&inname.; by &bylst.; run;
	%if &vlst.~= %then						
	%do i=1 %to %sysfunc(countw(&vlst.));
		%let vi=%scan(&vlst.,&i.);
		proc transpose data=&inname.(keep=&bylst. &idv. &vi.) out=outt(drop=_name_) prefix=&vi._;
			var &vi.;
			by &bylst.;
			id &idv.;
		run;
		proc sort data=outt; by &bylst.; run;
		%if &i.=1 %then 
		%do;
		data &outname.;
			set outt;
		run;
		%end;
		%if &i.~=1 %then 
		%do;
		data &outname.;
			merge &outname. outt;
			by &bylst;
		run;
		%end;
	%end;
%mend;
%reshape_wide(scoredata,scoredata_w,form nest_id,pc,&scores.)

%macro lst_post(vlst,lstname,post_lst);
	%global &lstname.;
	%let &lstname.=;
	%if &vlst.~= %then						
	%do i=1 %to %sysfunc(countw(&vlst.));
		%let vi=%scan(&vlst.,&i.);
		%do j=1 %to %sysfunc(countw(&post_lst.));
			%let posti=%scan(&post_lst.,&j.);
			%let &lstname.=&&&lstname.. &vi._&posti.;
		%end;
	%end;
%mend;
%lst_post(&scores.,pcscores,parent child)
%put &pcscores.;
%reshape_wide(scoredata_w,scoredata_ww,nest_id,form,&pcscores.)
