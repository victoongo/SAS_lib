/***************************************************************************
 * this macro creates a SAS matrix catalog file from SAS data sets that you 
 *  created with the mat2dat SAS macro.
 *
 * lib_in  -- is the libref where the SAS data sets reside.
 *
 * matrix_catalog -- is the matrix catalog name (without the ".sas7bcat")
 *             that will be created.  This macro is expecting data set names 
 *             that have the naming convention of 
 *               "matrix_catalog_name_matrix_name.sas7bdat"
 *             like for example the SAS data set named:
 *              "w4n808_adj_id.sas7bdat"
 *             will create the matrix catalog file "w4n808.sas7bcat"
 *             with a matrix named "adj_id".
 *
 * lib_out -- is the libref where the SAS matrix catalog file is going to be 
 *             stored.
 *
 * Example use:
 * ---------------------------------------------------------------------------
 *  libname lib_in v9 "C:\wherever your matrix_data file(s) is\";
 *  libname lib_out v9 "C:\wherever you want your matrix catalog file to be saved\";
 *
 *  %include"C:\wherever you put dat2mat.sas\dat2mat.sas";
 *
 *  *dat2mat(libname where SAS data sets are located, name of matrix catalog file, libname
 *    where you want new matrix catalog file to go, list of all matrices to go in the catalog);
 *  %dat2mat(lib_in,matrix_catalog,lib, mat1 mat2 mat3);
 * ---------------------------------------------------------------------------
 *
 *
 * Programmer: Dan Blanchette   dan_blanchette@unc.edu
 *             The Carolina Population Center at The University of North Carolina at Chapel Hill
 * Developed at:
 *             Research Computing, UNC-CH
 * date: 10Jul2008
 * modified: 12Mar2009 - cleaned up code a bit
***************************************************************************/


%macro dat2mat(lib_in,mat_cat,lib_out,matrices);
 %local all_matrices i j n_dsets notes;

 %let notes = %sysfunc(getoption(notes));
 options nonotes;
 ** find out what the matrices are that need to be processed **;
 data vmember;
  set sashelp.vmember;
   retain count 0;
   if upcase(libname)=upcase("&lib_in.")
    and upcase(memtype)="DATA"  
     and trim(upcase(substr(memname,1,length("&mat_cat._")))) = upcase("&mat_cat._")
      then do;
       count = count + 1;
       call symput("n_dsets",compress(put(count,8.0)));
       output;  
      end;
 run;

 data _null_;
  set vmember end= lastobs;
  memname = trim(upcase(substr(memname,length("&mat_cat._")+1,length(memname))));
   %do i =1 %to &n_dsets.;
     %local matrix&i.;
     if _n_ = &i. 
       %if &matrices. ^=  %then %do;
         and memname in(%sysfunc(tranwrd("%upcase(&matrices.)",%nrstr( ),","))) 
       %end;
      then do;
       call symput("matrix&i.",memname);
     end;
   %end;
 run;

   %let all_matrices =;
 
   options &notes.;
   %put ;
   %put ---------------------------------------------------------------------------;
   %put This is a list of matrices to be created in &mat_cat..sas7bcat ;
   %let j = 1;
   %do i =1 %to &n_dsets.;
     %if &&matrix&i.. ^=  %then %do;
       %put matrix &j. = &&matrix&i..;
       %let all_matrices =&all_matrices. &&matrix&i..;
       %let j = %eval(&j. + 1);
     %end;
   %end;
   %put ---------------------------------------------------------------------------;
   %put ;
  
  options nonotes; 
  %** load SAS dataset into a matrix **;
  proc iml;
    %do i = 1 %to &n_dsets.; 
      %if &&matrix&i.. ^=  %then %do;
       use &lib_in..&mat_cat._&&matrix&i..;
       read all var _num_ into &&matrix&i..;
      %end;
    %end;
    reset storage=&lib_out..&mat_cat.;
    store 
     %do i = 1 %to &n_dsets.; 
       %if &&matrix&i.. ^=  %then %do;
         &&matrix&i..
       %end;
     %end;
    ;
  quit;

  
  title This is a list of all matrices now stored in &lib_out..&mat_cat. : ;
  proc iml;
    reset storage = &lib_out..&mat_cat.;
    show storage;
  quit;
  title;

  options &notes.;
  
%mend dat2mat;

