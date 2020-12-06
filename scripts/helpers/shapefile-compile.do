/* COMPILE TIGER/LINE SHAPEFILES STATE DATA TO MAKE NATIONAL DATASET */
foreach state of global states {
	tempfile censusShapefile_${year}_`state'
	import delimited source/${year}/census/tl_${year}_`state'_bg-attr, clear

	// Generate and format year
	generate year = date("$year", "Y")
	replace year = yofd(year)
	format year %ty

	// Set column names
	rename geoid blkgrpid
	rename aland arealand
	rename awater areawater

	// Generate Census Geo ID for block groups
	tostring blkgrpid, replace format(%12.0f)
	gen blkgrpid_len = strlen(blkgrpid)
	replace blkgrpid = "0"+blkgrpid if blkgrpid_len == 11
	drop blkgrpid_len

	// Convert area measures from square meters to square kilometers
	gen arealand_km = arealand/1000000
	gen areawater_km = areawater/1000000

	// Keep only variables of interest
	keep blkgrpid year arealand_km areawater_km

	save `censusShapefile_${year}_`state''
}

use `censusShapefile_${year}_AL', clear

foreach state of global states {
	if "`state'" != "AL" {
		append using `censusShapefile_${year}_`state''
	}
}
