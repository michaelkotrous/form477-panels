/* COMPILE B25001 STATE DATA TO MAKE NATIONAL DATASET */
foreach state of global states {
	tempfile acsb25001_${year}_`state'
	import delimited source/${year}/acs/b25001/ACS_${yearabbr}_5YR_B25001_with_ann_`state', clear

	// Generate and format year
	generate year = date("$year", "Y")
	replace year = yofd(year)
	format year %ty

	// Format data
	if $year == 2018 | $year == 2019 {
		// Generate FIPS code for block groups
		gen blkgrpid = substr(geo_id, 10, 12)
		
		rename b25001_001e housingunits_blkgrp
		rename b25001_001m housingunits_blkgrp_moe
	}
	else {
		// Generate FIPS code for block groups
		rename geoid2 blkgrpid
		tostring blkgrpid, replace format(%12.0f)
		gen blkgrpid_len = strlen(blkgrpid)
		replace blkgrpid = "0"+blkgrpid if blkgrpid_len == 11
		drop blkgrpid_len

		// Set column names
		rename hd01_vd01 housingunits_blkgrp
		rename hd02_vd01 housingunits_blkgrp_moe
	}

	// Keep only variables of interest
	keep blkgrpid year housingunits_blkgrp housingunits_blkgrp_moe
	
	save `acsb25001_${year}_`state''
}


use `acsb25001_${year}_AL', clear

foreach state of global states {
	if "`state'" != "AL" {
		append using `acsb25001_${year}_`state''
	}
}
