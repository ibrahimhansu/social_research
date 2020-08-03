


//              		


/// -1- DATA WRANGLING

// Module 2, 1990

foreach var in 363 96 18 147 151 176 9 181 358{
	recode V`var' (-1=.), gen(v`var')
}

recode V363 (-1=.), gen(income)
recode V355 (-2=.), gen(age)
rename (v96 v18 v147 v151 v176 v9 v181 v358) (satisfaction happiness attendrelig religiousp godimport religimport marital employment)
rename V234 childrelig
recode marital (1/2=1) (else=0), gen(married)
recode happiness (1=4) (2=3) (3=2) (4=1)
replace attendrelig=attendrelig-1 if attendrelig>5
replace attendrelig=8-attendrelig
recode religiousp (2/3=0), gen(religdummy)
replace religimport=5-religimport
recode employment (1/3=1) (4/8=0)
recode childrelig (2=0)
replace V83=6-V83
rename V83 health
egen z2health=std(health)
gen female=V353-1

gen nhappiness=(happiness-1)/3
gen nsatisfaction=satisfaction/10
gen ndv=(nsatisfaction+nhappiness)/2

keep income age ndv nhappiness nsatisfaction attendrelig religiousp religdummy godimport religimport marital employment childrelig married z2health female

// Module 6, 2011

foreach var in 239 23 10 145 147 152 9 229 57 19 242 240 11 {
    recode V`var' (-10/-1=.), gen(v`var')
}
rename (v239 v23 v10 v145 v147 v152 v9 v229 v57 v19 v242 v240 v11) (income satisfaction happiness attendrelig religiousp godimport religimport employment marital childrelig age sex health)
recode marital (1/2=1) (else=0), gen(married)
recode happiness (1=4) (2=3) (3=2) (4=1)
replace attendrelig=8-attendrelig
recode religiousp (2/3=0), gen(religdummy)
replace religimport=5-religimport
recode employment (1/3=1) (4/8=0)
recode childrelig (2=0)
replace health=5-health

gen nhappiness=(happiness-1)/3
gen nsatisfaction=satisfaction/10
gen ndv=(nsatisfaction+nhappiness)/2

keep income age ndv nhappiness nsatisfaction attendrelig religiousp religdummy godimport religimport marital employment childrelig married z2health








/// -2- DESCRIPTIVE STATS

// ttest, Table 1

generate nreligimport = (religimport-1)/3
generate overallrelig = (religdummy + nreligimport)/2
ttest overallrelig, by(module) level(99)

// summary, Table 2-3

asdoc summarize ndv income employment z2health age religdummy married godimport religimport attendrelig if module==0
asdoc summarize ndv income employment z2health age religdummy married godimport religimport attendrelig if module==1







/// -3- INTERACTION ANALYSES


// Table 2

reg ndv female income employment married z2health age age_sqr i.module religdummy attendrelig religimport godimport

reg ndv female income employment married z2health age age_sqr i.module##c.attendrelig if e(sample)
outreg2 using intereg.doc, replace

reg ndv female income employment married z2health age age_sqr i.module##c.religdummy if e(sample)
outreg2 using intereg.doc, append

reg ndv female income employment married z2health age age_sqr i.module##c.religimport if e(sample)
outreg2 using intereg.doc, append

reg ndv female income employment married z2health age age_sqr i.module##c.godimport if e(sample)
outreg2 using intereg.doc, append


// Graphs

//- attendrelig 
reg ndv female income employment married z2health age age_sqr i.module religdummy attendrelig religimport godimport

reg ndv female income employment married z2health age age_sqr i.module##c.attendrelig if e(sample)
margins, dydx(attendrelig) at(module=(0(1)1) (median) female income employment married z2health age_sqr)
marginsplot

//- godimport 

reg ndv female income employment married z2health age age_sqr i.module religdummy attendrelig religimport godimport

reg ndv female income employment married z2health age age_sqr i.module##c.godimport if e(sample)
margins, dydx(godimport) at(module=(0(1)1) (median) female income employment married z2health age_sqr)
marginsplot

//- religdummy 
reg ndv female income employment married z2health age age_sqr i.module religdummy attendrelig religimport godimport

reg ndv female income employment married z2health age age_sqr i.module##c.religdummy if e(sample)
margins, dydx(religdummy) at(module=(0(1)1) (median) female income employment married z2health age_sqr)
marginsplot

//- religimport 
reg ndv female income employment married z2health age age_sqr i.module religdummy attendrelig religimport godimport

reg ndv female income employment married z2health age age_sqr i.module##c.religimport if e(sample)
margins, dydx(religimport) at(module=(0(1)1) (median) female income employment married z2health age_sqr)
marginsplot







/// -4- APPENDIX

 // Figure A1
 
use "C:\Users\ibr\Desktop\merged2.dta" 
hist income if module==0, percent name(doksan) norm
hist income if module==0, percent name(doksan) norm replace
hist income if module==0, percent name(doksan, replace) norm
hist income if module==1, percent norm name(onbir, rename)
hist income if module==1, percent norm name(onbir, replace)
graph combine doksan onbir, row(1) ycommon xcommon
graph combine doksan onbir, row(1) ycommon xcommon
hist income if module==0, percent xtitle("Income Distribution") name(doksan, replace) norm
hist income if module==1, xtitle("Income Distribution") percent norm name(onbir, replace)
graph combine doksan onbir, row(1) ycommon xcommon name(combined)


// Table A1.1

reg ndv female income employment married z2health age age_sqr attendrelig if module==0
outreg2 using splitreg.doc, replace
reg ndv female income employment married z2health age age_sqr religimport if module==0
outreg2 using splitreg.doc, append
reg ndv female income employment married z2health age age_sqr godimport if module==0
outreg2 using splitreg.doc, append
reg ndv female income employment married z2health age age_sqr religdummy if module==0
outreg2 using splitreg.doc, append

// Table A2.2

reg ndv female income employment married z2health age age_sqr attendrelig if module==1
outreg2 using splitreg.doc, replace
reg ndv female income employment married z2health age age_sqr religimport if module==1
outreg2 using splitreg.doc, append
reg ndv female income employment married z2health age age_sqr godimport if module==1
outreg2 using splitreg.doc, append
reg ndv female income employment married z2health age age_sqr religdummy if module==1
outreg2 using splitreg.doc, append












