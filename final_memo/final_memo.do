/** Healthcare coverage changes from 2009-2019
 *  @authors: Basil Hariri, Brooks Bolsinger, and Kelsey Figone
 *  Relevant variables: 
 * 		hcovany - Any health insurance coverage
 * 		hcovpriv - Private health insurance coverage
 *		hcovpub - Public coverage
 *		hinsemp - coverage through employer/union
 *		year = 2009 or 2019
 *		statefip - state of residence
 *		race - respondent's race
 */

clear
//ACS 1-year estimates for 2009 and 2019 survey data
use acs.dta 

//Drop irrelevant variables
drop absent acrehous ancestr1 ancestr1d ancestr2 ancestr2d appal appald arrives availble bedrooms birthqtr birthyr bpl bpld builtyr2 carpool cbnsubfam cbserial cbsfrelate cbsftype cbsubfam cidatapln cidial cihispeed cilaptop cinethh ciothcomp ciothsvc cisat cismrtphn citablet citizen city cityerr citypop classwkr classwkrd cluster cntry commuse condofee conspuma costelec costfuel costgas costwatr countyfip countyicp coupletype cpuma0010 degfield degfield2 degfield2d degfieldd density departs diffcare diffeye diffhear diffmob diffphys diffrem diffsens divinyr edscor50 edscor90 educ educd eldch erscor50 erscor90 famsize famunit farm farmprod fertyr foodstmp fridge ftotinc fuelheat gchouse gcmonths gcrespon gq gradeatt gradeattd hiufpgbase hiufpginc homeland hotwater hwsei incbus00 incearn incinvst incother incretir incss incsupp inctot incwage incwelfr ind ind1950 ind1990 indnaics insincl kitchen language languaged lingisol looking marrinyr marrno marst met2013 met2013err metarea metaread metpop00 metpop10 metro migcity1 migcounty1 migmet1 migmet131 migmet13err migplac1 migpuma1 migpums1 migrate1 migrate1d migtype1 moblhome mom2rule momloc momloc2 momrule mortamt1 mortamt2 mortgag2 mortgage movedin multgen multgend nchild nchlt5 ncouples nfams nfathers nmothers npboss50 npboss90 nsibs nsubfam owncost ownershp ownershpd pctmetro phone plumbing pop2rule poploc poploc2 poprule poverty prent presgl probai probapi probblk proboth probwht propinsr proptx99 puma pumasupr pwcity pwcounty pwmet13 pwmet13err pwmetro pwpuma00 pwpumas pwstate2 pwtype region relate related rent rentgrs rentmeal riders rooms schltype school sei sfrelate sftype shower sink speakeng sploc sprule ssmc statefip stateicp stove strata subfam taxincl toilet trantime tranwork tribe tribed uhrswork unitsstr vacancy valueh vehicles vet01ltr vet47x50 vet55x64 vet75x80 vet75x90 vet80x90 vet90x01 vetdisab vetkorea vetother vetstat vetstatd vetvietn vetwwii widinyr wkswork1 wkswork2 workedyr wrklstwk wrkrecal yngch yrimmig yrmarr yrnatur yrsusa1 yrsusa2 hcov*2 hins*2 hiurule hiuid hiunpers

//Recoding to make healthcare variables 0/1 instead of 1/2
recode hcovany hcovpriv hcovpub hinsemp (1=0) (2=1)
//Adjusting labels to fit recoding
label define recoded_hcovany_lbl 0 "No health insurance coverage" 1 "With health insurance coverage"
label values hcovany recoded_hcovany_lbl
label define recoded_hcovpriv_lbl 0 "No private health insurance coverage" 1 "With private health insurance coverage"
label values hcovpriv recoded_hcovpriv_lbl
label define recoded_hcovpub_lbl 0 "No public health insurance coverage" 1 "With public health insurance coverage"
label values hcovpub recoded_hcovpub_lbl
label define recoded_hinsemp_lbl 0 "No employee/union health insurance coverage" 1 "With employee/union health insurance coverage"
label values hinsemp recoded_hinsemp_lbl


/*********************************************************/
/********************** GENERAL **************************/
/*********************************************************/
//Overall health care rates increased from 2009 (pre-ACA) -> 2019 (post-ACA)
ttest hcovany, by(year)
//Private health care rates decreased from 2009 (pre-ACA) -> 2019 (post-ACA)
ttest hcovpriv, by(year)
//Private health care rates controlled for employment from 2009 (pre-ACA) -> 2019 (post-ACA)
ttest hcovpriv if empstat == 1, by(year)
//Public health care rates increased from 2009 (pre-ACA) -> 2019 (post-ACA)
ttest hcovpub, by(year)

/*********************************************************/
/***************** MEDICAID EXPANSION ********************/
/*********************************************************/
//Did the state expand Medicaid prior to 2019?
gen medicaid_expansion = .
replace medicaid_expansion = 0 if inlist(statefip, 1, 12, 13, 16, 20, 23, 28, 29, 31, 37, 40, 45, 46, 47, 48, 49, 51, 55, 56)
replace medicaid_expansion = 1 if inlist(statefip, 2, 4, 5, 6, 8, 9, 10, 15, 17, 18, 19, 21, 22, 24, 25, 26, 27, 30, 32, 33, 34, 35, 36, 38, 39, 41, 42, 44, 50, 53, 54)

//Compare changes in healthcare coverage in states that did vs did not adopt/implement Medicaid expansion
ttest hcovany if medicaid_expansion == 0, by(year)	//~4% increase
ttest hcovany if medicaid_expansion == 1, by(year)	//~5.6% increase

/*********************************************************/
/*********************** RACE ****************************/
/*********************************************************/
ttest hcovany if race == 1, by(year) //White
ttest hcovany if race == 2, by(year) //Black/African American/Negro
ttest hcovany if race == 3, by(year) //American Indian or Alaska Native
ttest hcovany if race == 4, by(year) //Chinese
ttest hcovany if race == 5, by(year) //Japanese
ttest hcovany if race == 6, by(year) //Other Asian or Pacific Islander


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