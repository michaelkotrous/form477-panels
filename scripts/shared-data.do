/* Produce dta files for
** - Consumer Price Index, 2014-2018 (annual; end of period)
**
** Outputs:
** - source/bls/CPIAUCSL.dta */


/* -------------------
 ** CONSUMER PRICE INDEX, 2014-2019
 ** To adjust median income estimates to 2019 dollars
 * ------------------- */

import delimited source/bls/CPIAUCSL, clear

// Format year
recast float year
format year %ty

// Produce column with 2019 CPI for inflation-adjustment calculation
egen cpi_2019 = max(cond(year == 2019, cpi, .))

save source/bls/CPIAUCSL, replace
clear
