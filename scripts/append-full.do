/* Append cross-sections to Dec 2014 file to create full panel 
**
** Output:
** - US-Fixed-Panel-Merged.dta */

use crosssection/US-Fixed-Merged-201412, clear
append using crosssection/US-Fixed-Merged-201506 crosssection/US-Fixed-Merged-201512 crosssection/US-Fixed-Merged-201606 crosssection/US-Fixed-Merged-201612 crosssection/US-Fixed-Merged-201706 crosssection/US-Fixed-Merged-201712 crosssection/US-Fixed-Merged-201806 crosssection/US-Fixed-Merged-201812


/* FORMAT DATASET BY SORTING, ORDERING, AND LABELING */
do scripts/helpers/dataset-formatting


/* DESCRIBE DATASET */
label data "FCC Form 477 Fixed Broadband Data, 2014-2018"

save US-Fixed-Panel-Merged, replace
clear
