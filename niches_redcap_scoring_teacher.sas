* tbasc134 (1-4) recode to (0-3); 
%let tbasc_hy = tbasc11 tbasc15 tbasc18 tbasc36 tbasc40 tbasc43 tbasc61 tbasc68 tbasc93;
%let tbasc_ag = tbasc4 tbasc9 tbasc23 tbasc29 tbasc34 tbasc48 tbasc54 tbasc59 tbasc73 tbasc79 tbasc84;
%let tbasc_ax = tbasc8 tbasc22 tbasc30 tbasc33 tbasc47 tbasc55 tbasc72 tbasc80 tbasc97;
%let tbasc_dp = tbasc6 tbasc16 tbasc25 tbasc31 tbasc41 tbasc50 tbasc56 tbasc66 tbasc91;
%let tbasc_sm = tbasc7 tbasc14 tbasc19 tbasc32 tbasc39 tbasc44 tbasc57 tbasc69 tbasc82 tbasc94;
%let tbasc_at = tbasc10 tbasc35 tbasc49 tbasc60 tbasc65 tbasc74 tbasc85 tbasc90 tbasc99;
%let tbasc_wd = tbasc12 tbasc20 tbasc37 tbasc45 tbasc62 tbasc70 tbasc87r tbasc95;
%let tbasc_ap = tbasc3 tbasc28r tbasc53r tbasc75r tbasc78 tbasc100r;
%let tbasc_ad = tbasc1 tbasc21 tbasc26 tbasc46 tbasc51 tbasc71 tbasc96;
%let tbasc_ss = tbasc13 tbasc38 tbasc58 tbasc63 tbasc83 tbasc88;
%let tbasc_fc = tbasc2 tbasc17 tbasc27 tbasc42 tbasc52r tbasc64 tbasc67 tbasc77 tbasc89;

%let tbasc_ext = tbasc_hy tbasc_ag;
%let tbasc_int = tbasc_ax tbasc_dp tbasc_sm;
%let tbasc_bsi = tbasc_at tbasc_wd tbasc_ap tbasc_dp tbasc_ag tbasc_hy;
%let tbasc_ada = tbasc_ad tbasc_ss tbasc_fc;
%let tbasc_aphy = tbasc_ap tbasc_hy;

%let tbasc_sub_scales = tbasc_hy tbasc_ag tbasc_ax tbasc_dp tbasc_sm tbasc_at tbasc_wd tbasc_ap tbasc_ad tbasc_ss tbasc_fc;
%let tbasc_scales = tbasc_ext tbasc_int tbasc_bsi tbasc_ada tbasc_aphy;

* stbasc134 (1-4) recode to (0-3); 
%let stbasc_hy = stbasc010 stbasc018 stbasc026 stbasc038 stbasc046 stbasc054 stbasc066 stbasc074 stbasc094 stbasc102 stbasc122;
%let stbasc_ag = stbasc008 stbasc024 stbasc036 stbasc052 stbasc064 stbasc080 stbasc092 stbasc108 stbasc120 stbasc136;
%let stbasc_cp = stbasc014 stbasc028 stbasc042 stbasc056 stbasc070 stbasc084 stbasc098 stbasc112 stbasc126;
%let stbasc_ax = stbasc011 stbasc025 stbasc039 stbasc053 stbasc081 stbasc109 stbasc137;
%let stbasc_dp = stbasc009 stbasc012 stbasc037 stbasc040 stbasc049 stbasc068 stbasc077 stbasc096 stbasc105 stbasc124 stbasc133;
%let stbasc_sm = stbasc006 stbasc027 stbasc034 stbasc055 stbasc062 stbasc083 stbasc090 stbasc111 stbasc139;
%let stbasc_ap = stbasc005 stbasc033r stbasc044r stbasc061 stbasc072r stbasc100 stbasc128r;
%let stbasc_lp = stbasc020 stbasc048 stbasc076 stbasc082 stbasc104 stbasc110 stbasc132 stbasc138;
%let stbasc_at = stbasc023 stbasc051 stbasc065 stbasc067 stbasc079 stbasc093 stbasc095 stbasc107 stbasc121 stbasc123;
%let stbasc_wd = stbasc007 stbasc019 stbasc035r stbasc047 stbasc063r stbasc075 stbasc103 stbasc131;
%let stbasc_ad = stbasc001 stbasc013 stbasc029r stbasc041 stbasc057 stbasc069 stbasc085 stbasc113;
%let stbasc_ss = stbasc004 stbasc015 stbasc032 stbasc043 stbasc060 stbasc071 stbasc088 stbasc116;
%let stbasc_ld = stbasc002 stbasc030 stbasc058 stbasc086 stbasc089 stbasc117;
%let stbasc_st = stbasc017 stbasc045 stbasc073 stbasc091 stbasc101 stbasc119 stbasc129;
%let stbasc_fc = stbasc003 stbasc022 stbasc031 stbasc050r stbasc059r stbasc078 stbasc087r stbasc106 stbasc115 stbasc134;

%let stbasc_ext = stbasc_hy stbasc_ag stbasc_cp;
%let stbasc_int = stbasc_ax stbasc_dp stbasc_sm;
%let stbasc_sp = stbasc_lp stbasc_ap;
%let stbasc_bsi = stbasc_at stbasc_wd stbasc_ap stbasc_dp stbasc_ag stbasc_hy;
%let stbasc_ada = stbasc_ad stbasc_ss stbasc_ld stbasc_st stbasc_fc;
%let stbasc_aphy = stbasc_ap stbasc_hy;

