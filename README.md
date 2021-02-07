# Form 477 Panels
This project assembles an eleven-part panel dataset of [Form 477](https://www.fcc.gov/general/broadband-deployment-data-fcc-form-477) broadband data from December 2014 through December 2019, sourced from the Federal Communications Commission. The Form 477 dataset reports fixed broadband service at the Census block level in the United States. The panel also includes demographic data for the years 2014 to 2019 from the U.S. Census Bureau, including:

- Population Density for U.S. block groups,
- Housing Density for U.S. block groups, and
- Median Income for U.S. tracts.

This version of the repo extends and expands the panel dataset used in the working paper versions of [Kotrous and Bailey (2021)](https://www.thecgo.org/research/broadband-speeds-in-fibered-markets-an-empirical-analysis/). A [previous release](https://github.com/michaelkotrous/form477-panels/tree/v1.0.0) of this repo can be used to recreate the dataset used by and replicate the econometric results of [Kotrous and Bailey (2021)](https://www.thecgo.org/research/broadband-speeds-in-fibered-markets-an-empirical-analysis/).

## License
This project uses the MIT License, so you are free to copy and modify the code as it suits your research needs. The panel retains geographic identifiers for Census blocks, block groups, tracts, counties, and states, so joining additional demographic data should be fairly straightforward. I'm currently developing a project that joins [High-Cost Support data from USAC](https://opendata.usac.org/High-Cost/High-Cost-Connect-America-Fund-Broadband-Map-CAF-M/r59r-rpip) by Census block id, for example.

## Dependencies
The code was most recently executed in Stata 16.1. Earlier versions of this code could be executed in Stata 14, so I expect this code will be compatible with most flavors of Stata.

The do file for econometric tests, `broadbandcompetition-panel.do`, uses the [estout](http://repec.sowi.unibe.ch/stata/estout/) package to export regression tables in RTF/Word and LaTeX formats. I strongly recommend installing it for this and other Stata projects!

## Setting up your Environment
In the repo working directory, create two new directories: crosssection (note three s's) and source.

**crosssection**: This directory is used to store each of the nine cross-sections of Form 477 data that has been joined with Census data. You are okay to leave this directory empty. It will be populated with files as the Stata scripts execute.

**source**: This directory is used to store all source files (in csv format) from FCC, the U.S. Census Bureau, and U.S. Bureau of Labor Statistics. This directory must be populated with source files in order to work. You can download an archive ([.zip](); [.tar.gz]()) of the source files. These files require just under **40** GB of storage. Note that when you extract the source files, the directory structure in your local environment (relative to the repo working directory) should look like `source/2014`, `source/2015`, and so on.

If you wish to see the final dataset or use it to run econometric tests, you can [download the final dataset](https://form477-panels.s3.us-east-2.amazonaws.com/US-Fixed-Panel-Merged-1.1.x.dta) (~40 GB). This dataset includes observations for all U.S. Census tracts in the 48 contiguous states and Washington, D.C.

## Using the Scripts
Executing the scripts is quite simple. Simply open `master.do` in Stata, define the working directory on line 7, and execute the do file. There's no need to edit or modify the do files in the scripts directory. The master do file will execute the supporting scripts in the appropriate order. 

## Changing the Sample, or Sample Size
Assembling the full national panel for all U.S. Census tracts in the 48 contiguous U.S. states and Washington, D.C. requires at least 64 GB of RAM. The full national panel is about 40 GB in size.

If you have insufficient RAM to work with the full national panel, you can select a sample by randomly drawing a given percentage of U.S. census tracts. Modify `master.do` to execute `append-random.do` rather than `append-full.do`. You will also need to edit lines 10,  of `scripts/broadbandcompetition-panel.do` to use the dataset US-Fixed-Panel-Random-Merged.dta.

By default, `scripts/append-random.do` will sample 25 percent of U.S. census tracts. Edit line 36 of `scripts/append-random.do` to change the sample size. 

You can define the seed to allow for replication of a sample on line 35 of `scripts/append-random.do`. The seed is set to `5663451`.

## Final Outputs
When the full `master.do` script is executed, four files will be placed in your working directory.

- US-Fixed-Panel-Merged.dta (default, or US-Fixed-Panel-Random-Merged.dta if `append-random.do` script is executed in master file instead of `append-full.do`)
- broadbandcompetition-panel.log (Stata log with full econometric results)
- regression-tables.rtf (Word-friendly format for regression tables)
- regression-tables.tex (LaTeX file for regression tables)

You will also notice that the `crosssection` directory is populated with Stata dta files for each merged cross-section of Form 477/ACS data, as well as various Stata log files with merger summaries and the like.

## Replicating Research
[Kotrous and Bailey (2021)](https://www.thecgo.org/research/broadband-speeds-in-fibered-markets-an-empirical-analysis/) analyzes a panel for 2014 - 2018 that samples 25 percent of U.S. Census tracts at random. A [previous release](https://github.com/michaelkotrous/form477-panels/tree/v1.0.0) of this repo provides the version of code, and links to archives of the source files, used for that paper.

The seed for replicating that sample is `5663451`. To draw a different sample of tracts, edit the seed on line 35 of `scripts/append-random.do`.

## Supporting the Project
Collecting the data took considerable effort, and storing the source files and allowing you to retrieve them is not free. If you use or enjoy this repository, I would appreciate you [buying me a beer](https://paypal.me/michaelkotrous)! 🍺

I would love to hear from you if you publish any research that uses or was inspired by this repository! If you do so, please cite this repository and:

Kotrous, Michael, and James Bailey. "Broadband Speeds in Fibered Markets: An Empirical Analysis." Working Paper, The Center for Growth and Opportunity at Utah State University, January 2021. [https://www.thecgo.org/research/broadband-speeds-in-fibered-markets-an-empirical-analysis/](https://www.thecgo.org/research/broadband-speeds-in-fibered-markets-an-empirical-analysis/).
