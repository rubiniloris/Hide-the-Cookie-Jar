*************************************************************************************
***** This file replicates the Figures in Ozabaci and Rubini, "Hide the Cookie
***** Jar: Nudging Towards Healthy Eating", Journal of the Economic Science Association.
***** 12/26/2024.
*************************************************************************************

cls
graph set window fontface "Times New Roman"

* This file replicates the figures in the paper "Hide the Cookie Jar: Nudging Towards Healthy Eating", by D. Ozabaci and L. Rubini
* 12/20/2024

* Load the data

cd "/Users/lorisrubini/Library/CloudStorage/OneDrive-USNH/Stillings/Analysis_2017_2019"

import excel cookie_names_classified.xlsx, sheet("Sheet1") cellrange(A1:B110) firstrow clear

* Clean it

rename Takeawayfr~y taf
 
merge 1:m Name using "/Users/lorisrubini/Library/CloudStorage/OneDrive-USNH/Stillings/DATA (used this)/stillings_until2019.dta"

replace Name = "BROWNIE, BLONDE-CP" if Name == "BROWNIE, BLONIE-CP"
replace Name = "CAKE, HOLL TURTLE BAR SHEET" if Name == "CAHE, HOLL TURTLE BAR SHEET"
graph drop _all

preserve

drop if Service == 3
drop if Service == 1

gen quant = Toprepare - Leftorccwhenout

replace quant = . if quant == 0

drop if quant >= 2000
drop if quant<0
bysort Service trend date0: egen totCookies = sum(quant) if sweet == 1
bysort Service trend date0: egen totPizza = sum(quant) if sweet == 0

bysort  trend date0: egen totCookiesld = sum(quant) if sweet == 1 
bysort  trend date0: egen totPizzald = sum(quant) if sweet == 0 

duplicates drop date0 sweet, force

drop if date0<date("20170930","YMD")

* Run regressions related to the production of the plots

sort year0 fall Service trend

sum totCookiesld if date0<date("20171231","YMD")
scalar meancookies = r(mean)

sum totPizzald if date0<date("20171231","YMD")
scalar meanpizza = r(mean)

regress totCookiesld trend if fall == 1 & year0 == 2017
gen cookiesfit = _b[_cons] + _b[trend]*trend  if fall == 1 & year0 == 2017

regress totPizzald trend if fall == 1 & year0 == 2017
gen pizzafit = _b[_cons] + _b[trend]*trend  if fall == 1 & year0 == 2017

