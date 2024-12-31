*************************************************************************************
***** This file replicates Tables 1 through 5 in Ozabaci and Rubini, "Hide the Cookie
***** Jar: Nudging Towards Healthy Eating", Journal of the Economic Science Association.
***** 12/26/2024.
*************************************************************************************



* Table 1

use stillings_until2019, clear

replace s18 = 0
replace s18 = 1 if date0>date("12/31/17","MDY",2019) & date0<date("8/1/18","MDY",2019)
replace f18 = 0
replace f18 = 1 if date0>date("8/1/18","MDY",2019) & date0<date("12/31/18","MDY",2019)
replace s19 = 0
replace s19 = 1 if date0>date("12/31/18","MDY",2019) & date0<date("8/1/19","MDY",2019)

drop if consu<0
drop if consu>999
drop if Service == 1

tabstat consu if sweet == 1, s(mean sd N) format(%10.2fc) save
tabstat consu if sweet == 0, s(mean sd N) format(%10.2fc) save

gen sweet_all = consu if sweet == 1
gen savory_all = consu if sweet == 0

gen sweet_F17 = consu if sweet == 1 & postchange == 0
gen savory_F17 = consu if sweet == 0 & postchange == 0

gen sweet_S18 = consu if sweet == 1 & s18 == 1
gen savory_S18 = consu if sweet == 0 & s18 == 1

gen sweet_F18 = consu if sweet == 1 & f18 == 1
gen savory_F18 = consu if sweet == 0 & f18 == 1

gen sweet_S19 = consu if sweet == 1 & s19 == 1
gen savory_S19 = consu if sweet == 0 & s19 == 1

gen sweet_post = consu if sweet == 1 & postchange == 1
gen savory_post = consu if sweet == 0 & postchange == 1

gen sweet_weekF17 = consu if sweet == 1 & postchange == 0 & Day<7
gen savory_weekF17 = consu if sweet == 0 & postchange == 0 & Day<7

gen sweet_weekpost = consu if sweet == 1 & postchange == 1 & Day<7
gen savory_weekpost = consu if sweet == 0 & postchange == 1 & Day<7

gen sweet_weekendF17 = consu if sweet == 1 & postchange == 0 & Day==7
gen savory_weekendF17 = consu if sweet == 0 & postchange == 0 & Day==7

gen sweet_weekendpost = consu if sweet == 1 & postchange == 1 & Day==7
gen savory_weekendpost = consu if sweet == 0 & postchange == 1 & Day==7

gen sweet_lunchF17 = consu if sweet == 1 & postchange == 0 & Service == 2
gen savory_lunchF17 = consu if sweet == 0 & postchange == 0 & Service == 2

gen sweet_lunchpost = consu if sweet == 1 & postchange == 1 & Service == 2
gen savory_lunchpost = consu if sweet == 0 & postchange == 1 & Service == 2

gen sweet_dinnerF17 = consu if sweet == 1 & postchange == 0 & Service == 3
gen savory_dinnerF17 = consu if sweet == 0 & postchange == 0 & Service == 3

gen sweet_dinnerpost = consu if sweet == 1 & postchange == 1 & Service == 3
gen savory_dinnerpost = consu if sweet == 0 & postchange == 1 & Service == 3




tabstat sweet_*, s(mean sd N) format(%10.2fc) save
matrix sweet_T = r(StatTotal)
tabstat savory_*, s(mean sd N) format(%10.2fc) save
matrix savory_T = r(StatTotal)

* Table 2 

clear

use stillings_until2019, clear

* ssc inst egenmore Needed
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

xtset Number_Notes date1


quietly{
poisson consu i.postchange i.sweet i.postchange#i.sweet, vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, No, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
estimates store nofeest

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
estimates store feest

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)

estimates store fallest

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.weekend, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, Yes, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
estimates store weekdayest


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, No, Trend, No, Finals Week, No, Options, No, Sample, All)
estimates store dayest


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, yes, Trend, No, Finals Week, No, Options, No, Sample, All)
estimates store serviceest

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, No, Options, No, Sample, All)
estimates store trendest

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, No, Sample, All)
estimates store finals

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1 products, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, Yes, Sample, All)
estimates store numberofproducts

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1 i.fall#i.sweet, fe vce(robust)
outreg2 using stillings_results2_pois, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, Yes, Sample, All)
estimates store fallcookieinter

}

estimates table nofeest feest fallest weekdayest dayest serviceest trendest finals numberofproducts fallcookieinter,star keep(postchange#sweet) b(%9.4f)
estimates table nofeest feest fallest weekdayest dayest serviceest trendest finals numberofproducts fallcookieinter, keep(postchange#sweet) b(%9.4f) se(%9.4f)


* Table 3
quietly{

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Service trend trend2 i.final1 if weekend == 0, fe vce(robust)
outreg2 using stillings_subsample, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekday FE, No, Service FE, Yes, Trend, Yes, , Finals Week, Yes, Subsample, Weekend)
estimates store trendestweekday


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Service trend trend2 i.final1 if weekend == 1, fe vce(robust)
outreg2 using stillings_subsample, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekday FE, No, Service FE, Yes, Trend, Yes, , Finals Week, Yes, Subsample, Weekdays)
estimates store trendestweekend


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day trend trend2 i.final1 if Service == 2, fe vce(robust)
outreg2 using stillings_subsample, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekday FE, Yes, Service FE, No, Trend, Yes, , Finals Week, Yes, Subsample, Lunch)
estimates store trendestlunch


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day trend trend2 i.final1 if Service == 3, fe vce(robust)
outreg2 using stillings_subsample, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekday FE, Yes, Service FE, No, Trend, Yes, , Finals Week, Yes, Subsample, Dinner)
estimates store trendestdinner

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 if final1==1, fe vce(robust)
outreg2 using stillings_subsample, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, No, Subsample, Finals Week)
estimates store finalsyes

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 if final1==0, fe vce(robust)
outreg2 using stillings_subsample, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes Subsample, Non-Finals Week)
estimates store finalsno

}

