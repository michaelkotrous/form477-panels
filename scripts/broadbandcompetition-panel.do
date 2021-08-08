/* Generate tables and perform econometric tests on FCC 477 Fixed Broadband Deployment panel
**
** Output:
** - broadbandcompetition-panel.log 
** - regression-tables.rtf
** - regression-tables.tex */

log using broadbandcompetition-panel.log, replace

use US-Fixed-Panel-Merged, clear


/* ------------------- 
 ** INTRA-PLATFROM COMPETITION COUNTS BY BLOCK
 * ------------------- */

// By year-month
collapse (max) count_aDSL count_cable count_fiber, by(blockid month)
tab count_aDSL month
tab count_cable month
tab count_fiber month

// Total
collapse (max) count_aDSL count_cable count_fiber, by(blockid)
tab count_aDSL
tab count_cable
tab count_fiber

use US-Fixed-Panel-Merged, clear


/* ------------------- 
 ** INTER-PLATFROM COMPETITION COUNTS BY BLOCK
 * ------------------- */

// aDSL, by year-month
keep if inlist(techcode, 10, 11, 12)
collapse (max) count_cable count_fiber, by(blockid month)
tab count_cable month
tab count_fiber month

// aDSL, total
collapse (max) count_cable count_fiber, by(blockid)
tab count_cable
tab count_fiber

use US-Fixed-Panel-Merged, clear

// Cable, by year-month
keep if inlist(techcode, 40, 41, 42, 43)
collapse (max) count_aDSL count_fiber, by(blockid month)
tab count_aDSL month
tab count_fiber month

// Cable, total
collapse (max) count_aDSL count_fiber, by(blockid)
tab count_aDSL
tab count_fiber

use US-Fixed-Panel-Merged, clear

// Fiber, by year-month
keep if techcode == 50
collapse (max) count_aDSL count_cable, by(blockid month)
tab count_aDSL month
tab count_cable month

// Fiber, total
collapse (max) count_aDSL count_cable, by(blockid)
tab count_aDSL
tab count_cable

use US-Fixed-Panel-Merged, clear


/* -------------------
 ** VARIABLE TRANSFORMS
 * ------------------- */

// Convert download speeds from mbps to kbps and then take ln
// kbps conversion keeps ln > 0
gen maxaddown_kbps = 1000 * maxaddown
gen ln_maxaddown_kbps = ln(maxaddown_kbps)
drop maxaddown_kbps

// Take logs of income, housing and population density
gen ln_medianincome_tract_2019 = ln(medianincome_tract_2019)
gen ln_housing_density = ln(housing_density)
gen ln_popln_density = ln(popln_density)


/* -------------------
 ** VARIABLE LABELS
 * ------------------- */

label variable ln_maxaddown_kbps "ln(Download Speed, kbps)"
label variable ln_medianincome_tract_2019 "ln(Median Income)"
label variable ln_housing_density "ln(Housing Density)"
label variable ln_popln_density "ln(Population Density)"


/* -------------------
 ** SUMMARY STATISTICS
 * ------------------- */ 

/* Describe dataset */
describe
labelbook
codebook ln_maxaddown_kbps count_fiberGigabit count_fiberNonGigabit count_cable count_aDSL ln_medianincome_tract_2019 ln_housing_density ln_popln_density month stateabbr stateid countyid tractid blkgrpid blockid, header

/* Show values and count observations for tech and speeds */ 
tab techcode
tab techcode month
tab fiber_gigabit month

/* Other summary statistics */
tab count_aDSL
tab count_cable
tab count_fiberGigabit
tab count_fiberNonGigabit

/* Summarize maximum advertised download speeds by transmission technology, and by tech and by month */
tab techcode, summarize(maxaddown)
tab techcode month, summarize(maxaddown)

/* Aggregate summary statistics for all aDSL and cable transmission technologies */
summarize(maxaddown) if inlist(techcode, 10, 11, 12)
tab month if inlist(techcode, 10, 11, 12), summarize(maxaddown)

summarize(maxaddown) if inlist(techcode, 40, 41, 42, 43)
tab month if inlist(techcode, 40, 41, 42, 43), summarize(maxaddown)

/* Summarize maximum advertised upload speeds by transmission technology, and by tech and by month */
tab techcode, summarize(maxadup)
tab techcode month, summarize(maxadup)

/* Look at download speeds before transform and after */
tab maxaddown // looks continuous in [25, 1000]
tab ln_maxaddown_kbps // looks continuous on [10.1, 13.8]

/* See how download speeds change when number of intra-platform competitors increases */
tab maxaddown count_aDSL if inlist(techcode, 10, 11, 12)
tab maxaddown count_cable if inlist(techcode, 40, 41, 42, 43)
tab maxaddown count_fiberGigabit if techcode == 50
tab maxaddown count_fiberNonGigabit if techcode == 50