* Pre-Trend
qui{
	regress totCookiesld trend if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	estimates store cookies_pre_trend
	scalar bcookies = _b[trend]
	scalar ccookies = _b[_cons]
	scalar lbcookies = r(table)[5,1]
	scalar ubcookies = r(table)[6,1]
	scalar lccookies = r(table)[5,2] 
	scalar uccookies = r(table)[6,2]
	
	regress totPizzald trend if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	estimates store pizza_pre_trend
	scalar bpizza = _b[trend]
	scalar cpizza = _b[_cons]
	scalar lbpizza = r(table)[5,1]
	scalar ubpizza = r(table)[6,1]
	scalar lcpizza = r(table)[5,2] 
	scalar ucpizza = r(table)[6,2]

	scalar normcookie = bcookies*28
	scalar normpizza = bpizza*28
	
	gen pretrend_cookies = bcookies*trend - normcookie  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_cookies_l = lbcookies*trend - normcookie  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_cookies_u = ubcookies*trend - normcookie  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_pizza = bpizza*trend - normpizza if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_pizza_l = lbpizza*trend - normpizza  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_pizza_u = ubpizza*trend - normpizza  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	
	gen totCookiesdm = totCookiesld - meancookies 
	gen totPizzadm = totPizzald  - meanpizza 
	
	* Post
	
	regress totCookiesld trend if fall == 0 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store cookies_pre_trend
	scalar bcookies2 = _b[trend]
	scalar ccookies2 = _b[_cons]
	scalar lbcookies2 = r(table)[5,1]
	scalar ubcookies2 = r(table)[6,1]
	scalar lccookies2 = r(table)[5,2] 
	scalar uccookies2 = r(table)[6,2]
	
	regress totPizzald trend if fall == 0 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store pizza_pre_trend
	scalar bpizza2 = _b[trend]
	scalar cpizza2 = _b[_cons]
	scalar lbpizza2 = r(table)[5,1]
	scalar ubpizza2 = r(table)[6,1]
	scalar lcpizza2 = r(table)[5,2] 
	scalar ucpizza2 = r(table)[6,2]

	
	
	gen postrend_cookies = bcookies2*trend + ccookies2 - meancookies 
	gen postrend_cookies_l = lbcookies2*trend + ccookies2 - meancookies
	gen postrend_cookies_u = ubcookies2*trend + ccookies2 - meancookies
	gen postrend_pizza = bpizza2*trend + cpizza2 - meanpizza 
	gen postrend_pizza_l = lbpizza2*trend + cpizza2 - meanpizza
	gen postrend_pizza_u = ubpizza2*trend + cpizza2 - meanpizza
	
	* Post - F18
	
	regress totCookiesld trend if fall == 1 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store cookies_pre_trend2
	scalar bcookies22 = _b[trend]
	scalar ccookies22 = _b[_cons]
	scalar lbcookies22 = r(table)[5,1]
	scalar ubcookies22 = r(table)[6,1]
	scalar lccookies22 = r(table)[5,2] 
	scalar uccookies22 = r(table)[6,2]
	
	regress totPizzald trend if fall == 1 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store pizza_pre_trend2
	scalar bpizza22 = _b[trend]
	scalar cpizza22 = _b[_cons]
	scalar lbpizza22 = r(table)[5,1]
	scalar ubpizza22 = r(table)[6,1]
	scalar lcpizza22 = r(table)[5,2] 
	scalar ucpizza22 = r(table)[6,2]

	
	
	gen postrend_cookies2 = bcookies22*trend + ccookies22 - ccookies - normcookie
	gen postrend_cookies_l2 = lbcookies22*trend + ccookies22 - normcookie
	gen postrend_cookies_u2 = ubcookies22*trend + ccookies22 - normcookie
	gen postrend_pizza2 = bpizza22*trend + cpizza22 - cpizza - normpizza
	gen postrend_pizza_l2 = lbpizza22*trend + cpizza22 - normpizza
	gen postrend_pizza_u2 = ubpizza22*trend + cpizza22 - normpizza

	* Post - S18 + F18
	
	regress totCookiesld trend if year0 == 2018 & date0>date("20171231","YMD")
	estimates store cookies_pre_trend23
	scalar bcookies223 = _b[trend]
	scalar ccookies223 = _b[_cons]
	scalar lbcookies223 = r(table)[5,1]
	scalar ubcookies223 = r(table)[6,1]
	scalar lccookies223 = r(table)[5,2] 
	scalar uccookies223 = r(table)[6,2]
	
	regress totPizzald trend if year0 == 2018 & date0>date("20171231","YMD")
	estimates store pizza_pre_trend23
	scalar bpizza223 = _b[trend]
	scalar cpizza223 = _b[_cons]
	scalar lbpizza223 = r(table)[5,1]
	scalar ubpizza223 = r(table)[6,1]
	scalar lcpizza223 = r(table)[5,2] 
	scalar ucpizza223 = r(table)[6,2]

	
	
	gen postrend_cookies23 = bcookies223*trend + ccookies223 - ccookies - normcookie
	gen postrend_cookies_l23 = lbcookies223*trend + ccookies223 - normcookie
	gen postrend_cookies_u23 = ubcookies223*trend + ccookies223 - normcookie
	gen postrend_pizza23 = bpizza223*trend + cpizza223 - cpizza - normpizza
	gen postrend_pizza_l23 = lbpizza223*trend + cpizza223 - normpizza
	gen postrend_pizza_u23 = ubpizza223*trend + cpizza223 - normpizza
	
	
*/
}

* LUNCH - Figures 1 and 2

* generate week indicator
gen weeker = week(date0)
bysort weeker: egen weekavgcookie = mean(totCookiesdm) if sweet == 1
bysort weeker: egen weekavgpizza = mean(totPizzadm) if sweet == 0
bysort weeker: egen trender = mean(trend)


quietly sum trend if fall == 1 & year0 == 2017
scalar maxtrend = r(max)
quietly sum trender if fall == 1 & year0 == 2017
scalar maxtrender = r(max)
qui sum trend if fall == 0 & year0 == 2018
scalar mintrend = r(min)
qui sum trender if fall == 0 & year0 == 2018
scalar mintrender = r(min)

gen trendcont = trend + maxtrend - mintrend +30
gen trendercont = trender + maxtrender - mintrender +30