estimates table trendestweekday trendestweekend trendestlunch trendestdinner finalsyes finalsno,star keep(postchange#sweet) b(%9.4f)

estimates table trendestweekday trendestweekend trendestlunch trendestdinner finalsyes finalsno,keep(postchange#sweet) b(%9.4f) se(%9.4f)



* Table 4

quietly{

poisson consu i.postchange i.sweet i.postchange#i.sweet if fall == 1, vce(robust)
outreg2 using stillings_results2_pois22, append tex dec(4) eqkeep(N) addtext(Product FE, No, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No)
estimates store nofeest

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet if fall == 1, fe vce(robust)
outreg2 using stillings_results2_pois22, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No)
estimates store feest


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall if fall == 1, fe vce(robust)
outreg2 using stillings_results2_pois22, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, No, Service FE, No, Trend, No)

estimates store fallest


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.weekend if fall == 1, fe vce(robust)
outreg2 using stillings_results2_pois22, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, Yes, Weekday FE, No, Service FE, No, Trend, No)
estimates store weekdayest


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day if fall == 1, fe vce(robust)
outreg2 using stillings_results2_pois22, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, No, Trend, No)
estimates store dayest


xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service if fall == 1, fe vce(robust)
outreg2 using stillings_results2_pois22, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, yes, Trend, No)
estimates store serviceest

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 if fall == 1, fe vce(robust)
outreg2 using stillings_results2_pois22, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes)
estimates store trendest
* Pseudo R2         =     0.7013

xtpoisson consu i.postchange i.sweet i.postchange#i.sweet i.fall i.Day i.Service trend trend2 i.final1 if fall == 1, fe vce(robust)
outreg2 using stillings_results2_pois22, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes, Options, No, Sample, All)
estimates store finals


}

estimates table nofeest feest fallest weekdayest dayest serviceest trendest finals,star keep(postchange#sweet) b(%9.4f)
estimates table nofeest feest fallest weekdayest dayest serviceest trendest finals,keep(postchange#sweet) b(%9.4f) se(%9.4f)



*replicate Table 5
gen postchange2 = 0
replace postchange2 = 1 if fall == 1 

quietly{





poisson consu i.postchange2 i.sweet i.postchange2#i.sweet if year0==2018, vce(robust)
outreg2 using stillings_placebo, append tex dec(4) eqkeep(N) addtext(Product FE, No, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No)
estimates store nofeest

xtpoisson consu  i.postchange2 i.sweet i.postchange2#i.sweet  if year0==2018, fe vce(robust)
outreg2 using stillings_placebo, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, No, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No)
estimates store feest


xtpoisson consu   i.postchange2 i.sweet i.fall i.postchange2#i.sweet if year0==2018, fe vce(robust)
outreg2 using stillings_placebo, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No)
estimates store fallest


xtpoisson consu  i.postchange2#i.sweet i.postchange2 i.sweet i.fall i.weekend if year0==2018, fe vce(robust)
outreg2 using stillings_placebo, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, Yes, Weekday FE, No, Service FE, No, Trend, No, Finals Week, No)
estimates store weekdayest


xtpoisson consu  i.postchange2#i.sweet i.postchange2 i.sweet i.fall i.Day if year0==2018, fe vce(robust)
outreg2 using stillings_placebo, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, No, Trend, No, Finals Week, No)
estimates store dayest


xtpoisson consu  i.postchange2#i.sweet i.postchange2 i.sweet i.fall i.Day i.Service if year0==2018, fe vce(robust)
outreg2 using stillings_placebo, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, yes, Trend, No, Finals Week, No)
estimates store serviceest

xtpoisson consu  i.postchange2#i.sweet i.postchange2 i.sweet i.fall i.Day i.Service trend trend2 if year0==2018, fe vce(robust)
outreg2 using stillings_placebo, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, No)
estimates store trendest

xtpoisson consu  postchange2#sweet i.postchange2 i.sweet i.fall i.Day i.Service trend trend2 i.final1 if year0==2018, fe vce(robust)
outreg2 using stillings_placebo, append tex dec(4) eqkeep(N) addtext(Product FE, Yes, Fall FE, Yes, Weekend, No, Weekday FE, Yes, Service FE, Yes, Trend, Yes, Finals Week, Yes)
estimates store finals
}

estimates table nofeest feest fallest weekdayest dayest serviceest trendest finals,star keep(postchange#sweet) b(%9.4f)
estimates table nofeest feest fallest weekdayest dayest serviceest trendest finals,keep(postchange#sweet) b(%9.4f) se(%9.4f)
