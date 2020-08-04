putdocx clear 
putdocx begin

sysuse auto, clear

putdocx paragraph, style("Heading2")
putdocx text ("scatter plot")

twoway lfitci mpg weight || scatter mpg weight, mcolor(%20)
graph export temp.png, replace 
putdocx paragraph, halign(center)
putdocx image temp.png, width(4) linebreak
putdocx text ("Figure 1: mpg weight"), bold

putdocx paragraph, style("Heading2")
putdocx text ("Tbale from esttab")

		//table from esttab
preserve
cap erase esttab_ex.csv
eststo clear
eststo, title("mpg"): quietly regress mpg weight gear_ratio turn
eststo, title("mpg"): quietly regress mpg weight gear_ratio turn foreign
esttab using esttab_ex.csv, 		///
	b(3) t(2) r2(2) ar2(2)			/// 
	plain star notes par label 		/// 
	width(80%)

import delimited using esttab_ex.csv, clear
putdocx table d = data(_all), border(all,nil)
putdocx table d(1, .), addrows(1, before)
putdocx table d(1, 1) = ("Table with esttab")
putdocx table d(1,.), border(bottom,double)
putdocx table d(3,.), border(bottom, dotted)
putdocx table d(1,1), colspan(3) halign(center)
putdocx table d(14,.), border(top,dotted)
putdocx table d(17,.), border(top,double)
putdocx table d(17,1), colspan(3) halign(left) italic
putdocx table d(18,1), colspan(3) halign(left) italic
restore

cap erase esttab_ex.csv

putdocx save fuel_consumption.docx, replace

exit