* Figure 1

twoway (rarea pretrend_cookies_l pretrend_cookies_u trend if fall == 1 & year0 == 2017, sort color(ltblue%10)) ///
 (scatter weekavgcookie trender if fall == 1 & year0 == 2017,   mcolor(blue) msize(2-pt)) ///
 (line pretrend_cookies trend if fall == 1 & year0 == 2017,lcolor(blue)) ///
 (rarea pretrend_pizza_l pretrend_pizza_u trend if fall == 1 & year0 == 2017, sort color(red%05)) ///
 (scatter weekavgpizza trender if fall == 1 & year0 == 2017 ,  mcolor(red) msize(2-pt)) ///
 (line pretrend_pizza trend if fall == 1 & year0 == 2017,lcolor(red)) ///
 ,ylabel(-500(500)500) legend(order(2 "De-Meaned Cookies (week avg.)" 5 "De-Meaned Pizza (week avg.)" 3 "Linear Trend - Cookies" 6 "Linear Trend - Pizza" 1 "95% CI - Cookies" 4 "95% CI - Pizza") size(*0.9) region(lc(gs0)) cols(2) pos(6)) name(PreTrendavg) ytitle("") xtitle("Days since start of semester") graphregion(color(white)) 
 
graph export "/Users/lorisrubini/Library/CloudStorage/OneDrive-USNH/Stillings/Analysis_2017_2019/Pre and Post Trends - RR JESA/Final Submission/Figure1.pdf", as(pdf) name("PreTrendavg") replace

* Figure 2

twoway  ///
 (scatter weekavgcookie trender if fall == 1 & year0 == 2017,  mcolor(blue) msize(2-pt)) ///
 (line pretrend_cookies trend if fall == 1 & year0 == 2017,lcolor(blue)) ///
 (scatter weekavgpizza trender if fall == 1 & year0 == 2017 ,   mcolor(red) msize(2-pt)) ///
 (line pretrend_pizza trend if fall == 1 & year0 == 2017,lcolor(red)) ///
 (line postrend_cookies trendcont if fall == 0 & year0 == 2018 ,  lcolor(blue)  ) ///
 (line postrend_pizza trendcont if fall == 0 & year0 == 2018 ,  lcolor(red)  ) ///
 (scatter weekavgcookie trendercont if fall == 0 & year0 == 2018 ,   mcolor(blue) msize(2-pt)) ///
 (scatter weekavgpizza trendercont if fall == 0 & year0 == 2018 ,   mcolor(red) msize(2-pt)) ///
 ,ylabel(-500(500)500) legend(order(1 "De-Meaned Cookies (week avg.)" 3 "De-Meaned Pizza (week avg.)" 2 "Linear Trend - DM Cookies F17" 4 "Linear Trend - DM Pizza F17" 5 "Linear Trend - DM Cookies S18" 6 "Linear Trend - DM Pizza S18" ) size(*0.9) region(lc(gs0)) cols(2) pos(6)) name(PrePosTrendavg) ytitle("") xtitle("Days since start of academic year") graphregion(color(white)) xline(84.5, lcolor(gs10) lp(dash)) xline(110, lcolor(gs10) lp(dash)) text(450 150 "Spring 2018", color(gs10) ) text(450 50 "Fall 2017", color(gs10) ) text(450 98 "Winter", color(gs10) ) text(350 98 "Break", color(gs10) ) 
 
 
graph export "/Users/lorisrubini/Library/CloudStorage/OneDrive-USNH/Stillings/Analysis_2017_2019/Pre and Post Trends - RR JESA/Final Submission/Figure2.pdf", as(pdf) name("PrePosTrendavg") replace


***************************** Figures in Appendix ***************************

restore
preserve

************************ Figures C1 and C2 *********************************


drop if Service == 1
drop if Service == 2

gen quant = Toprepare - Leftorccwhenout

replace quant = . if quant == 0

drop if quant >= 2000
drop if quant<0
bysort Service trend date0: egen totCookies = sum(quant) if sweet == 1
bysort Service trend date0: egen totPizza = sum(quant) if sweet == 0

bysort  trend date0: egen totCookiesld = sum(quant) if sweet == 1 
bysort  trend date0: egen totPizzald = sum(quant) if sweet == 0 

duplicates drop date0 sweet, force

drop if date0<date("20170930","YMD")

* Run regressions related to the production of the plots

sort year0 fall Service trend

