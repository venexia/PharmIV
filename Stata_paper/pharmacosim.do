cap prog drop pharmacosim
prog def pharmacosim, rclass
	args n prob_z1 delta num_sim cond_z0 cond_z1 id rho
		forvalues j=1/`num_sim' {
			quietly {
			
			use "$data/seedrecord.dta", clear
			local s = S[`j'+((`id'-1)*`num_sim')]
			set seed `s'
			
			clear
			
			set obs `n'

			//This allows us to calculate the conditional probabilties of X using pi and the frequency of IV/exposure
			//Value of the normal CDF for when Z=0
			local c0=invnormal(`cond_z0')
			//Value of the normal CDF for when Z=1
			local c1=invnormal(`cond_z1')
			//Difference in normal CDFs between values of the IV
			local dd=`c1'-`c0'
			
			gen z = rbinomial(1,`prob_z1')
			gen v = rnormal(0,1)
			gen u = rnormal(0,1)
	
			gen x = (`c0'+z*`dd'+v>0)
			gen y = x*`delta'+`rho'*v+(1-`rho'^2)^0.5*u		
			
			keep x y z
			
			count if x==1	
			local x1 = r(N)/`n'
			count if z==1
			local z1 = r(N)/`n'
			count if x==1 & z==0
			local int_x1z0 = r(N)/`n'
			local cond_x1z0 = (`int_x1z0')/(1-`z1')
			count if x==1 & z==1
			local int_x1z1 = r(N)/`n'
			local cond_x1z1 = (`int_x1z1')/(`z1')
			
			save "$data/reginput.dta", replace
			reg y x,ro
			if `j'==1 {
				capture erase "$data/regresults.dta"
				regsave using "$data/regresults.dta", ci addlabel(sim_num,`j',seed,`s',x1,`x1',z1,`z1',int_x1z0,`int_x1z0',int_x1z1,`int_x1z1',cond_x1z0,`cond_x1z0',cond_x1z1,`cond_x1z1')
			}
			else {
				regsave using "$data/regresults.dta", append ci addlabel(sim_num,`j',seed,`s',x1,`x1',z1,`z1',int_x1z0,`int_x1z0',int_x1z1,`int_x1z1',cond_x1z0,`cond_x1z0',cond_x1z1,`cond_x1z1')
			}
			ivreg2 y (x=z),ro 
			if `j'==1 {
				capture erase "$data/ivregresults.dta"
				regsave using "$data/ivregresults.dta", ci addlabel(sim_num,`j',seed,`s',x1,`x1',z1,`z1',int_x1z0,`int_x1z0',int_x1z1,`int_x1z1',cond_x1z0,`cond_x1z0',cond_x1z1,`cond_x1z1')
			}
			else {
				regsave using "$data/ivregresults.dta", append ci addlabel(sim_num,`j',seed,`s',x1,`x1',z1,`z1',int_x1z0,`int_x1z0',int_x1z1,`int_x1z1',cond_x1z0,`cond_x1z0',cond_x1z1,`cond_x1z1')
			}
			
			clear
			
			}
		di "Rep `j'"
		}
		
		use "$data/ivregresults.dta", clear
		drop if var=="_cons"
		drop var
		gen excl_null = (0<ci_lower | 0>ci_upper)
		sum excl_null
		local simulation = (r(sum)/r(N))
		local simulation = round(100*`simulation',.1)
		return scalar simulation = `simulation'
		foreach v of varlist x1 z1 int_x1z0 int_x1z1 cond_x1z0 cond_x1z1 {
			sum `v'
			local stat = r(mean)
			return scalar `v' = `stat'
		}
end
