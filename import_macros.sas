* macro to import csv with varnames not in first row to sas;
%macro csvtosas(inputfile,outputfile,firstobs);
	filename exTemp1 temp;
	data _null_;
	infile &inputfile. firstobs=&firstobs.;
		file exTemp1;
		input;
		put _infile_;
	run;
	proc import datafile=exTemp1
				dbms=csv replace out=tempoutputfile;
		*datarow=4;
		delimiter=',';
		getnames=yes;
		guessingrows=32767;
	run;
	%chrtonum(tempoutputfile,&outputfile.)
%mend;
