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

* add postfix to the end of the variables in a list ;
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

* add prefix to the end of the variables in a list ;
%macro lst_pre(vlst,lstname,pre_lst);
	%global &lstname.;
	%let &lstname.=;
	%if &vlst.~= %then						
	%do i=1 %to %sysfunc(countw(&vlst.));
		%let vi=%scan(&vlst.,&i.);
		%do j=1 %to %sysfunc(countw(&pre_lst.));
			%let prei=%scan(&pre_lst.,&j.);
			%let &lstname.=&&&lstname.. &prei._&vi.;
		%end;
	%end;
%mend;

* rename by adding prefix to the beginning of the variables in a list ;
%macro lst_rename(vlst,lstname,pre_lst);
	%global &lstname.;
	%let &lstname.=;
	%if &vlst.~= %then						
	%do i=1 %to %sysfunc(countw(&vlst.));
		%let vi=%scan(&vlst.,&i.);
		%do j=1 %to %sysfunc(countw(&pre_lst.));
			%let prei=%scan(&pre_lst.,&j.);
			%let &lstname.=&&&lstname.. &vi.=&prei._&vi.;
		%end;
	%end;
%mend;