/* Summarize controls */
sum medianincome_tract_2019 ln_medianincome_tract_2019
sum housing_density popln_density ln_housing_density ln_popln_density


/* -------------------
 ** aDSL SERVICE, COMPETITION COUNTS
 * ------------------- */

/* HOUSING DENSITY */
// Simple OLS (est1)
eststo: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "No", replace

// State Fixed Effects (est2)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density i.stateabbr if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "No", replace

// Time Fixed Effects (est3)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density i.month if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "Yes", replace

// State & Time Fixed Effects (est4)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density i.stateabbr i.month if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "Yes", replace

summarize ln_maxaddown_kbps ln_medianincome_tract_2019 ln_housing_density if e(sample)


/* POPULATION DENSITY */
// Simple OLS (est5)
eststo: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_popln_density if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "No", replace

// State Fixed Effects (est6)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_popln_density i.stateabbr if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "No", replace

// Time Fixed Effects (est7)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_popln_density i.month if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "Yes", replace

// State & Time Fixed Effects (est8)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_popln_density i.stateabbr i.month if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "Yes", replace

summarize ln_maxaddown_kbps ln_medianincome_tract_2019 ln_popln_density if e(sample)

tab1 binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 if e(sample)


/* TABLE: aDSL Service, Competition Count Specifications */
// Export results of all aDSL regressions in RTF and Tex formats
esttab est1 est5 est2 est6 est3 est7 est4 est8 using regression-tables.rtf, title("Table: aDSL Service, Competition Count Dummies") keep(binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density ln_popln_density _cons) label s(state_fe time_fe N, label("State Fixed Effects" "Time Fixed Effects" "N")) replace

esttab est1 est5 est2 est6 est3 est7 est4 est8 using regression-tables.tex, title("Table: aDSL Service, Competition Count Dummies") keep(binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable1 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density ln_popln_density _cons) label s(state_fe time_fe N, label("State Fixed Effects" "Time Fixed Effects" "N")) replace

eststo clear


/* -------------------
 ** CABLE SERVICE, COMPETITION COUNTS
 * ------------------- */

/* HOUSING DENSITY */
// Simple OLS (est1)
eststo: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "No", replace

// State Fixed Effects (est2)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density i.stateabbr if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "No", replace

// Time Fixed Effects (est3)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density i.month if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "Yes", replace

// State & Time Fixed Effects (est4)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density i.stateabbr i.month if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "Yes", replace

summarize ln_maxaddown_kbps ln_medianincome_tract_2019 ln_housing_density if e(sample)


/* POPULATION DENSITY */
// Simple OLS (est5)
eststo: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_popln_density if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "No", replace

// State Fixed Effects (est6)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_popln_density i.stateabbr if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "No", replace

// Time Fixed Effects (est7)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_popln_density i.month if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "Yes", replace

// State & Time Fixed Effects (est8)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_popln_density i.stateabbr i.month if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "Yes", replace

summarize ln_maxaddown_kbps ln_medianincome_tract_2019 ln_popln_density if e(sample)

tab1 binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 if e(sample)


/* TABLE: Cable Service, Competition Count Specifications */
// Export results of all cable regressions in RTF and Tex formats
esttab est1 est5 est2 est6 est3 est7 est4 est8 using regression-tables.rtf, title("Table: Cable Service, Competition Count Dummies") keep(binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density ln_popln_density _cons) label s(state_fe time_fe N, label("State Fixed Effects" "Time Fixed Effects" "N")) append

esttab est1 est5 est2 est6 est3 est7 est4 est8 using regression-tables.tex, title("Table: Cable Service, Competition Count Dummies") keep(binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 binary_fiberGigabit4 binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3 binary_fiberNonGigabit4 binary_fiberNonGigabit5 binary_aDSL1 binary_aDSL2 binary_aDSL3 binary_aDSL4 binary_cable2 binary_cable3 binary_cable4 binary_cable5 ln_medianincome_tract_2019 ln_housing_density ln_popln_density _cons) label s(state_fe time_fe N, label("State Fixed Effects" "Time Fixed Effects" "N")) append

eststo clear


/* -------------------
 ** aDSL SERVICE, COMPETITION PRESENCE
 * ------------------- */

/* HOUSING DENSITY */
// Simple OLS (est1)
eststo: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_cable ln_medianincome_tract_2019 ln_housing_density if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "No", replace

// State Fixed Effects (est2)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_cable ln_medianincome_tract_2019 ln_housing_density i.stateabbr if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "No", replace

// Time Fixed Effects (est3)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_cable ln_medianincome_tract_2019 ln_housing_density i.month if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "Yes", replace

// State & Time Fixed Effects (est4)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_cable ln_medianincome_tract_2019 ln_housing_density i.stateabbr i.month if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "Yes", replace

