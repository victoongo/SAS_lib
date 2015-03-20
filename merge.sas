%macro getvars(dsn,vlist);
 %global &vlist.;
 proc sql noprint;
 select name into :&vlist. separated by ' '
  from dictionary.columns
  where libname='WORK' and memname=upcase("&dsn");
 quit;
%mend;

%macro countvars(dsn);
	proc sql;
		select count(name) as n_vars_&dsn. from dictionary.columns
			where libname='WORK' and memname=upcase("&dsn");
	quit;
%mend;

%macro dupvars(d1,d2);
	proc sql noprint;
		create table dn1 as
			select name from dictionary.columns
				where libname='WORK' and memname=upcase("&d1");
		create table dn2 as
			select name from dictionary.columns
				where libname='WORK' and memname=upcase("&d2");
		create table dn as
			select * from dn1 inner join dn2
				on dn1.name = dn2.name;
	quit;
	proc print data=dn; run;
%mend;