sum totCookiesld if date0<date("20171231","YMD")
scalar meancookies = r(mean)

sum totPizzald if date0<date("20171231","YMD")
scalar meanpizza = r(mean)

regress totCookiesld trend if fall == 1 & year0 == 2017
gen cookiesfit = _b[_cons] + _b[trend]*trend  if fall == 1 & year0 == 2017

regress totPizzald trend if fall == 1 & year0 == 2017
gen pizzafit = _b[_cons] + _b[trend]*trend  if fall == 1 & year0 == 2017

* Pre-Trend
qui{
	regress totCookiesld trend if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	estimates store cookies_pre_trend
	scalar bcookies = _b[trend]
	scalar ccookies = _b[_cons]
	scalar lbcookies = r(table)[5,1]
	scalar ubcookies = r(table)[6,1]
	scalar lccookies = r(table)[5,2] 
	scalar uccookies = r(table)[6,2]
	
	regress totPizzald trend if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	estimates store pizza_pre_trend
	scalar bpizza = _b[trend]
	scalar cpizza = _b[_cons]
	scalar lbpizza = r(table)[5,1]
	scalar ubpizza = r(table)[6,1]
	scalar lcpizza = r(table)[5,2] 
	scalar ucpizza = r(table)[6,2]

	scalar normcookie = bcookies*28
	scalar normpizza = bpizza*100
	
	gen pretrend_cookies = bcookies*trend - normcookie  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_cookies_l = lbcookies*trend - normcookie  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_cookies_u = ubcookies*trend - normcookie  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_pizza = bpizza*trend - normpizza if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_pizza_l = lbpizza*trend - normpizza  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_pizza_u = ubpizza*trend - normpizza  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	
	gen totCookiesdm = totCookiesld - meancookies 
	gen totPizzadm = totPizzald  - meanpizza 
	
	* Post
	
	regress totCookiesld trend if fall == 0 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store cookies_pre_trend
	scalar bcookies2 = _b[trend]
	scalar ccookies2 = _b[_cons]
	scalar lbcookies2 = r(table)[5,1]
	scalar ubcookies2 = r(table)[6,1]
	scalar lccookies2 = r(table)[5,2] 
	scalar uccookies2 = r(table)[6,2]
	
	regress totPizzald trend if fall == 0 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store pizza_pre_trend
	scalar bpizza2 = _b[trend]
	scalar cpizza2 = _b[_cons]
	scalar lbpizza2 = r(table)[5,1]
	scalar ubpizza2 = r(table)[6,1]
	scalar lcpizza2 = r(table)[5,2] 
	scalar ucpizza2 = r(table)[6,2]

	
	
	gen postrend_cookies = bcookies2*trend + ccookies2 - meancookies 
	gen postrend_cookies_l = lbcookies2*trend + ccookies2 - meancookies
	gen postrend_cookies_u = ubcookies2*trend + ccookies2 - meancookies
	gen postrend_pizza = bpizza2*trend + cpizza2 - meanpizza 
	gen postrend_pizza_l = lbpizza2*trend + cpizza2 - meanpizza
	gen postrend_pizza_u = ubpizza2*trend + cpizza2 - meanpizza
	
	* Post - F18
	
	regress totCookiesld trend if fall == 1 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store cookies_pre_trend2
	scalar bcookies22 = _b[trend]
	scalar ccookies22 = _b[_cons]
	scalar lbcookies22 = r(table)[5,1]
	scalar ubcookies22 = r(table)[6,1]
	scalar lccookies22 = r(table)[5,2] 
	scalar uccookies22 = r(table)[6,2]
	
	regress totPizzald trend if fall == 1 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store pizza_pre_trend2
	scalar bpizza22 = _b[trend]
	scalar cpizza22 = _b[_cons]
	scalar lbpizza22 = r(table)[5,1]
	scalar ubpizza22 = r(table)[6,1]
	scalar lcpizza22 = r(table)[5,2] 
	scalar ucpizza22 = r(table)[6,2]

	
	
	gen postrend_cookies2 = bcookies22*trend + ccookies22 - ccookies - normcookie
	gen postrend_cookies_l2 = lbcookies22*trend + ccookies22 - normcookie
	gen postrend_cookies_u2 = ubcookies22*trend + ccookies22 - normcookie
	gen postrend_pizza2 = bpizza22*trend + cpizza22 - cpizza - normpizza
	gen postrend_pizza_l2 = lbpizza22*trend + cpizza22 - normpizza
	gen postrend_pizza_u2 = ubpizza22*trend + cpizza22 - normpizza

	* Post - S18 + F18
	
	regress totCookiesld trend if year0 == 2018 & date0>date("20171231","YMD")
	estimates store cookies_pre_trend23
	scalar bcookies223 = _b[trend]
	scalar ccookies223 = _b[_cons]
	scalar lbcookies223 = r(table)[5,1]
	scalar ubcookies223 = r(table)[6,1]
	scalar lccookies223 = r(table)[5,2] 
	scalar uccookies223 = r(table)[6,2]
	
	regress totPizzald trend if year0 == 2018 & date0>date("20171231","YMD")
	estimates store pizza_pre_trend23
	scalar bpizza223 = _b[trend]
	scalar cpizza223 = _b[_cons]
	scalar lbpizza223 = r(table)[5,1]
	scalar ubpizza223 = r(table)[6,1]
	scalar lcpizza223 = r(table)[5,2] 
	scalar ucpizza223 = r(table)[6,2]

	
	
	gen postrend_cookies23 = bcookies223*trend + ccookies223 - ccookies - normcookie
	gen postrend_cookies_l23 = lbcookies223*trend + ccookies223 - normcookie
	gen postrend_cookies_u23 = ubcookies223*trend + ccookies223 - normcookie
	gen postrend_pizza23 = bpizza223*trend + cpizza223 - cpizza - normpizza
	gen postrend_pizza_l23 = lbpizza223*trend + cpizza223 - normpizza
	gen postrend_pizza_u23 = ubpizza223*trend + cpizza223 - normpizza
	
	
*/
}

