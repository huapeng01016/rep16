putdocx clear 
putdocx begin

sysuse auto_zh, clear

putdocx paragraph, style("Heading1")
putdocx text ("用esttab生成表格")

preserve
cap erase esttab_ex.csv
eststo clear
eststo, title("模型 1"): quietly regress 油耗 重量 变速比 转弯半径
eststo, title("模型 2"): quietly regress 油耗 重量 变速比 转弯半径 国籍
esttab using esttab_ex.csv, 		///
	b(3) t(2) r2(2) ar2(2)			/// 
	plain star notes par label 		/// 
	width(80%)

import delimited using esttab_ex.csv, encoding("utf-8") clear
putdocx table tbl_data = data(_all)
restore

putdocx save data_table.docx, replace

exit
