/***************************************************************************
 * this macro creates SAS data sets from a SAS matrix catalog file.
 *
 * lib_in  -- is the libref where the SAS matrix catalog file resides.
 *
 * mat_cat -- is the matrix catalog name (without the ".sas7bcat").
 *             this  macro will create data set names that have the
 *             naming convention of "matrix_catalog_name_matrix_name.sas7bdat"
 *             Like for example the matrix catalog file "w4n808.sas7bcat"
 *             containing a matrix named "adj_id" will create the SAS data set:
 *              "w4n808_adj_id.sas7bdat"
 *
 * lib_out -- is the libref where you want the SAS data sets to go.
 *
 *
 * Example use:
 * ---------------------------------------------------------------------------
 *  libname lib_in v9 "C:\wherever your matrix_catalog.sas7bcat file is\";
 *  libname lib_out v9 "C:\wherever you want your data sets stored\";
 *
 *  %include"C:\wherever you put mat2dat.sas";
 *  *%mat2dat(libname where sas7bcat file is,name of sas7bcat file,libname where you want to create SAS datasets of all the matrices);
 *
 *  %mat2dat(lib_in,matrix_catalog,lib_out);
 * ---------------------------------------------------------------------------
 *
 * Programmer: Dan Blanchette   dan_blanchette@unc.edu
 *             The Carolina Population Center at The University of North Carolina at Chapel Hill
 * Developed at:
 *             Research Computing, UNC-CH
 * date: 10Jul2008
 * modified: 12Mar2009 - made macro vars all local
***************************************************************************/

%macro mat2dat(lib_in,mat_cat,lib_out); 
 %local all_matrices count i n_obs notes word ;

 %let notes = %sysfunc(getoption(notes));
 options nonotes;

 ods output iml.show=matrices;
 proc iml;
  reset storage=&lib_in..&mat_cat.;
  show storage;
 quit;
 ods output close;
 
 data matrices;
  set matrices;
  retain start count 0;
  %** if no matrices are listed then the list is done **;
  if start = 1 and compress(batch) = "" then start = 0;
  if start = 1 then do;
    count = count+1;
    call symput("n_obs",compress(put(count,8.0)));
    output;
  end;
  if index(upcase(batch),"MATRICES") = 1 then start = 1;
 run;

 
 %let all_matrices=;
 data _null_;
  set matrices;
 %do i = 1 %to &n_obs.;
   %local batch&i.;
   if _n_ = &i. then call symput("batch&i.",trim(batch));
 %end;
 run;

 %do i = 1 %to &n_obs.;
   %let all_matrices=&all_matrices. &&batch&i..;
 %end;
 
 %let count=1;
 %** %qscan is a macro function that returns the Nth word from a string using **;
  %*  whatever delimiter you want.  Here &count.=1 and %str( ) specifies to **;
  %*  use a space as a delimiter.  Yes, this is obtuse!  **;
 %let word=%cmpres(%qscan(&all_matrices.,&count.,%str( )));
 %local matrix1;
 %let matrix1=&word.;
 %do %while(&word. ne);
    %let count=%eval(&count.+1);
    %let word=%cmpres(%qscan(&all_matrices.,&count.,%str( )));
    %local matrix&count.;
    %let matrix&count.=&word.;
 %end;
 %let count=%eval(&count.-1);
 
 options &notes.; 
 %put;
 %put Matrices being processed: ;
 %put -----------------------;
 %do i = 1 %to &count.;
   %put matrix &i. = &&matrix&i..;
 %end;
 %put -----------------------;
 %put;
 options nonotes; 

 proc iml;
  reset storage=&lib_in..&mat_cat.;
  load  
    %do i = 1 %to &count.;
      &&matrix&i..
    %end;
    ;;;

  %do i = 1 %to &count.;
    create &lib_out..&mat_cat._&&matrix&i..
     from &&matrix&i..;
    append from &&matrix&i..;
    close &lib_out..&mat_cat._&&matrix&i..;
  %end;
 quit;

 %let all_matrices=;
 %do i = 1 %to &count.;
   %let all_matrices = &all_matrices. &&matrix&i..;
 %end;

 options &notes.; 
 %put ;
 %put These are the matrices that are in &mat_cat..sas7bcat ;
 %put ---------------------------------------------------------------------;
 %put &all_matrices.;
 %put ---------------------------------------------------------------------;
 %put ;
 
%mend mat2dat;
