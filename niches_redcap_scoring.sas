* BASC134 (1-4) recode to (0-3); 
%let basc_hy = basc005 basc017 basc027 basc033 basc045 basc055 basc061 basc083 basc089 basc111 basc117;
%let basc_hy = basc005 basc017 basc027 basc033 basc045 basc055 basc061 basc083 basc089 basc111 basc117;
%let basc_ag = basc012 basc018 basc021 basc040 basc046 basc049 basc068 basc074 basc077 basc096 basc124;
%let basc_ax = basc020 basc023 basc028 basc035 basc048 basc051 basc056 basc063 basc076 basc091 basc104 basc119 basc132;
%let basc_dp = basc014 basc016 basc022 basc024 basc042 basc044 basc050 basc052 basc072 basc100 basc128;
%let basc_sm = basc003 basc010 basc013 basc025 basc031 basc038 basc041 basc053 basc066 basc081 basc094 basc109 basc122;
%let basc_at = basc008 basc036 basc064 basc070 basc073 basc092 basc098 basc101 basc120 basc126;
%let basc_wd = basc009 basc026 basc037 basc054r basc065 basc078 basc082 basc093r basc106 basc110 basc134r;
%let basc_ap = basc006 basc034r basc062r basc080r basc090 basc108r;
%let basc_ad = basc001 basc029 basc057 basc069 basc085 basc097 basc113 basc125;
%let basc_ss = basc004 basc019 basc032 basc047 basc060 basc075 basc088 basc103 basc116;
%let basc_dl = basc039 basc059r basc067r basc087r basc095r basc102r basc115r basc123r basc130r;
%let basc_fc = basc002r basc015 basc030 basc043 basc058 basc071 basc086 basc099 basc105 basc114 basc133r;

%let basc_sub_scales = basc_hy basc_hy basc_ag basc_ax basc_dp basc_sm basc_at basc_wd basc_ap basc_ad basc_ss basc_dl basc_fc;

* BRIEF63 (1-3) norecode;
%let brief_in = brief03 brief08 brief13 brief18 brief23 brief28 brief33 brief38 brief43 brief48 brief52 brief54 brief56 brief58 brief60 brief62;
%let brief_sf = brief05 brief10 brief15 brief20 brief25 brief30 brief35 brief40 brief45 brief50;
%let brief_ec = brief01 brief06 brief11 brief16 brief21 brief26 brief31 brief36 brief41 brief46;
%let brief_wm = brief02 brief07 brief12 brief17 brief22 brief27 brief32 brief37 brief42 brief47 brief51 brief53 brief55 brief57 brief59 brief61 brief63;
%let brief_po = brief04 brief09 brief14 brief19 brief24 brief29 brief34 brief39 brief44 brief49;

%let brief_isci = brief_in brief_ec;
%let brief_fi = brief_sf brief_ec;
%let brief_emi = brief_wm brief_po;
%let brief_gec = brief_in brief_sf brief_ec brief_wm brief_po;

%let brief_sub_scales = brief_in brief_sf brief_ec brief_wm brief_po; 
%let brief_scales = brief_isci brief_fi brief_emi brief_gec;

* CAARS30 (1-4) recode to (0-3);
%let caars_is = caars01 caars09 caars13 caars14 caars19 caars21 caars26 caars29 caars30; 
%let caars_hs = caars02 caars04 caars06 caars08 caars16 caars18 caars22 caars25 caars27; 
%let caars_ai = caars03 caars05 caars07 caars10 caars11 caars12 caars15 caars17 caars20 caars23 caars24 caars28; 

%let caars_ast = caars_is caars_hs; 

%let caars_sub_scales = caars_is caars_hs caars_ai;
%let caars_scales = caars_ast;

* SWAN30 (1-7) norecode;
%let swan_in = swan01 - swan09; 
%let swan_hi = swan10 - swan18; 
%let swan_tmp = swan19 - swan30; 

%let swan_sum = swan_in swan_hi; 

%let swan_sub_scales = swan_in swan_hi swan_tmp;
%let swan_scales = swan_sum;

* SDQ25 [age 3/4] (1-3) recode to (0-2);
%let sdq_es = sdq03 sdq08 sdq13 sdq16 sdq24; 
%let sdq_cp = sdq05 sdq07 sdq12 sdq18 sdq22; 
%let sdq_ha = sdq02 sdq10 sdq15 sdq21 sdq25; 
%let sdq_pp = sdq06 sdq11 sdq14 sdq19 sdq23; 
%let sdq_ps = sdq01 sdq04 sdq09 sdq17 sdq20; 

%let sdq_td = sdq_es sdq_cp sdq_ha sdq_pp sdq_ps; 

%let sdq_sub_scales = sdq_es sdq_cp sdq_ha sdq_pp sdq_ps;
%let sdq_scales = sdq_td;

* PSI36 (1-5) recode to (5-1);
%let psi_pd = psi01 - psi12; 
%let psi_pcdi = psi09 psi13 - psi26 psi28 psi30 psi33 psi35 psi36; 
%let psi_dc = psi14 psi17 psi26 - psi36; 
%let psi_ts = psi01 - psi36; 

%let psi_sub_scales = psi_pd psi_pcdi psi_dc psi_ts;

* PSY31(1-8) uses a count scoring pattern ;

* psdgs32 (1-5 norecode) ;
%let psdqs_av = psdqs01 psdqs03 psdqs05 psdqs07 psdqs09 psdqs11 psdqs12 psdqs14 psdqs18 psdqs21 psdqs22 psdqs25 psdqs27 psdqs29 psdqs31;
%let psdqs_an = psdqs02 psdqs04 psdqs06 psdqs10 psdqs13 psdqs16 psdqs19 psdqs23 psdqs26 psdqs28 psdqs30 psdqs32;
%let psdqs_pm = psdqs08 psdqs15 psdqs17 psdqs20 psdqs24;

%let psdqs_sub_scales = psdqs_av psdqs_an psdqs_pm;

* psdgo32 (1-5 norecode) ;
%let psdqo_av = psdqo01 psdqo03 psdqo05 psdqo07 psdqo09 psdqo11 psdqo12 psdqo14 psdqo18 psdqo21 psdqo22 psdqo25 psdqo27 psdqo29 psdqo31;
%let psdqo_an = psdqo02 psdqo04 psdqo06 psdqo10 psdqo13 psdqo16 psdqo19 psdqo23 psdqo26 psdqo28 psdqo30 psdqo32;
%let psdqo_pm = psdqo08 psdqo15 psdqo17 psdqo20 psdqo24;

%let psdqo_sub_scales = psdqo_av psdqo_an psdqo_pm;

* smoke shs psy; 
