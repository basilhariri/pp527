/** Healthcare coverage changes from 2009-2019
 *  @authors: Basil Hariri, Brooks Bolsinger, and Kelsey Figone
 *  Relevant variables: 
 * 		hcovany - Any health insurance coverage
 *		year = 2009 or 2019
 *		statefip - state of residence
 *		race - respondent's race
 */

clear
//ACS 1-year estimates for 2009 and 2019 survey data
use "acs.dta"

/*********************************************************/
/******************* OVERALL COVERAGE ********************/
/*********************************************************/
//Recoding and adjusting labels to make healthcare coverage 0/1 instead of 1/2
recode hcovany (1=0) (2=1)
label define recoded_hcovany_lbl 0 "No health insurance coverage" 1 "With health insurance coverage"
label values hcovany recoded_hcovany_lbl

//Overall health care rates increased from 2009 (pre-ACA) -> 2019 (post-ACA)
ttest hcovany, by(year) level(99)

/*********************************************************/
/***************** MEDICAID EXPANSION ********************/
/*********************************************************/
//Did the state expand Medicaid prior to 2019?
gen medicaid_expansion = .
replace medicaid_expansion = 0 if inlist(statefip, 1, 12, 13, 16, 20, 23, 28, 29, 31, 37, 40, 45, 46, 47, 48, 49, 51, 55, 56)
replace medicaid_expansion = 1 if inlist(statefip, 2, 4, 5, 6, 8, 9, 10, 15, 17, 18, 19, 21, 22, 24, 25, 26, 27, 30, 32, 33, 34, 35, 36, 38, 39, 41, 42, 44, 50, 53, 54)
label define medicaid_expansion_lbl 0 "No expanded Medicaid access" 1 "Expanded Medicaid access"
label values medicaid_expansion medicaid_expansion_lbl

//Compare changes in healthcare coverage in states that did vs did not adopt/implement Medicaid expansion
ttest hcovany if medicaid_expansion == 0, by(year) level(99)
ttest hcovany if medicaid_expansion == 1, by(year) level(99)

/*********************************************************/
/*********************** RACE ****************************/
/*********************************************************/
ttest hcovany if race == 1, by(year) level(99) //White
ttest hcovany if race == 2, by(year) level(99) //Black/African American/Negro
ttest hcovany if race == 3, by(year) level(99) //American Indian or Alaska Native
ttest hcovany if race == 4, by(year) level(99) //Chinese
ttest hcovany if race == 5, by(year) level(99) //Japanese
ttest hcovany if race == 6, by(year) level(99) //Other Asian or Pacific Islander
ttest hcovany if race == 7, by(year) level(99) //Other
ttest hcovany if race == 8, by(year) level(99) //Two races
ttest hcovany if race == 9, by(year) level(99) //Three or more

/*********************************************************/
/******************* VISUALIZATIONS **********************/
/*********************************************************/
graph bar (mean) hcovany, over(year)
graph bar (mean) hcovany, over(year) over(medicaid_expansion)
graph bar (mean) hcovany, over(year, gap(2)) over(medicaid_expansion, gap(40)) blabel(bar, format(%3.2g)) ytitle(% Covered) title(Coverage Rates by Medicaid Expansion Status)

/*********************************************************/
/********************* REFERENCE *************************/
/*********************************************************/
//Get state codes from statefip variable
//label list statefip_lbl
/* Source for adoption/implementation by state: 
 * https://www.kff.org/medicaid/issue-brief/status-of-state-medicaid-expansion-decisions-interactive-map/
   1 Alabama - Did not adopt
   2 Alaska  
   4 Arizona
   5 Arkansas
   6 California
   8 Colorado
   9 Connecticut
   10 Delaware
   11 District of Columbia - Adopted despite non-statehood (included in analysis)
   12 Florida - Did not adopt
   13 Georgia - Did not adopt
   15 Hawaii
   16 Idaho - coverage implemented in 2020
   17 Illinois
   18 Indiana
   19 Iowa
   20 Kansas - Did not adopt
   21 Kentucky
   22 Louisiana
   23 Maine - coverage implemented in 2019
   24 Maryland
   25 Massachusetts
   26 Michigan
   27 Minnesota
   28 Mississippi - Did not adopt
   29 Missouri - Adopted but not yet implemented
   30 Montana 
   31 Nebraska - coverage implemented in 2020
   32 Nevada
   33 New Hampshire
   34 New Jersey
   35 New Mexico
   36 New York
   37 North Carolina - Did not adopt
   38 North Dakota
   39 Ohio
   40 Oklahoma - Adopted but not yet implemented
   41 Oregon
   42 Pennsylvania
   44 Rhode Island
   45 South Carolina - Did not adopt
   46 South Dakota - Did not adopt
   47 Tennessee - Did not adopt
   48 Texas - Did not adopt
   49 Utah - coverage implemented in 2020
   50 Vermont
   51 Virginia - coverage implemented in 2019
   53 Washington
   54 West Virginia
   55 Wisconsin - Did not adopt
   56 Wyoming - Did not adopt
*/