* Dinner - Figures C1 and C2

* generate week indicator
gen weeker = week(date0)
bysort weeker: egen weekavgcookie = mean(totCookiesdm) if sweet == 1
bysort weeker: egen weekavgpizza = mean(totPizzadm) if sweet == 0
bysort weeker: egen trender = mean(trend)


quietly sum trend if fall == 1 & year0 == 2017
scalar maxtrend = r(max)
quietly sum trender if fall == 1 & year0 == 2017
scalar maxtrender = r(max)
qui sum trend if fall == 0 & year0 == 2018
scalar mintrend = r(min)
qui sum trender if fall == 0 & year0 == 2018
scalar mintrender = r(min)

gen trendcont = trend + maxtrend - mintrend +30
gen trendercont = trender + maxtrender - mintrender +30

* Figure C1

twoway (rarea pretrend_cookies_l pretrend_cookies_u trend if fall == 1 & year0 == 2017, sort color(ltblue%10)) ///
 (scatter weekavgcookie trender if fall == 1 & year0 == 2017,   mcolor(blue) msize(2-pt)) ///
 (line pretrend_cookies trend if fall == 1 & year0 == 2017,lcolor(blue)) ///
 (rarea pretrend_pizza_l pretrend_pizza_u trend if fall == 1 & year0 == 2017, sort color(red%05)) ///
 (scatter weekavgpizza trender if fall == 1 & year0 == 2017 ,  mcolor(red) msize(2-pt)) ///
 (line pretrend_pizza trend if fall == 1 & year0 == 2017,lcolor(red)) ///
 ,ylabel(-500(500)500) legend(order(2 "De-Meaned Cookies (week avg.)" 5 "De-Meaned Pizza (week avg.)" 3 "Linear Trend - Cookies" 6 "Linear Trend - Pizza" 1 "95% CI - Cookies" 4 "95% CI - Pizza") size(*0.9) region(lc(gs0)) cols(2) pos(6)) name(PreTrendavg_dinner) ytitle("") xtitle("Days since start of semester") graphregion(color(white)) 
 
graph export "/Users/lorisrubini/Library/CloudStorage/OneDrive-USNH/Stillings/Analysis_2017_2019/Pre and Post Trends - RR JESA/Final Submission/FigureC1.pdf", as(pdf) name("PreTrendavg_dinner") replace

* Figure C2

