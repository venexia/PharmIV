cap prog drop pharmacoseed
prog def pharmacoseed
args seed sample_size num_sim
	local num_obs = `sample_size'*`num_sim'
	clear
	set seed `seed'
	set obs `num_obs'
	local a 1
	local b 100000
	gen S = `a'+int((`b'-`a'+1)*runiform())
	save "$data/seedrecord.dta", replace
end
