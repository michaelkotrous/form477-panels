# CHANGELOG
## _Journal of Information Policy_
### Second Draft, Submitted Mar. 19, 2021, Accepted on Jul. 27, 2021
- Expand the panel of FCC Form 477 data to include **all Census blocks** in the 48 contiguous states and Washington, DC.
- Extend the panel to include Form 477 data from June 2019 and December 2019. Controls sourced from 2019 ACS also added.
- Modified OLS estimators to include all competition count binaries, rather than using a “three or more” binary. 
	- For cable specifications, the competition count binaries are as follows:
		- Gigabit fiber: 1, 2, 3, 4
		- Non-gigabit fiber: 1, 2, 3, 4, 5
		- Cable: 2, 3, 4, 5
		- aDSL: 1, 2, 3, 4
	- For our aDSL download speed specifications, the competition count binaries are as follows:
		- Gigabit fiber: 1, 2, 3, 4
		- Non-gigabit fiber: 1, 2, 3, 4, 5
		- Cable: 1, 2, 3, 4, 5
		- aDSL: 2, 3, 4

### First Draft, Submitted Nov. 29, 2020
We submitted version identical to the second draft of the Center for Growth and Opportunity working paper for review.

## Center for Growth and Opportunity Working Paper
### Second Draft, Submitted Nov. 24, 2020
- Cluster standard errors by Census tract 
	- add `cluster(tractid)` after each `, robust` in `broadbandcompetition-panel.do`
- Filter data to exclude reported broadband service that does not meet current FCC definition of broadband
	- for each crosssection script, add `drop if maxaddown < 25 | maxadup < 3`
- Random sample of U.S. tracts bumped up to 25 percent
- Create count of all fiber providers in Census blocks, regardless of download speeds
- Create count of fiber providers not offering speeds at gigabit download speeds (i.e., download < 1000 mbps)
- Use provider counts at block level to produce binaries for each additional provider (e.g., `binary_cable2` equals 1 if `count_cable` equals 2; 0 otherwise); replace count variables in main results regressions with these binaries for fiber gigabit, fiber non-gigabit, cable, and aDSL service providers. Because of limited observations of three providers or more in a provider category in a block, the #3 binary indicates "three or more" distinct providers in the block in a tech category.
- Produce binaries that indicate presence of provider using particular tech category in a Census block (e.g., `binary_cable` equals 1 if `count_cable` is greater than or equal to 1; 0 otherwise)
- Generate summary statistics for variables in regression samples
	- after each state and time fixed effects regression specification in `broadbandcompetition-panel.do,` execute `summarize <varlist> if e(sample)`
- Produce tables with intra-platform and inter-platform competition counts among provider categories by Census block, for the full sample and by month-year
	- Intra-platform competition tables:
		- first gives number of Census blocks in entire sample with each level of competition by provider category (e.g., x blocks have two cable providers)
		- second table presents percentage of Census blocks with at least one provider in a given category that have only one provider in that category (e.g., of the 2,007,747 Census blocks observed in June 2016 with at least one cable provider, 1,897,658 of those blocks, or 94.5 percent, have only one cable provider.) Percent calculations done in separate Excel file.
	- Inter-platform competition tables:
		- First set of 2 tables give counts and summary statistics for blocks served by aDSL and cable providers in all sample periods. For instance, the aDSL table presents the number of blocks with at least one aDSL provider that are served by 0, 1, 2, 3, 4, and 5 cable providers, as well as the average and median number of cable providers serving an "aDSL block."
		- Other table presents average and median estimates for number of inter-platform competitors for each month-year in our sample.
- Add June 2018 and Dec 2018 FCC Form 477 cross-sections to panel
- Update block group landarea measures to be sourced from the Census Bureau's TIGER/Line Shapefiles. This update has two advantages:
	- The shapefiles are available for the block groups for each state for each year in our panel. This allows us to calculate population density and housing density for each year according to the exact geographies for the year's in which they were estimated, rather than assuming that the 2010 Decennial Census closely approximated the geographies for the ACS. After reviewing a handful of states, year-to-year changes in the land area's reported in the TIGER/Line Shapefiles are actual common.
	- Census discontinued American FactFinder website and the geography summary tables from which 2010 landareas. Accordingly, the landarea measures we use to calculate population density and housing density at the block group level could not be readily replicated without this update.

### First Draft, Submitted Aug. 28, 2019
- Compile FCC Form 477 data from Dec 2014 through Dec 2017
- Merge ACS and Census controls
- Sample 20 percent of all US tracts due to computational limitations
- Initial econometric analysis