twoway  ///
 (scatter weekavgcookie trender if fall == 1 & year0 == 2017,  mcolor(blue) msize(2-pt)) ///
 (line pretrend_cookies trend if fall == 1 & year0 == 2017,lcolor(blue)) ///
 (scatter weekavgpizza trender if fall == 1 & year0 == 2017 ,   mcolor(red) msize(2-pt)) ///
 (line pretrend_pizza trend if fall == 1 & year0 == 2017,lcolor(red)) ///
 (line postrend_cookies trendcont if fall == 0 & year0 == 2018 ,  lcolor(blue)  ) ///
 (line postrend_pizza trendcont if fall == 0 & year0 == 2018 ,  lcolor(red)  ) ///
 (scatter weekavgcookie trendercont if fall == 0 & year0 == 2018 ,   mcolor(blue) msize(2-pt)) ///
 (scatter weekavgpizza trendercont if fall == 0 & year0 == 2018 ,   mcolor(red) msize(2-pt)) ///
 ,ylabel(-500(500)500) legend(order(1 "De-Meaned Cookies (week avg.)" 3 "De-Meaned Pizza (week avg.)" 2 "Linear Trend - DM Cookies F17" 4 "Linear Trend - DM Pizza F17" 5 "Linear Trend - DM Cookies S18" 6 "Linear Trend - DM Pizza S18" ) size(*0.9) region(lc(gs0)) cols(2) pos(6)) name(PrePosTrendavg_dinner) ytitle("") xtitle("Days since start of academic year") graphregion(color(white)) xline(84.5, lcolor(gs10) lp(dash)) xline(110, lcolor(gs10) lp(dash)) text(450 150 "Spring 2018", color(gs10) ) text(450 50 "Fall 2017", color(gs10) ) text(450 98 "Winter", color(gs10) ) text(350 98 "Break", color(gs10) ) 

 
graph export "/Users/lorisrubini/Library/CloudStorage/OneDrive-USNH/Stillings/Analysis_2017_2019/Pre and Post Trends - RR JESA/Final Submission/FigureC2.pdf", as(pdf) name("PrePosTrendavg_dinner") replace


restore
preserve

************************ Figures C3 and C4 *********************************


drop if Service == 1

gen quant = Toprepare - Leftorccwhenout

replace quant = . if quant == 0

drop if quant >= 2000
drop if quant<0
bysort Service trend date0: egen totCookies = sum(quant) if sweet == 1
bysort Service trend date0: egen totPizza = sum(quant) if sweet == 0

bysort  trend date0: egen totCookiesld = sum(quant) if sweet == 1 
bysort  trend date0: egen totPizzald = sum(quant) if sweet == 0 

duplicates drop date0 sweet, force

drop if date0<date("20170930","YMD")

* Run regressions related to the production of the plots

sort year0 fall Service trend

sum totCookiesld if date0<date("20171231","YMD")
scalar meancookies = r(mean)

sum totPizzald if date0<date("20171231","YMD")
scalar meanpizza = r(mean)

regress totCookiesld trend if fall == 1 & year0 == 2017
gen cookiesfit = _b[_cons] + _b[trend]*trend  if fall == 1 & year0 == 2017

regress totPizzald trend if fall == 1 & year0 == 2017
gen pizzafit = _b[_cons] + _b[trend]*trend  if fall == 1 & year0 == 2017

