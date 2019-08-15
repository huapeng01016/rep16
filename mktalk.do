/* 
	Author: 	Hua Peng
	Date:	Jun 17, 2019
	Purpose:	Build reveal.js slides deck for 2019 Chicago
*/

local path = ""
if "`c(os)'" == "MacOSX" {
	dynpandoc rep2019.md, 	/// 
		sav(index.html)	/// 
		replace 	/// 
		to(revealjs) 	/// 
		path(/Users/hpeng01016/anaconda3/bin/pandoc)	///		
		pargs(-s --template=revealjs.html  	/// 
		--self-contained	/// 
		--section-divs	/// 
		--variable theme="stata"	/// 
		)
}
else {
	dynpandoc rep2019.md, 	/// 
		sav(index.html)	/// 
		replace 	/// 
		to(revealjs) 	/// 
		pargs(-s --template=revealjs.html  	/// 
		--self-contained	/// 
		--section-divs	/// 
		--variable theme="stata"	/// 
		)
}

exit

