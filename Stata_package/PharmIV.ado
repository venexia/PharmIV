prog def PharmIV, rclass
	version 1.0
	
	_parse comma lhs rhs : 0

	local wc : word count `rhs'
	tokenize "`rhs'"
	
	local n = .
	local delta = .
	local sigma = 1
	local alpha = 0.05
	local prob_x1 = .
	local prob_z1 = .
	local cond_z1 = .
	local cond_z0 = .
	
	forval i = 2/`wc' {
		local start = strpos("``i''","(")
		local name = substr("``i''",1,`start'-1)
		local end = strpos("``i''",")")
		local value = substr("``i''",`start'+1,`end'-`start'-1)
		local `name' = `value'
	}

	if `n'==. {
		di "Please specify the sample size (n)."
		exit
	}
	
	if `delta'==. {
		di "Please specify the detectable treatment effect (delta)."
		exit
	}
	
	local c = 0
	foreach l in prob_x1 prob_z1 cond_z1 cond_z0{
		if ``l''==. {
			local c = `c' + 1
		}
	}
	if `c'>1 {
		di "At least three of the following must be specified: P(X=1), P(Z=1), P(X=1|Z=1), P(X=1|Z=0)."
		exit
	}
	
	
	if (`prob_x1'<0 | `prob_x1'>1) & `prob_x1'!=. {
		di "Please specify the parameters so that P(X=1) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1)."
		exit
    }
	
	if (`prob_z1'<0 | `prob_z1'>1) & `prob_z1'!=. {
		di "Please specify the parameters so that P(Z=1) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1)."
		exit
	}
	
	
	if (`cond_z1'<0 | `cond_z1'>1) & `cond_z1'!=. {
		di "Please specify the parameters so that P(X=1||Z=1) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1)."
		exit
    }
	
	if (`cond_z0'<0 | `cond_z0'>1) & `cond_z0'!=. {
		di "Please specify the parameters so that P(X=1||Z=0) is a valid probability that satisfies P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1)."
		exit
    }
	
	if `prob_z1'==. {
		local prob_z1 = (`prob_x1' - `cond_z0')/(`cond_z1' - `cond_z0')
		local name = "prob_z1"
	}
	
	if `prob_x1'==.{
		local prob_x1 = (`cond_z0'*(1-`prob_z1')) + (`cond_z1'*`prob_z1')
		local name = "prob_x1"
	}
	
	if `cond_z1'==. {
		local cond_z1 = (`prob_x1' - (`cond_z0'*(1-`prob_z1')))/`prob_z1'
		local name = "cond_z1"
	}
	
	if `cond_z0'==. {
		local cond_z0 = (`prob_x1' - (`cond_z1'*`prob_z1'))/(1-`prob_z1')
		local name = "cond_z0"
	}
	
	local check = ((`cond_z0'*(1-`prob_z1')) + (`cond_z1'*`prob_z1'))
	if (abs(`check'-`prob_x1'))>1e-10 {
		di "TPlease specify the parameters so that P(X=1) = P(X=1|Z=0)(1-P(Z=1)) + P(X=1|Z=1)P(Z=1) is satisfied."
		exit
	}
	
	local psi = invnormal(`cond_z0')
	local pi = `psi' - invnormal(`cond_z1')
	local int_z1 = `cond_z1'*`prob_z1'
	local c_alpha = invnormal(1-(`alpha'/2))
	local sigma = 1
	local info = (`n'*((`int_z1' - (`prob_z1'*`prob_x1'))^2))/(`prob_z1'*(1-`prob_z1'))
	local term = `delta'/(`sigma'*sqrt(1/`info'))
	local temp = normal(-`c_alpha'+`term')+normal(-`c_alpha'-`term')
	local PharmIV = cond(`cond_z0'>=0 & `cond_z0'<=1 &`cond_z1'>=0 & `cond_z1'<=1 & `prob_z1'>=0 & `prob_z1'<=1 & `prob_x1'>=0 & `prob_x1'<=1 & `prob_x1'<0.05+(`cond_z0'*(1-`prob_z1')) + (`cond_z1'*`prob_z1') & `prob_x1'>-0.05+(`cond_z0'*(1-`prob_z1')) + (`cond_z1'*`prob_z1'),`temp',.,.)
	return scalar PharmIV = `PharmIV'
	return scalar `name' = ``name''
	local x = round(100*`PharmIV',.1)
	di "The power of the study is `x'%"
	
end
