tab job_pas, missing
tab leave_pas, missing
tab ssec_pas, missing
tab etyp_pas, missing
tab pas, missing

* Step 1 — Keep only working-age population in labour force
* pas codes 11,12,21,31,41,51 = in employment

gen worker = (pas=="11" | pas=="12" | pas=="21" | pas=="31" | pas=="41" | pas=="51")

* Step 2 — Regular salaried worker
gen regular_salaried = (pas=="31")

* Step 3 — Formal employment (written contract)
gen formal_contract = (job_pas=="1") if job_pas != ""

* Step 4 — Social protection (any benefit)
gen social_prot = (ssec_pas!="8" & ssec_pas!="9") if ssec_pas != ""

* Step 5 — Paid leave
gen paid_leave = (leave_pas=="1") if leave_pas != ""

* Step 6 — Gender
gen male = (sex=="1") if sex != ""

* Step 7 — Urban
gen urban = (sec=="2") if sec != ""

* Among workers with employment contract info only
* Does contract type predict social protection?

tab job_pas social_prot, row

tab job_pas paid_leave, row

tab leave_pas social_prot, row

* Gender differences
tab male social_prot, row

* Urban vs rural
tab urban social_prot, row


* Logistic regression — survey-weighted
svyset [pweight=mult], strata(strm) psu(mfsu)

svy: logit social_prot formal_contract male urban age i.gedu_lvl
* Education numeric for regression
destring gedu_lvl, gen(edu_num)
destring etyp_pas, gen(etyp_num)

* Full model with enterprise type controls
svy: logit social_prot formal_contract male urban age ///
     i.edu_num i.etyp_num

* Enterprise type vs social protection
tab etyp_pas social_prot, row

* Contract paradox -- private sector only
tab job_pas social_prot if etyp_pas != "05", row

* Enterprise type of written contract workers
tab etyp_pas if job_pas == "1"

* Export analytical dataset
keep if worker == 1

keep st sec age sex male urban gedu_lvl edu_num ///
     etyp_pas etyp_num job_pas formal_contract ///
     leave_pas paid_leave ssec_pas social_prot ///
     pas regular_salaried mult strm mfsu

export delimited "plfs_analytical.csv", replace