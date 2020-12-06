/* Produce dta files for
** - Consumer Price Index, 2014-2018 (annual; end of period)
**
** Outputs:
** - source/bls/CPIAUCSL.dta */


/* -------------------
 ** CONSUMER PRICE INDEX, 2014-2018
 ** To adjust median income estimates to 2018 dollars
 * ------------------- */

import delimited source/bls/CPIAUCSL, clear

// Format year
recast float year
format year %ty

// Produce column with 2018 CPI for inflation-adjustment calculation
egen cpi_2018 = max(cond(year == 2018, cpi, .))

save source/bls/CPIAUCSL, replace
clear
