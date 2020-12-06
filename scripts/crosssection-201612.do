/* Produce December 2016 dataset with
** - ACS, block group landarea merged into December 2016 FCC Form 477 dataset,
** - Housing and Population Density values, and
** - Competition metrics 
**
** Outputs:
** - crosssection/US-Fixed-Merged-201612.dta
** - crosssection/merge-source-201612.log
** - crosssection/merge-competition-vars-201612.log */

global year 2016
global yearabbr 16
global yyyymm 201612

/* -------------------
 ** ACS B01003
 ** Total population, by block group
 * ------------------- */

tempfile acsb01003_${year}
do scripts/helpers/b01003-compile
sort blkgrpid year
save `acsb01003_${year}'
clear


/* -------------------
 ** ACS B25001
 ** Housing units, by block group
 * ------------------- */

tempfile acsb25001_${year}
do scripts/helpers/b25001-compile
sort blkgrpid year
save `acsb25001_${year}'
clear


/* -------------------
 ** ACS S1903
 ** Median income, by tract
 * ------------------- */

tempfile acss1903_${year}
do scripts/helpers/s1903-compile
sort tractid year
save `acss1903_${year}'
clear


/* -------------------
 ** CENSUS TIGER/LINE SHAPEFILES
 ** Land area, by block group
 * ------------------- */

tempfile censusShapefile_${year}
do scripts/helpers/shapefile-compile
sort blkgrpid year
save `censusShapefile_${year}'
clear


/* -------------------
 ** FCC FORM 477
 * ------------------- */

/* DECEMBER 2016 */
import delimited source/2016/fcc477/US-FIXED-DEC2016-v2, clear

// Drop states and territories outside 48 contiguous US states and DC
drop if stateabbr == "AK" | stateabbr == "AS" | stateabbr == "GU" | stateabbr == "HI" | stateabbr == "MP" | stateabbr == "PR" | stateabbr == "VI"

// Keep only consumer/residential broadband
keep if consumer == 1

// Drop service that does not meet FCC's definition of broadband
drop if maxaddown < 25 | maxadup < 3

// Drop columns not needed for analysis
drop dbaname holdingcompanyname hoconum hocofinal business maxcirdown maxcirup

// Generate dates for panel
generate month = date("12/31/2016", "MDY")
generate year = date("2016", "Y")

// Clean formats to make variables consistent across 477 data files
rename ïlogrecno logrecno
format provider_id %12.0g
format maxaddown %9.0g
format maxadup %9.0g

/* FORMAT FCC FORM 477 DATA */
// Change format of month and year
replace month = mofd(month)
format month %tm

replace year = yofd(year)
format year %ty

// Generate Census Geo IDs
rename blockcode blockid
tostring blockid, replace format(%15.0f)
gen blockid_len = strlen(blockid)
replace blockid = "0"+blockid if blockid_len == 14
drop blockid_len

generate blkgrpid = substr(blockid, 1, 12)
generate tractid = substr(blockid, 1, 11)
generate countyid = substr(blockid, 1, 5)
generate stateid = substr(blockid, 1, 2)


/* -------------------
 ** PRODUCE FULL DEC 2016 FCC, ACS DATA 
 * ------------------- */

/* MERGE ACS, BLOCK GROUP LANDAREA INTO FCC FORM 477 DATA */
log using crosssection/merge-source-$yyyymm.log, replace

merge m:1 blkgrpid year using `acsb01003_${year}', generate(_merge_population) keep(match master)
merge m:1 blkgrpid year using `acsb25001_${year}', generate(_merge_housingunits) keep(match master)
merge m:1 blkgrpid year using `censusShapefile_${year}', generate(_merge_landarea) keep(match master)
merge m:1 tractid year using `acss1903_${year}', generate(_merge_medianincome) keep(match master)

// Examine merge errors
tab tractid if _merge_population==1 // table by blkgrpid throws error
tab tractid if _merge_housingunits==1 // table by blkgrpid throws error
tab tractid if _merge_landarea==1 // table by blkgrpid throws error
tab tractid if _merge_medianincome==1

log close

/* DROP BROADBAND SERVICE REPORTED IN BLOCK GROUPS WITH ZERO POPULATION, HOUSING UNITS, OR LAND AREA*/
drop if totalpopulation_blkgrp == 0 | housingunits_blkgrp == 0 | arealand_km == 0

/* GENERATE POPULATION AND HOUSING DENSITY */
generate housing_density = housingunits_blkgrp/arealand_km
generate popln_density = totalpopulation_blkgrp/arealand_km

/* GENERATE BINARY INDICATING FIBER GIGABIT SERVICE */
generate fiber_gigabit = 0
replace fiber_gigabit = 1 if techcode == 50 & maxaddown == 1000

/* GENERATE BINARY INDICATING FIBER SERVICE BELOW GIGABIT SPEEDS */
generate fiber_nongigabit = 0 
replace fiber_nongigabit = 1 if techcode == 50 & maxaddown < 1000

/* GENERATE COMPETITION VARIABLES */
// Take snapshot of data before running collapse commands
save crosssection/US-Fixed-Merged-$yyyymm, replace

do scripts/helpers/competition-vars

sort blockid frn techcode
save crosssection/US-Fixed-Merged-$yyyymm, replace
clear