%let stbasc_sub_scales = stbasc_hy stbasc_ag stbasc_cp stbasc_ax stbasc_dp stbasc_sm stbasc_ap stbasc_lp stbasc_at stbasc_wd stbasc_ad stbasc_ss stbasc_ld stbasc_st stbasc_fc;
%let stbasc_scales = stbasc_ext stbasc_int stbasc_sp stbasc_bsi stbasc_ada stbasc_aphy;

* tbrief63 (1-3) norecode;
%let tbrief_in = tbrief03 tbrief08 tbrief13 tbrief18 tbrief23 tbrief28 tbrief33 tbrief38 tbrief43 tbrief48 tbrief52 tbrief54 tbrief56 tbrief58 tbrief60 tbrief62;
%let tbrief_sf = tbrief05 tbrief10 tbrief15 tbrief20 tbrief25 tbrief30 tbrief35 tbrief40 tbrief45 tbrief50;
%let tbrief_ec = tbrief01 tbrief06 tbrief11 tbrief16 tbrief21 tbrief26 tbrief31 tbrief36 tbrief41 tbrief46;
%let tbrief_wm = tbrief02 tbrief07 tbrief12 tbrief17 tbrief22 tbrief27 tbrief32 tbrief37 tbrief42 tbrief47 tbrief51 tbrief53 tbrief55 tbrief57 tbrief59 tbrief61 tbrief63;
%let tbrief_po = tbrief04 tbrief09 tbrief14 tbrief19 tbrief24 tbrief29 tbrief34 tbrief39 tbrief44 tbrief49;

%let tbrief_isci = tbrief_in tbrief_ec;
%let tbrief_fi = tbrief_sf tbrief_ec;
%let tbrief_emi = tbrief_wm tbrief_po;
%let tbrief_gec = tbrief_in tbrief_sf tbrief_ec tbrief_wm tbrief_po;

%let tbrief_sub_scales = tbrief_in tbrief_sf tbrief_ec tbrief_wm tbrief_po; 
%let tbrief_scales = tbrief_isci tbrief_fi tbrief_emi tbrief_gec;

* stbrief63 (1-3) norecode;
%let stbrief_in = stbrief09 stbrief38 stbrief42 stbrief43 stbrief45 stbrief47 stbrief57 stbrief58 stbrief59 stbrief69;
%let stbrief_sf = stbrief04 stbrief05 stbrief06 stbrief13 stbrief14 stbrief24 stbrief30 stbrief40 stbrief53 stbrief62;
%let stbrief_ec = stbrief01 stbrief07 stbrief26 stbrief27 stbrief48 stbrief51 stbrief64 stbrief66 stbrief72;
%let stbrief_it = stbrief03 stbrief10 stbrief19 stbrief34 stbrief50 stbrief63 stbrief70;
%let stbrief_wm = stbrief02 stbrief08 stbrief18 stbrief21 stbrief25 stbrief28 stbrief31 stbrief32 stbrief39 stbrief60;
%let stbrief_po = stbrief12 stbrief17 stbrief23 stbrief29 stbrief35 stbrief37 stbrief41 stbrief49 stbrief52 stbrief56;
%let stbrief_om = stbrief11 stbrief16 stbrief20 stbrief67 stbrief68 stbrief71 stbrief73;
%let stbrief_mo = stbrief15 stbrief22 stbrief33 stbrief36 stbrief44 stbrief46 stbrief54 stbrief55 stbrief61 stbrief65;

%let stbrief_bri = stbrief_in stbrief_sf stbrief_ec;
%let stbrief_mi  = stbrief_wm stbrief_po stbrief_it stbrief_om stbrief_mo;
%let stbrief_gec = stbrief_bri stbrief_mi;

%let stbrief_sub_scales = stbrief_in stbrief_sf stbrief_ec stbrief_it stbrief_wm stbrief_po stbrief_om stbrief_mo; 
%let stbrief_scales = stbrief_bri stbrief_mi stbrief_gec;

* tswan30 (1-7) norecode;
%let tswan_in = tswan01 - tswan09; 
%let tswan_hi = tswan10 - tswan18; 
%let tswan_tmp = tswan19 - tswan30; 

%let tswan_sum = tswan_in tswan_hi; 

%let tswan_sub_scales = tswan_in tswan_hi tswan_tmp;
%let tswan_scales = tswan_sum;

* tsdq25 [age 3/4] (1-3) recode to (0-2);
%let tsdq_es = tsdq03 tsdq08 tsdq13 tsdq16 tsdq24; 
%let tsdq_cp = tsdq05 tsdq07 tsdq12 tsdq18 tsdq22; 
%let stsdq_cp = tsdq05 tsdq07 tsdq12 tsdq27 tsdq28; 
%let tsdq_ha = tsdq02 tsdq10 tsdq15 tsdq21 tsdq25; 
%let tsdq_pp = tsdq06 tsdq11 tsdq14 tsdq19 tsdq23; 
%let tsdq_ps = tsdq01 tsdq04 tsdq09 tsdq17 tsdq20; 

%let tsdq_td = tsdq_es tsdq_cp tsdq_ha tsdq_pp tsdq_ps; 
%let stsdq_td = tsdq_es stsdq_cp tsdq_ha tsdq_pp tsdq_ps; 

%let tsdq_sub_scales = tsdq_es tsdq_cp stsdq_cp tsdq_ha tsdq_pp tsdq_ps;
%let tsdq_scales = tsdq_td stsdq_td;
