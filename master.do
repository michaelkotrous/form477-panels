/* -------------------
 ** FCC FORM 477 PANEL
 ** UNITED STATES, 2014-2018
 * ------------------- */

set more off
cd ""

/* Store global macro with states for compiling ACS and Census land area files */
global states AL AZ AR CA CO CT DE DC FL GA ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY

/* Produce dta files to be used for mergers in annual dataset files */
do scripts/shared-data

/* Assemble cross-sections for years 2014-2018 */
do scripts/crosssection-201412
do scripts/crosssection-201506
do scripts/crosssection-201512
do scripts/crosssection-201606
do scripts/crosssection-201612
do scripts/crosssection-201706
do scripts/crosssection-201712
do scripts/crosssection-201806
do scripts/crosssection-201812

/* Append cross-sections to make full panel */
do scripts/append-random
//do scripts/append-full

/* Run econometric tests */
do scripts/broadbandcompetition-panel

clear
