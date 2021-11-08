** mcrnj 
** (model comparison plot by RNJ)
** November 7, 2021
** rnjones@brown.edu
* ---------------------------------------------------------
cap program drop mcrnj
program define mcrnj

#d ;
syntax varlist(min=2 max=2) [ ,  
   xtitle(string) 
	ytitle(string) 
   modeltype(string)  
	alpha(real .05) 
        caliper(real .3)
	* ]
;
#d cr

qui {

if "`xtitle'"=="" {
	local xtitle "`2'"
}
if "`ytitle'"=="" {
	local ytitle "`1'"
}
if "modeltype"=="" {
	local modeltype=="rcs"
}

preserve
drop if missing(`1')
drop if missing(`2')
keep `1' `2'


if "`modeltype'" == "rcs" {
   mkspline rcs = `2' , cubic nknots(5)
   reg gcp5 rcs* 
	local r2 = `e(r2)'
	local rn = `e(N)'
}

if "`modeltype'" == "deming" {
	cor gcp5 gcp6
	***local r2 = `r(rho)'^2
	local rn = `r(N)'
	deming gcp5 gcp6
	mat b=e(b)
	local r2 =  1-(e(rmse)^2)/(e(sdy)^2)
}
* pdif is the predicted y
predict pdif , xb
predict pdifstdp , stdp
su `1'
scalar e = `r(Var)'*sqrt(1-`r2')
* Two kinds of confidence intervals around pdif
* ± t(df,a)*standard deviation of predicted values <- standard error of estimate
* ± t(df,a)*sqrt(sd of predicted values)*(1-r2) <- standard error of prediction
gen pdifli_see = pdif+invt(`c(N)'-2,(`alpha'/2))*pdifstdp
gen pdifui_see = pdif+invt(`c(N)'-2,(1-`alpha'/2))*pdifstdp
gen pdifli_sep = pdif+invt(`c(N)'-2,(`alpha'/2))*(pdifstdp^.5)*sqrt(1-`r2')
gen pdifui_sep = pdif+invt(`c(N)'-2,(1-`alpha'/2))*(pdifstdp^.5)*sqrt(1-`r2')
gen refu=`2'+`caliper'
gen refl=`2'-`caliper'
gen ref0=`2'


local I = .85 // intensity
local a = 85 // transparency
local color_red "237 28 36*`I'%50"
local color_brown "78 54 41*`I'%50"
local color_gold "255 199 144*`I'%50"
local color_skyblue "89 203 232*`I'%`a'"
local color_emerald "0 179 152*`I'%`a'"
local color_navy "0 60 113*`I'%`a'"
local color_taupe "183 176 156*`I'%25"

local r2  : di %3.2f `r2'
local r2 = subinstr("`r2'","0.",".",.)
_pctile `1' , p(15)
local yloc1 =`r(r1)'
su `1'
local yloc2 = ((`yloc1'-`r(min)')*.66)+`r(min)'
_pctile `2' , p(85)
local xloc1 = `r(r1)' // not all the way done with this yet
su `2'
local xloc1 = `xloc1'+(`r(max)'-`xloc1')*.5
di `xloc1'

* aspect
su `1'
local rangey=`r(max)'-`r(min)'
su `2'
local rangex=`r(max)'-`r(min)'
local aspect=`rangey'/`rangex'

sort `2'
gr tw ///
   (rarea pdifui_sep pdifli_sep `2' , color("`color_taupe'") lc(black%0)) ///
   (rarea pdifui_see pdifli_see `2' , color("`color_gold'") lc(black%0)) ///
	(line pdif `2', lp(solid) lc(white)) ///
   (scatter gcp5 `2' if inrange(`1',refl,refu),  ms(o) mc("`color_brown'")) ///
   (scatter gcp5 `2' if inrange(`1',refl,refu)~=1,  ms(o) mc("`color_red'")) ///
	(lfit refu `2' , lp(dash) lc("`color_skyblue'")) ///
	(lfit refl `2' , lp(dash) lc("`color_skyblue'")) ///
	(lfit ref0 `2' , lp(solid) lc("`color_skyblue'")) ///
   , legend(off) ///
	xtitle("`xtitle'") ///
	ytitle("`ytitle'") ///
   text(`yloc1' `xloc1' "r{superscript:2} = `r2'") ///
   text(`yloc2' `xloc1'  "N = `rn'") ///	
	aspect(`aspect') `options'
gr save g1.gph , replace

*graph export g2alt.png , width(1500) replace 

foreach y in pdifui_sep pdifli_sep  pdifui_see pdifli_see pdif `1' refu refl ref0 {
	gen c`y'=`y'-`2'
}

gr tw ///
   (rarea cpdifui_sep cpdifli_sep `2' , color("`color_taupe'") lc(black%0)) ///
   (rarea cpdifui_see cpdifli_see `2' , color("`color_gold'") lc(black%0)) ///
	(line cpdif `2', lp(solid) lc(white)) ///
   (scatter c`1' `2' if inrange(`1',refl,refu),  ms(o) mc("`color_brown'")) ///
   (scatter c`1' `2' if inrange(`1',refl,refu)~=1,  ms(o) mc("`color_red'")) ///
	(lfit crefu `2' , lp(dash) lc("`color_skyblue'")) ///
	(lfit crefl `2' , lp(dash) lc("`color_skyblue'")) ///
	(lfit cref0 `2' , lp(solid) lc("`color_skyblue'")) ///
   , legend(off) ///
	xtitle("`xtitle'") ///
	ytitle("`ytitle' - `xtitle'") ///
	aspect(`aspect')  `options'
	
gr save g2.gph , replace

gr combine g1.gph g2.gph 

restore 
}


end


