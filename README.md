# Form 477 Panels
This project assembles a nine-part panel dataset of [Form 477](https://www.fcc.gov/general/broadband-deployment-data-fcc-form-477) broadband data from December 2014 through December 2018, sourced from the Federal Communications Commission. The Form 477 dataset reports fixed broadband service at the Census block level in the United States. The panel also includes demographic data for the years 2014 to 2018 from the U.S. Census Bureau, including:

- Population Density for U.S. block groups,
- Housing Density for U.S. block groups, and
- Median Income for U.S. tracts.

You may use this repo to recreate the dataset used by and replicate the econometric results of [Kotrous and Bailey (2020)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2607729). Due to insufficient RAM, we analyze a panel that samples 25 percent of U.S. Census tracts at random. My guess is you need at least 64 GB of RAM to load the full panel into Stata and execute the provided econometric tests. If you wish to work with the full panel, simply modify `master.do` to execute `append-full.do`, rather than `append-random.do`.

## License
This project uses the MIT License, so you are free to copy and modify the code as it suits your research needs. The panel retains geographic identifiers for Census blocks, block groups, tracts, counties, and states, so joining additional demographic data should be fairly straightforward.

## Dependencies
The code was most recently executed in Stata 16.1. Earlier versions of this code could be executed in Stata 14, so I expect this code will be compatible with most flavors of Stata.

The do file for econometric tests, `broadbandcompetition-panel.do`, uses the [estout](http://repec.sowi.unibe.ch/stata/estout/) package to export regression tables in RTF/Word and LaTeX formats. I strongly recommend installing it for this and other Stata projects!

## Setting up your Environment
In the repo working directory, create two new directories: crosssection (note three s's) and source.

**crosssection**: This directory is used to store each of the nine cross-sections of Form 477 data that has been joined with Census data. You are okay to leave this directory empty. It will be populated with files as the Stata scripts execute.

**source**: This directory is used to store all source files (in csv format) from FCC, the U.S. Census Bureau, and U.S. Bureau of Labor Statistics. This directory must be populated with source files in order to work. You can download an archive ([.zip](https://form477-panels.s3.us-east-2.amazonaws.com/form477-panels.zip); [.tar.gz](https://form477-panels.s3.us-east-2.amazonaws.com/form477-panels.tar.gz)) of the source files used in Kotrous and Bailey (2020). These files require just under 40 GB of storage.

If you wish to see the final dataset or use it to run econometric tests, you can [download the final dataset](https://form477-panels.s3.us-east-2.amazonaws.com/US-Fixed-Panel-Random-Merged.dta) (~7 GB) used in Kotrous and Bailey (2020).

## Supporting the Project
Collecting the data took considerable effort, and storing the source files and allowing you to retrieve them is not free. If you use or enjoy this repository, I would appreciate you [buying me a beer](https://paypal.me/michaelkotrous)! 🍺

I would love to hear from you if you publish any research that uses or was inspired by this repository! If you do so, please cite: 

Kotrous, Michael and James B. Bailey. "Broadband Speeds in Fibered Markets: An Empirical Analysis." Paper presented at _2021 TPRC/48th Research Conference on Communication, Information and Internet Policy_, December 4, 2020. [http://dx.doi.org/10.2139/ssrn.2607729](http://dx.doi.org/10.2139/ssrn.2607729).
