/* Create panel with broadband service observations in randomly-selected Census tracts
**
** Output:
** - US-Fixed-Panel-Random-Merged.dta
** - crosssection/merge-badTracts.log
** - crosssection/merge-sampleTracts.log */

/* RANDOMLY SELECT ONE-FOURTH OF CLEAN TRACTS */
// Identify tracts with ACS control variables that failed to merge (population, housing, or income) with 477 cross-sections
// Note: Tracts that failed to merge with 477 data were identical in 2015, 2016, 2017, 2018, and 2019. All tracts that failed to merge in 2014 also failed in the other years, but three tracts that failed to merge in later years succeeded in 2014. 
tempfile tracts_missingControls
use crosssection/US-Fixed-Merged-201812, clear
collapse (count) logrecno if _merge_population == 1 | _merge_housingunits == 1 | _merge_medianincome == 1, by(tractid)
drop logrecno
save `tracts_missingControls'

log using crosssection/merge-badTracts.log, replace

// Merge bad tracts on Dec 2018 data
tempfile tracts_fullControls
use crosssection/US-Fixed-Merged-201812, clear
merge m:1 tractid using `tracts_missingControls', generate(_merge_badTracts)

// Drop observations in those tracts
// In this case, matching indicates entire tract or block group within tract failed to merge properly with ACS controls
drop if _merge_badTracts == 3

log close

// Generate list of clean tracts
collapse (count) logrecno, by(tractid)
drop logrecno

// Sample 25 percent of clean tracts
set seed 5663451
sample 25
save `tracts_fullControls'


/* GENERATE SEVEN CROSS-SECTIONS WITH ONLY RANDOMLY SELECTED TRACTS */

log using crosssection/merge-sampleTracts.log, replace

// Dec 2014
tempfile sample_201412
use crosssection/US-Fixed-Merged-201412, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3
save `sample_201412'

// Jun 2015
tempfile sample_201506
use crosssection/US-Fixed-Merged-201506, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3
save `sample_201506'

// Dec 2015
tempfile sample_201512
use crosssection/US-Fixed-Merged-201512, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3
save `sample_201512'

// Jun 2016
tempfile sample_201606
use crosssection/US-Fixed-Merged-201606, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3
save `sample_201606'

// Dec 2016
tempfile sample_201612
use crosssection/US-Fixed-Merged-201612, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3
save `sample_201612'

// Jun 2017
tempfile sample_201706
use crosssection/US-Fixed-Merged-201706, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3
save `sample_201706'

// Dec 2017
tempfile sample_201712
use crosssection/US-Fixed-Merged-201712, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3
save `sample_201712'

// Jun 2018
tempfile sample_201806
use crosssection/US-Fixed-Merged-201806, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3
save `sample_201806'

// Dec 2018
tempfile sample_201812
use crosssection/US-Fixed-Merged-201812, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3
save `sample_201812'

// Jun 2019
tempfile sample_201906
use crosssection/US-Fixed-Merged-201906, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3
save `sample_201906'

// Dec 2019
use crosssection/US-Fixed-Merged-201912, clear
merge m:1 tractid using `tracts_fullControls', generate(_merge_sampleTracts)
keep if _merge_sampleTracts == 3

/* APPEND CROSS-SECTION SAMPLES TO DEC 2019 TO MAKE FULL PANEL */
append using `sample_201412' `sample_201506' `sample_201512' `sample_201606' `sample_201612' `sample_201706' `sample_201712' `sample_201806' `sample_201812' `sample_201906'

log close


/* DROP REMAINING MERGE VARIABLES */
drop _merge_population _merge_housingunits _merge_landarea _merge_medianincome _merge_sampleTracts


/* FORMAT DATASET BY SORTING, ORDERING, AND LABELING */
do scripts/helpers/dataset-formatting


/* DESCRIBE DATASET */
label data "FCC Form 477 Fixed Broadband Data, 2014-2019 from 25 percent of US Census Tracts"

save US-Fixed-Panel-Random-Merged, replace
clear
