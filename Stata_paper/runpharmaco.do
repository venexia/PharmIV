// Setup project

global project "E:/IVPower/pharmaco"
global dofiles "$project/do_files"
global data "$project/data"
cd $project

// Run necessary functions and packages

run "$dofiles/pharmacoseed.do"
run "$dofiles/pharmacosim.do"
run "$dofiles/PharmIV.ado"
run "$dofiles/pharmacograph.do"

// Generate .dta file containing parameter combinations

clear
set obs 27
egen n = seq(), from(1) to(3) block(9)
replace n = n*10000
egen prob_x1 = seq(), from(1) to (3) block(3)
replace prob_x1 = 0.100 if prob_x1 == 1
replace prob_x1 = 0.250 if prob_x1 == 2
replace prob_x1 = 0.500 if prob_x1 == 3
egen cond_z1 = seq(), from(1) to (3)
replace cond_z1 = 0.150 if cond_z1 == 1
replace cond_z1 = 0.300 if cond_z1 == 2
replace cond_z1 = 0.450 if cond_z1 == 3
gen prob_z1 = 0.200
gen cond_z0 = (prob_x1 - (cond_z1*prob_z1))/(1-prob_z1)
gen beta_0 = 0.200
gen beta_1 = 0.050
gen rho = 0
gen alpha = 0.050
gen id = _n
gen delta = beta_1 - beta_0
gen num_sim = 100
gen simulation = .
gen formula = .
save "$data/simdata.dta", replace

// Calculate the formula and run simulation for each parameter combination

local end = _N
forvalues i = 1/`end' {
	use "$data/simdata.dta", clear
	foreach var of varlist _all {
		local `var' = `var'[`i']
	}
	qui PharmIV, n(`n') prob_z1(`prob_z1') prob_x1(`prob_x1') delta(`delta') alpha(`alpha') cond_z0(`cond_z0') cond_z1(`cond_z1')
	use "$data/simdata.dta", clear
	replace formula = r(PharmIV) if id==`i'
	save "$data/simdata.dta", replace
	qui pharmacosim `n' `prob_z1' `delta' `num_sim' `cond_z0' `cond_z1' `id' `rho'
	use "$data/simdata.dta", clear
	replace simulation = r(simulation) if id==`i'
	save "$data/simdata.dta", replace
}
drop id
compress

// Save results

save "$data/simdata.dta", replace
export excel "$project/data/simresults.xlsx", first(variable) replace

