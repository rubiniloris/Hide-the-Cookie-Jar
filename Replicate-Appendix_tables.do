*************************************************************************************
***** This file replicates the tables in the Online Appendix in Ozabaci and Rubini, 
***** "Hide the Cookie Jar: Nudging Towards Healthy Eating", Journal of the Economic 
***** Science Association.
***** 12/26/2024.
*************************************************************************************



clear

use stillings_until2019, clear



* ssc inst egenmore
egen products = nvals(Number_Notes), by(date1 Service) 
egen products1 = nvals(Number_Notes), by(date1) 
egen products2 = nvals(Number_Notes), by(date0 Service) 


gen final1=0
replace final1=1 if date0>td(1dec2017)&date0<td(1jan2018)
replace final1=1 if date0>td(1may2018)&date0<td(1jun2018)
replace final1=1 if date0>td(1dec2018)&date0<td(1jan2019)

gen firsttwoweeks=0
replace firsttwoweeks=1 if date0>td(1aug2017)&date0<td(11sep2017)
replace firsttwoweeks=1 if date0>td(1aug2018)&date0<td(10sep2018)
replace firsttwoweeks=1 if date0>td(1jan2018)&date0<td(7feb2018)
replace firsttwoweeks=1 if date0>td(1jan2019)&date0<td(6feb2019)

gen firsttwoweeksf1=0
replace firsttwoweeksf1=1 if date0>td(1aug2017)&date0<td(11sep2017)

gen firsttwoweeksf2=0
replace firsttwoweeksf2=1 if date0>td(1aug2018)&date0<td(10sep2018)

gen firsttwoweekss1=0
replace firsttwoweekss1=1 if date0>td(1jan2018)&date0<td(7feb2018)

gen firsttwoweekss2=0
replace firsttwoweekss2=1 if date0>td(1jan2019)&date0<td(6feb2019)

* There are only 17 observations with pizza on breakfast, so eliminate breakfast from analysis
drop if Service == 1
drop if consu<0
drop if consu==2000
*drop if 
drop if consu==2000

replace consu=. if Forecast==0
*save "/Users/do1024/Desktop/estimates_cookies/data.cookies.dta"


*use "/Users/do1024/Desktop/cookies-codes-desktop files/data.cookies.dta"

xtset Number_Notes date1


*replicates Appendix Table B1

quietly{
reg consu i.postchange i.sweet i.postchange#i.sweet, vce(robust)
outreg2 using stillings_results2_linear, append tex dec(4) eqkeep(N) addtext(Product FE, No, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
* Pseudo R2         =     0.0105
estimates store nofeest

xtreg consu i.postchange i.sweet i.postchange#i.sweet, fe vce(robust)
outreg2 using stillings_results2_linear, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
* Pseudo R2         =     0.6842
estimates store feest


xtreg consu i.postchange i.sweet i.postchange#i.sweet i.fall, fe vce(robust)
outreg2 using stillings_results2_linear, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
* Pseudo R2         =     0.6851

estimates store fallest


xtreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.weekend, fe vce(robust)
outreg2 using stillings_results2_linear, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, Yes, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
*  Pseudo R2         =     0.6903
estimates store weekdayest


xtreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day, fe vce(robust)
outreg2 using stillings_results2_linear, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
*Pseudo R2         =     0.6959
estimates store dayest


xtreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service, fe vce(robust)
outreg2 using stillings_results2_linear, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, yes, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
estimates store serviceest
*Pseudo R2         =     0.7012
*quietly{

xtreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2, fe vce(robust)
outreg2 using stillings_results2_linear, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, No, Options, No, Sample, All)
estimates store trendest
* Pseudo R2         =     0.7013

xtreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1, fe vce(robust)
outreg2 using stillings_results2_linear, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, No, Sample, All)
estimates store finals

xtreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1 products, fe vce(robust)
outreg2 using stillings_results2_linear, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, Yes, Sample, All)
estimates store numberofproducts


xtreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1 i.fall#i.sweet, fe vce(robust)
outreg2 using stillings_results2_linear, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, Yes, Sample, All)
estimates store interaction

}

