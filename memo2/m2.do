clear
use "california_schools_api.dta" 

/* Relevant variables: meals, full, both
 * Hypothesis: Schools that have more students with meal-eligibility have a smaller
 * number of fully qualified teachers (i.e. poor kids have worse teachers).
 */

//Create a high-income variable for schools with <50% of students eligible for subsidized meals
gen high_income = 0
replace high_income = . if meals == .
replace high_income = 1 if meals < 50
//Relationship between school success and high-income variable
tab high_income both, row nofreq
ttest both, by(high_income)

//Create a qualified_teachers variable for schools with >90% of fully-qualified teachers
gen qualified_teachers = 0
replace qualified_teachers = . if full == .
replace qualified_teachers = 1 if full >= 90
//Relationship between school success and qualified_teachers variable
tab qualified_teachers both, row nofreq
ttest both, by(qualified_teachers)

//Relationship between high income and fully-qualified teachers
//Shows that higher family income of students correlates with more qualified teachers
tab high_income qualified_teachers, row nofreq
ttest qualified_teachers, by(high_income)

/* Figure 1 = tab qualified_teachers both, row nofreq
 * Figure 2 = tab high_income both, row nofreq
 * Figure 3 = tab high_income qualified_teachers, row nofreq
 */