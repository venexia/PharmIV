qui {

	clear
	local B = 4
	local N = 300
	set obs `N'
	gen id = _n
	run "$dofiles/pharmacoformula.do"

	gen n = id*100
	gen prob_z1 = 0.20
	gen beta_0 = 0.20
	gen beta_1 = 0.05
	gen delta = beta_1 - beta_0
	gen alpha = 0.05
	gen cond_z1 = 0.15
	forvalues i = 1/`B' {
		gen exp_`i' = (0.125*`i')
		local exp_`i' = exp_`i'[1]
		local di_exp_`i' : di %4.3f `exp_`i''
		gen cond_z0_`i' = .
		gen formula_`i' = .
	}

	save "$data/temp/powercurve.dta", replace

	qui {
		forvalues j = 1/`B' {
			forvalues i = 1/`N' {
				use "$data/temp/powercurve.dta", clear
				local prob_x1 = exp_`j'[`i']
				local cond_z0 = cond_z0_`j'[`i']
				foreach x in n prob_z1 beta_0 beta_1 delta alpha cond_z1 {
					local `x' = `x'[`i']
					local di_`x' : di %4.3f ``x''
				}
				PharmIV, n(`n') prob_z1(`prob_z1') prob_x1(`prob_x1') delta(`delta') alpha(`alpha') cond_z1(`cond_z1')
				use "$data/temp/powercurve.dta", clear
				replace formula_`j' = 100*r(PharmIV) if id==`i'
				replace cond_z0_`j' = r(cond_z0) if id==`i' 
				local di_cond_z0_`j' : di %4.3f cond_z0_`j'[1]
				save "$data/temp/powercurve.dta", replace
			}
		}
	}

	local name = "powercurve"
	#delimit ;
	twoway 
	(line formula_1 n, lwidth(thin))
	(line formula_2 n, lwidth(thin))
	(line formula_3 n, lwidth(thin))
	(line formula_4 n, lwidth(thin))
	,
	name("`name'", replace)
	legend(order(
		1 "P(X=1) = `di_exp_1', P(X=1|Z=0) = `di_cond_z0_1'" 
		2 "P(X=1) = `di_exp_2', P(X=1|Z=0) = `di_cond_z0_2'" 
		3 "P(X=1) = `di_exp_3', P(X=1|Z=0) = `di_cond_z0_3'" 
		4 "P(X=1) = `di_exp_4', P(X=1|Z=0) = `di_cond_z0_4'" 
		) cols(1) size(small))
	xtitle("Sample Size",size(small))
	xlabel(0(5000)30000, angle(horizontal) labsize(small)) 
	ytitle("Power (%)",size(small))
	ylabel(0(20)100, angle(horizontal) nogrid labsize(small)) 
	title(, size(small))
	text(100 0
		"P(Z=1) = `di_prob_z1'"
		"P(X=1 | Z=1) = `di_cond_z1'"
		"delta = `di_delta'"
		, size(small) just(left) place(se))
	scheme(sj);
	#delimit cr
	graph export "$output/`name'.tif", replace width(2250)
}
