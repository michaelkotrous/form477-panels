// Count number of unique providers offering aDSL, cable, and fiber gigabit broadband service
tempfile count_aDSL_data
use crosssection/US-Fixed-Merged-$yyyymm, clear

// Counting logrecno is trick to get list of distinct frn's in each block. The second collapse returns number of distinct providers offering at least one type of aDSL service in a given block at a given time.
collapse (count) logrecno if inlist(techcode, 10, 11, 12), by(blockid frn)
drop logrecno
collapse (count) frn, by(blockid)
rename frn count_aDSL
save `count_aDSL_data'

tempfile count_cable_data
use crosssection/US-Fixed-Merged-$yyyymm, clear
collapse (count) logrecno if inlist(techcode, 40, 41, 42, 43), by(blockid frn)
drop logrecno
collapse (count) frn, by(blockid)
rename frn count_cable
save `count_cable_data'

tempfile count_fiber_data
use crosssection/US-Fixed-Merged-$yyyymm, clear
collapse (count) logrecno if techcode == 50, by(blockid frn)
drop logrecno
collapse (count) frn, by(blockid)
rename frn count_fiber
save `count_fiber_data'

tempfile count_fiberGigabit_data
use crosssection/US-Fixed-Merged-$yyyymm, clear
collapse (count) logrecno if fiber_gigabit == 1, by(blockid frn)
drop logrecno
collapse (count) frn, by(blockid)
rename frn count_fiberGigabit
save `count_fiberGigabit_data'

tempfile count_fiberNonGigabit_data
use crosssection/US-Fixed-Merged-$yyyymm, clear
collapse (count) logrecno if fiber_nongigabit == 1, by(blockid frn)
drop logrecno
collapse (count) frn, by(blockid)
rename frn count_fiberNonGigabit
save `count_fiberNonGigabit_data'

log using crosssection/merge-competition-vars-$yyyymm.log, replace

use crosssection/US-Fixed-Merged-$yyyymm, clear
merge m:1 blockid using `count_aDSL_data', generate(_merge_count_aDSL)
merge m:1 blockid using `count_cable_data', generate(_merge_count_cable)
merge m:1 blockid using `count_fiber_data', generate(_merge_count_fiber)
merge m:1 blockid using `count_fiberGigabit_data', generate(_merge_count_fiberGigabit)
merge m:1 blockid using `count_fiberNonGigabit_data', generate(_merge_count_fiberNonGigabit)

log close

// Drop merge variables
drop  _merge_count_aDSL _merge_count_cable _merge_count_fiber _merge_count_fiberGigabit _merge_count_fiberNonGigabit

// Missing values for count_aDSL, count_cable, count_fiber, count_fiberGigabit, 
// and count_fiberNonGigabit indicate block has zero providers in those tech categories
replace count_aDSL = 0 if missing(count_aDSL)
replace count_cable = 0 if missing(count_cable)
replace count_fiber = 0 if missing(count_fiber)
replace count_fiberGigabit = 0 if missing(count_fiberGigabit)
replace count_fiberNonGigabit = 0 if missing(count_fiberNonGigabit)

// Produce competition count binaries for each additional provider in Census block
gen binary_aDSL1 = 0
replace binary_aDSL1 = 1 if count_aDSL == 1
gen binary_aDSL2 = 0
replace binary_aDSL2 = 1 if count_aDSL == 2
gen binary_aDSL3 = 0
replace binary_aDSL3 = 1 if count_aDSL == 3
gen binary_aDSL4 = 0
replace binary_aDSL4 = 1 if count_aDSL == 4

gen binary_cable1 = 0
replace binary_cable1 = 1 if count_cable == 1
gen binary_cable2 = 0
replace binary_cable2 = 1 if count_cable == 2
gen binary_cable3 = 0
replace binary_cable3 = 1 if count_cable == 3
gen binary_cable4 = 0
replace binary_cable4 = 1 if count_cable == 4
gen binary_cable5 = 0
replace binary_cable5 = 1 if count_cable == 5

gen binary_fiberGigabit1 = 0
replace binary_fiberGigabit1 = 1 if count_fiberGigabit == 1
gen binary_fiberGigabit2 = 0
replace binary_fiberGigabit2 = 1 if count_fiberGigabit == 2
gen binary_fiberGigabit3 = 0
replace binary_fiberGigabit3 = 1 if count_fiberGigabit == 3
gen binary_fiberGigabit4 = 0
replace binary_fiberGigabit4 = 1 if count_fiberGigabit == 4

gen binary_fiberNonGigabit1 = 0
replace binary_fiberNonGigabit1 = 1 if count_fiberNonGigabit == 1
gen binary_fiberNonGigabit2 = 0
replace binary_fiberNonGigabit2 = 1 if count_fiberNonGigabit == 2
gen binary_fiberNonGigabit3 = 0
replace binary_fiberNonGigabit3 = 1 if count_fiberNonGigabit == 3
gen binary_fiberNonGigabit4 = 0
replace binary_fiberNonGigabit4 = 1 if count_fiberNonGigabit == 4
gen binary_fiberNonGigabit5 = 0
replace binary_fiberNonGigabit5 = 1 if count_fiberNonGigabit == 5

// Produce binary indicating presence of any provider of given technology 
gen binary_aDSL = 0
replace binary_aDSL = 1 if count_aDSL >= 1

gen binary_cable = 0
replace binary_cable = 1 if count_cable >= 1

gen binary_fiberGigabit = 0
replace binary_fiberGigabit = 1 if count_fiberGigabit >= 1

gen binary_fiberNonGigabit = 0
replace binary_fiberNonGigabit = 1 if count_fiberNonGigabit >= 1