* Pre-Trend
qui{
	regress totCookiesld trend if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	estimates store cookies_pre_trend
	scalar bcookies = _b[trend]
	scalar ccookies = _b[_cons]
	scalar lbcookies = r(table)[5,1]
	scalar ubcookies = r(table)[6,1]
	scalar lccookies = r(table)[5,2] 
	scalar uccookies = r(table)[6,2]
	
	regress totPizzald trend if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	estimates store pizza_pre_trend
	scalar bpizza = _b[trend]
	scalar cpizza = _b[_cons]
	scalar lbpizza = r(table)[5,1]
	scalar ubpizza = r(table)[6,1]
	scalar lcpizza = r(table)[5,2] 
	scalar ucpizza = r(table)[6,2]

	scalar normcookie = bcookies*28
	scalar normpizza = bpizza*43
	
	gen pretrend_cookies = bcookies*trend - normcookie  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_cookies_l = lbcookies*trend - normcookie  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_cookies_u = ubcookies*trend - normcookie  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_pizza = bpizza*trend - normpizza if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_pizza_l = lbpizza*trend - normpizza  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	gen pretrend_pizza_u = ubpizza*trend - normpizza  if fall == 1 & year0 == 2017 & date0>date("20170930","YMD") & date0<date("20171231","YMD")
	
	gen totCookiesdm = totCookiesld - meancookies 
	gen totPizzadm = totPizzald  - meanpizza 
	
	* Post
	
	regress totCookiesld trend if fall == 0 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store cookies_pre_trend
	scalar bcookies2 = _b[trend]
	scalar ccookies2 = _b[_cons]
	scalar lbcookies2 = r(table)[5,1]
	scalar ubcookies2 = r(table)[6,1]
	scalar lccookies2 = r(table)[5,2] 
	scalar uccookies2 = r(table)[6,2]
	
	regress totPizzald trend if fall == 0 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store pizza_pre_trend
	scalar bpizza2 = _b[trend]
	scalar cpizza2 = _b[_cons]
	scalar lbpizza2 = r(table)[5,1]
	scalar ubpizza2 = r(table)[6,1]
	scalar lcpizza2 = r(table)[5,2] 
	scalar ucpizza2 = r(table)[6,2]

	
	
	gen postrend_cookies = bcookies2*trend + ccookies2 - meancookies 
	gen postrend_cookies_l = lbcookies2*trend + ccookies2 - meancookies
	gen postrend_cookies_u = ubcookies2*trend + ccookies2 - meancookies
	gen postrend_pizza = bpizza2*trend + cpizza2 - meanpizza 
	gen postrend_pizza_l = lbpizza2*trend + cpizza2 - meanpizza
	gen postrend_pizza_u = ubpizza2*trend + cpizza2 - meanpizza
	
	* Post - F18
	
	regress totCookiesld trend if fall == 1 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store cookies_pre_trend2
	scalar bcookies22 = _b[trend]
	scalar ccookies22 = _b[_cons]
	scalar lbcookies22 = r(table)[5,1]
	scalar ubcookies22 = r(table)[6,1]
	scalar lccookies22 = r(table)[5,2] 
	scalar uccookies22 = r(table)[6,2]
	
	regress totPizzald trend if fall == 1 & year0 == 2018 & date0>date("20171231","YMD")
	estimates store pizza_pre_trend2
	scalar bpizza22 = _b[trend]
	scalar cpizza22 = _b[_cons]
	scalar lbpizza22 = r(table)[5,1]
	scalar ubpizza22 = r(table)[6,1]
	scalar lcpizza22 = r(table)[5,2] 
	scalar ucpizza22 = r(table)[6,2]

	
	
	gen postrend_cookies2 = bcookies22*trend + ccookies22 - ccookies - normcookie
	gen postrend_cookies_l2 = lbcookies22*trend + ccookies22 - normcookie
	gen postrend_cookies_u2 = ubcookies22*trend + ccookies22 - normcookie
	gen postrend_pizza2 = bpizza22*trend + cpizza22 - cpizza - normpizza
	gen postrend_pizza_l2 = lbpizza22*trend + cpizza22 - normpizza
	gen postrend_pizza_u2 = ubpizza22*trend + cpizza22 - normpizza

	* Post - S18 + F18
	
	regress totCookiesld trend if year0 == 2018 & date0>date("20171231","YMD")
	estimates store cookies_pre_trend23
	scalar bcookies223 = _b[trend]
	scalar ccookies223 = _b[_cons]
	scalar lbcookies223 = r(table)[5,1]
	scalar ubcookies223 = r(table)[6,1]
	scalar lccookies223 = r(table)[5,2] 
	scalar uccookies223 = r(table)[6,2]
	
	regress totPizzald trend if year0 == 2018 & date0>date("20171231","YMD")
	estimates store pizza_pre_trend23
	scalar bpizza223 = _b[trend]
	scalar cpizza223 = _b[_cons]
	scalar lbpizza223 = r(table)[5,1]
	scalar ubpizza223 = r(table)[6,1]
	scalar lcpizza223 = r(table)[5,2] 
	scalar ucpizza223 = r(table)[6,2]

	
	
	gen postrend_cookies23 = bcookies223*trend + ccookies223 - ccookies - normcookie
	gen postrend_cookies_l23 = lbcookies223*trend + ccookies223 - normcookie
	gen postrend_cookies_u23 = ubcookies223*trend + ccookies223 - normcookie
	gen postrend_pizza23 = bpizza223*trend + cpizza223 - cpizza - normpizza
	gen postrend_pizza_l23 = lbpizza223*trend + cpizza223 - normpizza
	gen postrend_pizza_u23 = ubpizza223*trend + cpizza223 - normpizza
	
	
*/
}

* Lunch and Dinner - Figures C3 and C4

