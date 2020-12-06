/* SORT DATA */
sort blockid month frn techcode

/* ORDER COLUMNS */
order consumer, before(techcode)
order blockid, before(blkgrpid)
order stateabbr month year, after(stateid)
order housing_density popln_density medianincome_tract_2018 medianincome_tract_moe_2018, before(totalpopulation_blkgrp)
order count_aDSL binary_aDSL binary_aDSL1 binary_aDSL2 binary_aDSL3 count_cable binary_cable binary_cable1 binary_cable2 binary_cable3 count_fiber fiber_gigabit count_fiberGigabit binary_fiberGigabit binary_fiberGigabit1 binary_fiberGigabit2 binary_fiberGigabit3 fiber_nongigabit count_fiberNonGigabit binary_fiberNonGigabit binary_fiberNonGigabit1 binary_fiberNonGigabit2 binary_fiberNonGigabit3, after(maxadup)


/* DESCRIBE FULL DATASET */
label data "FCC Form 477 Fixed Broadband Data, 2014-2018 from 25 percent of US Census Tracts"

/* LABEL VARIABLES AND VALUES, WHERE APPLICABLE */
label variable logrecno "Logical record number relating broadband deployment tables to Imputations Table"
label variable provider_id "Filing number (assigned by FCC)"
label variable frn "FCC registration number"
label variable providername "Broadband Provider Name"

label variable consumer "Consumer/Residential broadband service"
label define consumer_vals 0 "No" 1 "Yes"
label values consumer consumer_vals

label variable techcode "Transmission Technology"
label define techcode_vals 0 "Other" 10 "Asymmetric xDSL" 11 "ADSL2, ADSL2+" 12 "VDSL" 20 "Symmetric xDSL" 30 "Other Copper Wireline" 40 "Cable Modem, Other" 41 "DOCSIS 1,1.1,2.0" 42 "DOCSIS 3.0" 43 "DOCSIS 3.1" 50 "Optical/FTTH" 60 "Satellite" 70 "Terr. Fixed Wireless" 90 "Electric Power Line"
label values techcode techcode_vals

label variable maxaddown "Download Speed, mbps"
label variable maxadup "Upload Speeds, mbps"
label variable count_aDSL "aDSL Providers"
label variable count_cable "Cable Providers"
label variable count_fiber "Fiber Providers"
label variable count_fiberGigabit "Fiber Gigabit Providers"
label variable count_fiberNonGigabit "Fiber Non-Gigabit Providers"

label variable binary_aDSL "aDSL provider (one or more) in block"
label define binary_aDSL_vals 0 "No" 1 "Yes"
label values binary_aDSL binary_aDSL_vals

label variable binary_aDSL1 "One aDSL provider in block"
label define binary_aDSL1_vals 0 "No" 1 "Yes"
label values binary_aDSL1 binary_aDSL1_vals

label variable binary_aDSL2 "Two aDSL providers in block"
label define binary_aDSL2_vals 0 "No" 1 "Yes"
label values binary_aDSL2 binary_aDSL2_vals

label variable binary_aDSL3 "Three or more aDSL providers in block"
label define binary_aDSL3_vals 0 "No" 1 "Yes"
label values binary_aDSL3 binary_aDSL3_vals

label variable binary_cable "Cable provider (one or more) in block"
label define binary_cable_vals 0 "No" 1 "Yes"
label values binary_cable binary_cable_vals

label variable binary_cable1 "One cable provider in block"
label define binary_cable1_vals 0 "No" 1 "Yes"
label values binary_cable1 binary_cable1_vals

label variable binary_cable2 "Two cable providers in block"
label define binary_cable2_vals 0 "No" 1 "Yes"
label values binary_cable2 binary_cable2_vals

label variable binary_cable3 "Three or more cable providers in block"
label define binary_cable3_vals 0 "No" 1 "Yes"
label values binary_cable3 binary_cable3_vals

label variable binary_fiberGigabit "Fiber Gb provider (one or more) in block"
label define binary_fiberGigabit_vals 0 "No" 1 "Yes"
label values binary_fiberGigabit binary_fiberGigabit_vals

label variable binary_fiberGigabit1 "One fiber Gb provider in block"
label define binary_fiberGigabit1_vals 0 "No" 1 "Yes"
label values binary_fiberGigabit1 binary_fiberGigabit1_vals

label variable binary_fiberGigabit2 "Two fiber Gb providers in block"
label define binary_fiberGigabit2_vals 0 "No" 1 "Yes"
label values binary_fiberGigabit2 binary_fiberGigabit2_vals

label variable binary_fiberGigabit3 "Three or more fiber Gb providers in block"
label define binary_fiberGigabit3_vals 0 "No" 1 "Yes"
label values binary_fiberGigabit3 binary_fiberGigabit3_vals

label variable binary_fiberNonGigabit "Fiber ltGb provider (one or more) in block"
label define binary_fiberNonGigabit_vals 0 "No" 1 "Yes"
label values binary_fiberNonGigabit binary_fiberNonGigabit_vals

label variable binary_fiberNonGigabit1 "One fiber ltGb provider in block"
label define binary_fiberNonGigabit1_vals 0 "No" 1 "Yes"
label values binary_fiberNonGigabit1 binary_fiberNonGigabit1_vals

label variable binary_fiberNonGigabit2 "Two fiber ltGb providers in block"
label define binary_fiberNonGigabit2_vals 0 "No" 1 "Yes"
label values binary_fiberNonGigabit2 binary_fiberNonGigabit2_vals

label variable binary_fiberNonGigabit3 "Three or more fiber ltGb providers in block"
label define binary_fiberNonGigabit3_vals 0 "No" 1 "Yes"
label values binary_fiberNonGigabit3 binary_fiberNonGigabit3_vals

label variable fiber_gigabit "Fiber gigabit service"
label define fiber_gigabit_vals 0 "No" 1 "Yes"
label values fiber_gigabit fiber_gigabit_vals

label variable fiber_nongigabit "Fiber non-gigabit service"
label define fiber_nongigabit_vals 0 "No" 1 "Yes"
label values fiber_nongigabit fiber_nongigabit_vals

label variable blockid "Census block FIPS id (15-digit)"
label variable blkgrpid "Census block group FIPS id (12-digit)"
label variable tractid "Census tract FIPS id (11-digit)"
label variable countyid "County FIPS id (5-digit)"
label variable stateid "State FIPS id (2-digit)"
label variable stateabbr "State Abbr"
label variable month "Month"
label variable year "Year"
label variable housing_density "Housing Density"
label variable popln_density "Population Density"
label variable medianincome_tract_2018 "Median Income"
label variable medianincome_tract_moe_2018 "Median Income - Margin of Error"
label variable totalpopulation_blkgrp "Total Population"
label variable totalpopulation_blkgrp_moe "Total Population - Margin of Error"
label variable housingunits_blkgrp "Housing Units"
label variable housingunits_blkgrp_moe "Housing Units - Margin of Error"
label variable arealand_km "Block Group Land Area (km2)"
label variable areawater_km "Block Group Water Area (km2)"