summarize ln_maxaddown_kbps ln_medianincome_tract_2019 ln_housing_density if e(sample)


/* POPULATION DENSITY */
// Simple OLS (est5)
eststo: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_cable ln_medianincome_tract_2019 ln_popln_density if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "No", replace

// State Fixed Effects (est6)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_cable ln_medianincome_tract_2019 ln_popln_density i.stateabbr if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "No", replace

// Time Fixed Effects (est7)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_cable ln_medianincome_tract_2019 ln_popln_density i.month if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "Yes", replace

// State & Time Fixed Effects (est8)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_cable ln_medianincome_tract_2019 ln_popln_density i.stateabbr i.month if inlist(techcode, 10, 11, 12), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "Yes", replace

summarize ln_maxaddown_kbps ln_medianincome_tract_2019 ln_popln_density if e(sample)

tab1 binary_fiberGigabit binary_fiberNonGigabit binary_cable if e(sample)


/* TABLE: aDSL Service, Competition Presence Specifications */
// Export results of all aDSL regressions in RTF and Tex formats
esttab est1 est5 est2 est6 est3 est7 est4 est8 using regression-tables.rtf, title("Table: aDSL Service, Competition Presence Dummies") keep(binary_fiberGigabit binary_fiberNonGigabit binary_cable ln_medianincome_tract_2019 ln_housing_density ln_popln_density _cons) label s(state_fe time_fe N, label("State Fixed Effects" "Time Fixed Effects" "N")) append

esttab est1 est5 est2 est6 est3 est7 est4 est8 using regression-tables.tex, title("Table: aDSL Service, Competition Presence Dummies") keep(binary_fiberGigabit binary_fiberNonGigabit binary_cable ln_medianincome_tract_2019 ln_housing_density ln_popln_density _cons) label s(state_fe time_fe N, label("State Fixed Effects" "Time Fixed Effects" "N")) append

eststo clear


/* -------------------
 ** CABLE SERVICE, COMPETITION PRESENCE
 * ------------------- */

/* HOUSING DENSITY */
// Simple OLS (est1)
eststo: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_aDSL ln_medianincome_tract_2019 ln_housing_density if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "No", replace

// State Fixed Effects (est2)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_aDSL ln_medianincome_tract_2019 ln_housing_density i.stateabbr if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "No", replace

// Time Fixed Effects (est3)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_aDSL ln_medianincome_tract_2019 ln_housing_density i.month if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "Yes", replace

// State & Time Fixed Effects (est4)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_aDSL ln_medianincome_tract_2019 ln_housing_density i.stateabbr i.month if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "Yes", replace

summarize ln_maxaddown_kbps ln_medianincome_tract_2019 ln_housing_density if e(sample)


/* POPULATION DENSITY */
// Simple OLS (est5)
eststo: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_aDSL ln_medianincome_tract_2019 ln_popln_density if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "No", replace

// State Fixed Effects (est6)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_aDSL ln_medianincome_tract_2019 ln_popln_density i.stateabbr if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "No", replace

// Time Fixed Effects (est7)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_aDSL ln_medianincome_tract_2019 ln_popln_density i.month if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "No", replace
estadd local time_fe "Yes", replace

// State & Time Fixed Effects (est8)
eststo: xi: reg ln_maxaddown_kbps binary_fiberGigabit binary_fiberNonGigabit binary_aDSL ln_medianincome_tract_2019 ln_popln_density i.stateabbr i.month if inlist(techcode, 40, 41, 42, 43), robust cluster(tractid)
estadd local state_fe "Yes", replace
estadd local time_fe "Yes", replace

summarize ln_maxaddown_kbps ln_medianincome_tract_2019 ln_popln_density if e(sample)

tab1 binary_fiberGigabit binary_fiberNonGigabit binary_aDSL if e(sample)


/* TABLE: Cable Service, Competition Presence Specifications */
// Export results of all aDSL regressions in RTF and Tex formats
esttab est1 est5 est2 est6 est3 est7 est4 est8 using regression-tables.rtf, title("Table: Cable Service, Competition Presence Dummies") keep(binary_fiberGigabit binary_fiberNonGigabit binary_aDSL ln_medianincome_tract_2019 ln_housing_density ln_popln_density _cons) label s(state_fe time_fe N, label("State Fixed Effects" "Time Fixed Effects" "N")) append

esttab est1 est5 est2 est6 est3 est7 est4 est8 using regression-tables.tex, title("Table: Cable Service, Competition Presence Dummies") keep(binary_fiberGigabit binary_fiberNonGigabit binary_aDSL ln_medianincome_tract_2019 ln_housing_density ln_popln_density _cons) label s(state_fe time_fe N, label("State Fixed Effects" "Time Fixed Effects" "N")) append

eststo clear

log close

clear