* generate week indicator
gen weeker = week(date0)
bysort weeker: egen weekavgcookie = mean(totCookiesdm) if sweet == 1
bysort weeker: egen weekavgpizza = mean(totPizzadm) if sweet == 0
bysort weeker: egen trender = mean(trend)


quietly sum trend if fall == 1 & year0 == 2017
scalar maxtrend = r(max)
quietly sum trender if fall == 1 & year0 == 2017
scalar maxtrender = r(max)
qui sum trend if fall == 0 & year0 == 2018
scalar mintrend = r(min)
qui sum trender if fall == 0 & year0 == 2018
scalar mintrender = r(min)

gen trendcont = trend + maxtrend - mintrend +30
gen trendercont = trender + maxtrender - mintrender +30

* Figure C3

twoway (rarea pretrend_cookies_l pretrend_cookies_u trend if fall == 1 & year0 == 2017, sort color(ltblue%10)) ///
 (scatter weekavgcookie trender if fall == 1 & year0 == 2017,   mcolor(blue) msize(2-pt)) ///
 (line pretrend_cookies trend if fall == 1 & year0 == 2017,lcolor(blue)) ///
 (rarea pretrend_pizza_l pretrend_pizza_u trend if fall == 1 & year0 == 2017, sort color(red%05)) ///
 (scatter weekavgpizza trender if fall == 1 & year0 == 2017 ,  mcolor(red) msize(2-pt)) ///
 (line pretrend_pizza trend if fall == 1 & year0 == 2017,lcolor(red)) ///
 ,ylabel(-500(500)500) legend(order(2 "De-Meaned Cookies (week avg.)" 5 "De-Meaned Pizza (week avg.)" 3 "Linear Trend - Cookies" 6 "Linear Trend - Pizza" 1 "95% CI - Cookies" 4 "95% CI - Pizza") size(*0.9) region(lc(gs0)) cols(2) pos(6)) name(PreTrendavg_ld) ytitle("") xtitle("Days since start of semester") graphregion(color(white)) 
 
graph export "/Users/lorisrubini/Library/CloudStorage/OneDrive-USNH/Stillings/Analysis_2017_2019/Pre and Post Trends - RR JESA/Final Submission/FigureC3.pdf", as(pdf) name("PreTrendavg_ld") replace

* Figure C4

twoway  ///
 (scatter weekavgcookie trender if fall == 1 & year0 == 2017,  mcolor(blue) msize(2-pt)) ///
 (line pretrend_cookies trend if fall == 1 & year0 == 2017,lcolor(blue)) ///
 (scatter weekavgpizza trender if fall == 1 & year0 == 2017 ,   mcolor(red) msize(2-pt)) ///
 (line pretrend_pizza trend if fall == 1 & year0 == 2017,lcolor(red)) ///
 (line postrend_cookies trendcont if fall == 0 & year0 == 2018 ,  lcolor(blue)  ) ///
 (line postrend_pizza trendcont if fall == 0 & year0 == 2018 ,  lcolor(red)  ) ///
 (scatter weekavgcookie trendercont if fall == 0 & year0 == 2018 ,   mcolor(blue) msize(2-pt)) ///
 (scatter weekavgpizza trendercont if fall == 0 & year0 == 2018 ,   mcolor(red) msize(2-pt)) ///
 ,ylabel(-500(500)500) legend(order(1 "De-Meaned Cookies (week avg.)" 3 "De-Meaned Pizza (week avg.)" 2 "Linear Trend - DM Cookies F17" 4 "Linear Trend - DM Pizza F17" 5 "Linear Trend - DM Cookies S18" 6 "Linear Trend - DM Pizza S18" ) size(*0.9) region(lc(gs0)) cols(2) pos(6)) name(PrePosTrendavg_ld) ytitle("") xtitle("Days since start of academic year") graphregion(color(white)) xline(84.5, lcolor(gs10) lp(dash)) xline(110, lcolor(gs10) lp(dash)) text(450 150 "Spring 2018", color(gs10) ) text(450 50 "Fall 2017", color(gs10) ) text(450 98 "Winter", color(gs10) ) text(350 98 "Break", color(gs10) ) 

 
graph export "/Users/lorisrubini/Library/CloudStorage/OneDrive-USNH/Stillings/Analysis_2017_2019/Pre and Post Trends - RR JESA/Final Submission/FigureC4.pdf", as(pdf) name("PrePosTrendavg_ld") replace





graph set window fontface default
