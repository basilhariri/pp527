clear
use "california_schools_api.dta" 

/* Relevant variables: meals, full, both
 * Hypothesis: Schools that have more students with meal-eligibility have a smaller
 * number of fully qualified teachers (i.e. poor kids have worse teachers).
 */

*Cut subsidized-meal eligibility into ranges from 0-10, 10-20, 20-30, etc
egen meals_slice = cut(meals), at(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
*Cut teacher qualification percentages into ranges from 0-10, 10-20, 20-30, etc
egen full_slice =  cut(full), at(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)

*%age of meal-subsidized range that met both targets
tab meals_slice both, row nofreq
*%age of fully qualified range that met both targets
tab full_slice both, row nofreq

*Fewer meal subsidy qualified students correlates with more qualified teachers
tab meals_slice full_slice, row nofreq

/* Figure 1 = tab full_slice both, row nofreq
 * Figure 2 = tab meals_slice both, row nofreq
 * Figure 3 = tab meals_slice full_slice, row nofreq 
 */