{smcl}
{hline}
Help file for {hi:mcrnj}
{hline}

{p 4 4 2}
mcrnj prepares a measurement comparison plot.

{hline}

{p 8 17 2}
{cmd: mcrnj} {it:varlist} [ , 
 {hi: ytitle(}{it:string} [default is yvar]{hi:)} 
 {hi: xtitle(}{it:string} [default is xvar]{hi:)} 
 {hi: alpha(}{it:real}    [default is .05]{hi:)} 
 {hi: caliper(}{it:real}    [default is .3]{hi:)} 
 {hi: modeltype(}{it:string} [default is rcs]{hi:)} 
 {it:anything} ]

{title:Description}

{p 4 4 2}
{cmd: mcrnj} prepares a two-panel plot. The left panel is a
scatterplot of {it:yvar} by {it:xvar}. Reference lines at
{it:yvar=xvar} and {it:yvar=xvar±caliper} are shown. The
points in the scatterplot are colored according to whether
they are within or outside of the caliper. A predicted line
using {it:modeltype} (restricted cubic spline regression
[modeltype(rcs)] or Deming regression [modeltype(deming)]) is
shown. Two sets of 1-{it:alpha}% confidence regions (with
critical values from the {it:t} distribution), one (narrower,
gold color) using using the standard error of estimate  -- for
comparing within the sample -- and the other (wider, taupe
color) using the standard error of prediction -- for
prediction out of sample -- are shown. The right panel is the
scatterplot with {it:yvar} and derivatives centered at
{it:xvar}.

{p 4 4 2}
Use of the  {hi: modeltype(}{it:deming}{hi:)} option requires
the {it:deming} module be installed. If you don't have it
installed try typing  {hi: findit deming}.

{title:Example}

{p 8 8 2} 
.  {hi:mcrnj gcp5 gcp6 , modeltype(rcs) ytitle(Video) xtitle(Telephone) note(regression using restricted cubic splines for telephone)}

{p 8 8 2} 
.  {hi:mcrnj gcp5 gcp6 , modeltype(deming) ytitle(Video) xtitle(Telephone) note(regression using Deming regression for telephone)}

{p 4 4 2}
Here is an example of the plot produced with the 
{hi: modeltype(rcs)} option 
{browse "https://imgur.com/a/PyKPoie"}

{p 4 4 2}
Here is an example of the plot produced with the 
{hi: modeltype(deming)} option 
{browse "https://imgur.com/a/OGLOdfc"}

{title:Author}
   
    Richard N. Jones
    Brown University
    {browse "mailto:richard_jones@brown.edu":richard_jones@brown.edu}

    
    




