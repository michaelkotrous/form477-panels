/* COMPILE B01003 STATE DATA TO MAKE NATIONAL DATASET */
foreach state of global states {
	tempfile acsb01003_${year}_`state'
	import delimited source/${year}/acs/b01003/ACS_${yearabbr}_5YR_B01003_with_ann_`state', clear

	// Generate and format year
	generate year = date("$year", "Y")
	replace year = yofd(year)
	format year %ty

	// Format data
	if $year == 2018 | $year == 2019 {
		// Generate FIPS code for block groups
		gen blkgrpid = substr(geo_id, 10, 12)
		
		// Set column names
		rename b01003_001e totalpopulation_blkgrp
		rename b01003_001m totalpopulation_blkgrp_moe
	}
	else {
		// Generate FIPS code for block groups
		rename geoid2 blkgrpid
		tostring blkgrpid, replace format(%12.0f)
		gen blkgrpid_len = strlen(blkgrpid)
		replace blkgrpid = "0"+blkgrpid if blkgrpid_len == 11
		drop blkgrpid_len

		// Set column names
		rename hd01_vd01 totalpopulation_blkgrp
		rename hd02_vd01 totalpopulation_blkgrp_moe
	}

	// Destring margin of error to correct KS coding issue in 2014
	if $year == 2014 {
		destring totalpopulation_blkgrp_moe, replace ignore("*****")
	}

	// Keep only variables of interest
	keep blkgrpid year totalpopulation_blkgrp totalpopulation_blkgrp_moe

	save `acsb01003_${year}_`state''
}

use `acsb01003_${year}_AL', clear

foreach state of global states {
	if "`state'" != "AL" {
		append using `acsb01003_${year}_`state''
	}
}
