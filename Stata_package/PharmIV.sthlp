{smcl}
{* *! version 1.2.1  07mar2013}{...}
{viewerjumpto "Syntax" "PharmIV##syntax"}{...}
{viewerjumpto "Description" "PharmIV##description"}{...}
{viewerjumpto "Remarks" "PharmIV##remarks"}{...}
{viewerjumpto "Examples" "PharmIV##examples"}{...}
{title:Title}

{phang}
{bf:PharmIV} {hline 2} Power calculator for instrumental variable analysis in pharmacoepidemiology


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:PharmIV:}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent :* {opt n:}}sample size{p_end}
{p2coldent :* {opt delta:}}detectable treatment effect{p_end}
{synopt:  {opt alpha:}}significance level; default is {cmd:0.05}{p_end}
{synopt:  {opt sigma:}}residual variance; default is {cmd:1.00}{p_end}
{p2coldent :* {opt prob_x1:}}frequency of exposure, P(X=1){p_end}
{p2coldent :* {opt prob_z1:}}frequency of instrument, P(Z=1){p_end}
{p2coldent :* {opt cond_z1:}}probability of exposure given the instrument Z=1, P(X=1|Z=1){p_end}
{p2coldent :* {opt cond_z0:}}probability of exposure given the instrument Z=0, P(X=1|Z=0){p_end}
{synoptline}
{pstd} * Both {opt n} or {opt delta} are required. At least three of the following four are also required: {opt prob_x1}, {opt prob_z1}, {opt cond_z1}, {opt cond_z0}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:PharmIV} calculates the power of instrumental variable analysis studies using a single binary instrument Z to analyse the causal effect of a binary exposure X on a continuous outcome Y.

{marker remarks}{...}
{title:Remarks}

{pstd}
For detailed information, see:

{pstd}
Walker, V. M., Davies, N. M., Windmeijer, F., Burgess, S. & Martin, R. M. Power calculator for instrumental variable analysis in pharmacoepidemiology. bioRxiv 084541 (2016). doi:10.1101/084541


{marker examples}{...}
{title:Examples}

{phang}{cmd:. PharmIV, n(10000) delta(0.20) alpha(0.05) sigma(1) prob_x1(0.50) prob_z1(0.20) cond_z1(0.22) cond_z0(0.57)}{p_end}

{phang}{cmd:. PharmIV, n(10000) delta(0.20) alpha(0.05) sigma(1) prob_x1(0.50) prob_z1(0.20) cond_z1(0.22)}{p_end}

{phang}{cmd:. PharmIV, n(10000) delta(0.20) alpha(0.05) sigma(1) prob_x1(0.50) prob_z1(0.20) cond_z0(0.57)}{p_end}

{phang}{cmd:. PharmIV, n(10000) delta(0.20) prob_x1(0.50) prob_z1(0.20) cond_z1(0.22)}{p_end}
