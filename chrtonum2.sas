%macro chrtonum2(inputfile,outputfile);
	data one;
		set &inputfile.;
		fakenum=1; *added in case no num var in the data. dropped in the end;
	run;
	data one_t;
		length type $1. allnames $32;
		drop dsid i num ;
		dsid=open("work.one","i");
		num=attrn(dsid,"nvars");
		do i=1 to num; *num is the number of vars;
			type= vartype(dsid,i);
			allnames=varname(dsid,i);
			output;
		end;
	run;

	data one_u_char one_u_num(rename=(allnames=name3));
		set one_t;
		if type='C' then output one_u_char;
		else if type='N' then output one_u_num;
		drop type; 
	run;

	data _null_;
		call symput('obs',obs);
		set one_u_char nobs=obs;
		stop; run;

	data _null_;
		call symput('f',obs);
		set one nobs=obs;
		stop; run;

	data one_b;
		set one_u_char;
		name1=allnames;
		name2='g'||strip(_N_);
		drop allnames;
	run;
	proc contents data=one noprint out= contents ; run;
	proc sort data=contents; by varnum; run;
	proc sql noprint;
		select name
		into : allnames separated by ','
		from contents;
		select name1, name2
		into : name1 separated by ' ',
		: name2 separated by ' '
		from one_b;
		select name3
		into : name3 separated by ' '
		from one_u_num;

	data two;
		set one(drop=&name3); 
		%let d=&obs; *&obs which has # of character variables in the data set;
		array xxx(&obs) $ &name1; /*array of all character variables*/
		array yyy(&obs) y1-y&d; /*sequential flags for each variable */
		do I=1 to &obs;
		if anyalpha(xxx(I))=0 then yyy(I)=1;
		else yyy(I)=0;
		end; drop I; run;

	proc transpose data=two out=three; run;

	data four(keep=flag);
		set three;
		%let g=&f; *&f has # of obs in the original data set;
		if sum(of col1-col&g)=&g then flag=1;
		else flag=0;

	proc sql noprint;
		select flag
		into :flag separated by ' '
		from four;
		quit;
	%macro tty;
		data one_e;
		set one;
		%do I=1 %to &obs;
		%if %scan(&flag,&I,' ')=1 %then %do;
		%scan(&name2,&I,' ')=0;
		%scan(&name2,&I,' ')=input(%scan(&name1,&I,' '),4.);
		%end;
		%else
		%if %scan(&flag,&I,' ')=0 %then %do;
		%scan(&name2,&I,' ')=%scan(&name1,&I,' ');
		%end;
		%end;
		drop &name1;
	run;
	%mend tty;
	%tty;
	%macro trtr;
		rename
		%do I=1 %to &obs;
		%scan(&name2,&I,' ')=%scan(&name1,&I,' ')
		%end;
		;
		run;
	%mend trtr;
	data fin1;
		set one_e ;
		%trtr;
		run;
	proc sql;
		create table &outputfile. as
		select &allnames
		from fin1;
		quit;
	data &outputfile.;
		set &outputfile.(drop=fakenum);
	run;
%mend;
