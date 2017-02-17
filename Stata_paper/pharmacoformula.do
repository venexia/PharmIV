cap prog drop pharmacoformula
prog def pharmacoformula, rclass
	args sample_size freq_iv freq_exp delta sig cond_x1z0 cond_x1z1
	local psi = invnormal(`cond_x1z0')
	local pi = `psi' - invnormal(`cond_x1z1')
	local int_x1z1 = `cond_x1z1'*`freq_iv'
	local c_alpha = invnormal(1-(`sig'/2))
	local sigma = 1
	local info = (`sample_size'*((`int_x1z1' - (`freq_iv'*`freq_exp'))^2))/(`freq_iv'*(1-`freq_iv'))
	local term = `delta'/(`sigma'*sqrt(1/`info'))
	local temp = normal(-`c_alpha'+`term')+normal(-`c_alpha'-`term')
	local formula = cond(`cond_x1z0'>=0 & `cond_x1z0'<=1 &`cond_x1z1'>=0 & `cond_x1z1'<=1 & `freq_iv'>=0 & `freq_iv'<=1 & `freq_exp'>=0 & `freq_exp'<=1 & `freq_exp'<0.05+(`cond_x1z0'*(1-`freq_iv')) + (`cond_x1z1'*`freq_iv') & `freq_exp'>-0.05+(`cond_x1z0'*(1-`freq_iv')) + (`cond_x1z1'*`freq_iv'),`temp',.,.)
	return scalar formula = `formula'
	return scalar psi = `psi'
	return scalar pi = `pi'
	return scalar int_x1z1 = `int_x1z1'
	return scalar info = `info'
end