estimates table nofeest feest fallest weekdayest dayest serviceest trendest finals numberofproducts interaction,star keep(postchange#sweet) b(%9.4f)
estimates table nofeest feest fallest weekdayest dayest serviceest trendest finals numberofproducts interaction,keep(postchange#sweet) b(%9.4f) se(%9.4f)



*replicates Appendix Table B2

quietly{
nbreg consu i.postchange i.sweet i.postchange#i.sweet
outreg2 using stillings_results2_nbreg, append tex dec(4) eqkeep(N) addtext(Product FE, No, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
* Pseudo R2         =     0.0105
* 0.0075
estimates store nofeest

xtnbreg consu i.postchange i.sweet i.postchange#i.sweet, fe 
outreg2 using stillings_results2_nbreg, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
* Pseudo R2         =     0.6842
estimates store feest


xtnbreg consu i.postchange i.sweet i.postchange#i.sweet i.fall, fe 
outreg2 using stillings_results2_nbreg, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
* Pseudo R2         =     0.6851

estimates store fallest


xtnbreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.weekend, fe 
outreg2 using stillings_results2_nbreg, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, Yes, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
*  Pseudo R2         =     0.6903
estimates store weekdayest


xtnbreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day, fe 
outreg2 using stillings_results2_nbreg, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
*Pseudo R2         =     0.6959
estimates store dayest


xtnbreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service, fe 
outreg2 using stillings_results2_nbreg, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, yes, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
estimates store serviceest
*Pseudo R2         =     0.7012

xtnbreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2, fe 
outreg2 using stillings_results2_nbreg, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, No, Options, No, Sample, All)
estimates store trendest
* Pseudo R2         =     0.7013

xtnbreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1, fe 
outreg2 using stillings_results2_nbreg, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, No, Sample, All)
estimates store finals

xtnbreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1 products, fe 
outreg2 using stillings_results2_nbreg, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, Yes, Sample, All)
estimates store numberofproducts

xtnbreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1 i.fall#i.sweet, fe 
outreg2 using stillings_results2_pois_withinter, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, Yes, Cookie*Fall, No, Sample, Takeaway-able)
estimates store interact





xtnbreg consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1 products firsttwoweeksf1 firsttwoweeksf2 firsttwoweekss1 firsttwoweekss2, fe 
outreg2 using stillings_results2_nbreg, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, Yes, Sample, All)
estimates store firstweeks

}


estimates table nofeest feest fallest weekdayest dayest serviceest trendest finals numberofproducts interact,star keep(postchange#sweet) b(%9.4f)
estimates table nofeest feest fallest weekdayest dayest serviceest trendest finals numberofproducts interact,keep(postchange#sweet) b(%9.4f) se(%9.4f)


*replicates Appendix Table B3

*gen lunch2=1 if Service==2
*replace lunch2=0 if Service==3

gen dinner2=1 if Service==3
replace dinner2=0 if Service==2

quietly{

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Service trend trend2 i.final1 i.postchange#i.sweet#i.weekend, fe vce(robust)
outreg2 using stillings_results2_inter, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, No, Sample, All)
estimates store weekend


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day trend trend2 i.final1 i.postchange#i.sweet#i.dinner2, fe vce(robust)
outreg2 using stillings_results2_inter, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, No, Sample, All)
estimates store dinner


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.postchange#i.sweet#i.final1, fe vce(robust)
outreg2 using stillings_results2_inter, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, No, Sample, All)
estimates store finals


}

estimates table weekend dinner finals,star keep(postchange#sweet i.postchange#i.sweet#i.weekend i.postchange#i.sweet#i.dinner2 i.postchange#i.sweet#i.final1) b(%9.4f)
estimates table weekend dinner finals, keep(postchange#sweet i.postchange#i.sweet#i.weekend i.postchange#i.sweet#i.dinner2 i.postchange#i.sweet#i.final1) b(%9.4f) se(%9.4f)


*replicates Appendix Table E5

poisson consu i.postchange i.sweet i.postchange#i.sweet, vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, No, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
* Pseudo R2         =     0.0105
* 0.0075
estimates store nofeest

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
* Pseudo R2         =     0.6842
estimates store feest


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
* Pseudo R2         =     0.6851

estimates store fallest


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.weekend, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, Yes, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
*  Pseudo R2         =     0.6903
estimates store weekdayest


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
*Pseudo R2         =     0.6959
estimates store dayest


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, yes, Trend, No, Finals Week, No, Options, No, Sample, All)
*, Trend2, No)
estimates store serviceest
*Pseudo R2         =     0.7012

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, No, Options, No, Sample, All)
estimates store trendest
* Pseudo R2         =     0.7013

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, No, Sample, All)
estimates store finals

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1 products, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, Yes, Sample, All)
estimates store numberofproducts


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1 i.fall#i.sweet, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, Yes, Sample, All)
estimates store fallcookieinter







