/* IMPORT, CLEAN, AND ADJUST MEDIAN INCOME DATA TO 2019 USD */
import delimited source/${year}/acs/s1903/ACS_${yearabbr}_5YR_S1903_with_ann, varnames(1) clear

/* FORMAT ACS S1903 DATA */
// Generate and format year
generate year = date("$year", "Y")
replace year = yofd(year)
format year %ty

// Set column names
if $year == 2018 | $year == 2019 {
	gen tractid = substr(geo_id, 10, 11)
	rename s1903_c03_001e medianincome_tract
	rename s1903_c03_001m medianincome_tract_moe
}
else if $year == 2017 {
	rename geoid2 tractid
	rename hc03_est_vc02 medianincome_tract
	rename hc03_moe_vc02 medianincome_tract_moe
}
else {
	rename geoid2 tractid
	rename hc02_est_vc02 medianincome_tract
	rename hc02_moe_vc02 medianincome_tract_moe
}

// Keep only variables of interest
keep tractid year medianincome_tract medianincome_tract_moe

// Convert income and moe to numbers
destring medianincome_tract, replace ignore("-" "," "+" "(X)" "null")
destring medianincome_tract_moe, replace ignore("**" "(X)" "null")

// Generate Census Geo ID for tracts
tostring tractid, replace format(%11.0f)
gen tractid_len = strlen(tractid)
replace tractid = "0"+tractid if tractid_len == 10
drop tractid_len

if $year == 2019 {
	rename medianincome_tract medianincome_tract_2019
	rename medianincome_tract_moe medianincome_tract_moe_2019
}
else {
	// Adjust non-2019 income and moe estimates to 2019 dollars
	merge m:1 year using source/bls/CPIAUCSL, generate(_merge_cpi) keep(match master)
	generate medianincome_tract_2019 = round(medianincome_tract * (cpi_2019/cpi))
	generate medianincome_tract_moe_2019 = round(medianincome_tract_moe * (cpi_2019/cpi))

	// Drop unadjusted income data, CPI values, and Stata-generated _merge
	drop medianincome_tract medianincome_tract_moe cpi cpi_2019 _merge_cpi
}

