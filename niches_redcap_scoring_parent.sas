* BASC134 (1-4) recode to (0-3); 
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

%let basc_ext = basc_hy basc_ag;
%let basc_int = basc_ax basc_dp basc_sm;
%let basc_bsi = basc_at basc_wd basc_ap basc_dp basc_ag basc_hy;
%let basc_ada = basc_ad basc_ss basc_dl basc_fc;
%let basc_aphy = basc_ap basc_hy;

%let basc_sub_scales = basc_hy basc_ag basc_ax basc_dp basc_sm basc_at basc_wd basc_ap basc_ad basc_ss basc_dl basc_fc;
%let basc_scales = basc_ext basc_int basc_bsi basc_ada basc_aphy;

* SBASC160 (1-4) recode to (0-3); 
%let sbasc_hy = sbasc6 sbasc20 sbasc38 sbasc52 sbasc70 sbasc84 sbasc102 sbasc116 sbasc134 sbasc148;
%let sbasc_ag = sbasc8 sbasc24 sbasc26 sbasc40 sbasc56 sbasc58 sbasc72 sbasc88 sbasc90 sbasc104 sbasc136;
%let sbasc_cp = sbasc15 sbasc29 sbasc47 sbasc61 sbasc79 sbasc93 sbasc111 sbasc125 sbasc157;
%let sbasc_ax = sbasc5 sbasc12 sbasc13 sbasc32 sbasc37 sbasc44 sbasc45 sbasc64 sbasc69 sbasc77 sbasc101 sbasc109 sbasc133 sbasc141;
%let sbasc_dp = sbasc10 sbasc18 sbasc28 sbasc42 sbasc50 sbasc60 sbasc74 sbasc82 sbasc92 sbasc106 sbasc114 sbasc124 sbasc138 sbasc156;
%let sbasc_sm = sbasc30 sbasc54 sbasc59 sbasc62 sbasc86 sbasc91 sbasc94 sbasc118 sbasc123 sbasc126 sbasc150 sbasc158;
%let sbasc_at = sbasc11 sbasc23 sbasc43 sbasc55 sbasc75 sbasc87 sbasc96 sbasc107 sbasc119 sbasc128 sbasc139 sbasc151 sbasc160;
%let sbasc_wd = sbasc16r sbasc21 sbasc25 sbasc48 sbasc53 sbasc57 sbasc80r sbasc89 sbasc112 sbasc121 sbasc144 sbasc153;
%let sbasc_ap = sbasc9 sbasc17r sbasc41r sbasc49r sbasc73 sbasc105r;
%let sbasc_ad = sbasc1 sbasc14 sbasc33 sbasc46 sbasc65 sbasc78 sbasc110 sbasc142r;
%let sbasc_ss = sbasc31 sbasc63 sbasc85 sbasc95 sbasc117 sbasc127 sbasc149 sbasc159;
%let sbasc_ld = sbasc4 sbasc19 sbasc36 sbasc51 sbasc68 sbasc83 sbasc100 sbasc132;
%let sbasc_dl = sbasc3r sbasc35 sbasc39 sbasc67 sbasc71 sbasc99 sbasc103r sbasc131r;
%let sbasc_fc = sbasc34 sbasc66r sbasc76 sbasc81r sbasc98r sbasc108 sbasc113 sbasc122 sbasc130 sbasc140 sbasc145r sbasc154;

%let sbasc_ext = sbasc_hy sbasc_ag sbasc_cp;
%let sbasc_int = sbasc_ax sbasc_dp sbasc_sm;
%let sbasc_bsi = sbasc_at sbasc_wd sbasc_ap sbasc_dp sbasc_ag sbasc_hy;
%let sbasc_ada = sbasc_ad sbasc_ss sbasc_ld sbasc_dl sbasc_fc;
%let sbasc_aphy = sbasc_ap sbasc_hy;

%let sbasc_sub_scales = sbasc_hy sbasc_ag sbasc_cp sbasc_ax sbasc_dp sbasc_sm sbasc_at sbasc_wd sbasc_ap sbasc_ad sbasc_ss sbasc_ld sbasc_dl sbasc_fc;
%let sbasc_scales = sbasc_ext sbasc_int sbasc_bsi sbasc_ada sbasc_aphy;


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

* SBRIEF86 (1-3) norecode;
%let sbrief_in = sbrief38 sbrief41 sbrief43 sbrief44 sbrief49 sbrief54 sbrief55 sbrief56 sbrief59 sbrief65;
%let sbrief_sf = sbrief5 sbrief6 sbrief8 sbrief12 sbrief13 sbrief23 sbrief30 sbrief39;
%let sbrief_ec = sbrief7 sbrief20 sbrief25 sbrief26 sbrief50 sbrief62 sbrief64 sbrief70;
%let sbrief_it = sbrief3 sbrief10 sbrief16 sbrief47 sbrief48 sbrief61  sbrief66 sbrief71;
%let sbrief_wm = sbrief2 sbrief9 sbrief17 sbrief19 sbrief24 sbrief27 sbrief32 sbrief33 sbrief37 sbrief57;
%let sbrief_po = sbrief11 sbrief15 sbrief18 sbrief22 sbrief28 sbrief35 sbrief36 sbrief40 sbrief46 sbrief51 sbrief53 sbrief58;
%let sbrief_om = sbrief4 sbrief29 sbrief67 sbrief68 sbrief69 sbrief72;
%let sbrief_mo = sbrief14 sbrief21 sbrief31 sbrief34 sbrief41 sbrief52 sbrief60 sbrief63;

%let sbrief_bri = sbrief_in sbrief_sf sbrief_ec;
%let sbrief_mi  = sbrief_wm sbrief_po sbrief_it sbrief_om sbrief_mo;
%let sbrief_gec = sbrief_bri sbrief_mi;

%let sbrief_sub_scales = sbrief_in sbrief_sf sbrief_ec sbrief_it sbrief_wm sbrief_po sbrief_om sbrief_mo; 
%let sbrief_scales = sbrief_bri sbrief_mi sbrief_gec;


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
%let ssdq_cp = sdq05 sdq07 sdq12 sdq26 sdq27; 
%let sdq_ha = sdq02 sdq10 sdq15 sdq21 sdq25; 
%let sdq_pp = sdq06 sdq11 sdq14 sdq19 sdq23; 
%let sdq_ps = sdq01 sdq04 sdq09 sdq17 sdq20; 

%let sdq_td = sdq_es sdq_cp sdq_ha sdq_pp sdq_ps; 
%let ssdq_td = sdq_es ssdq_cp sdq_ha sdq_pp sdq_ps; 

%let sdq_sub_scales = sdq_es sdq_cp ssdq_cp sdq_ha sdq_pp sdq_ps;
%let sdq_scales = sdq_td ssdq_td;

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
