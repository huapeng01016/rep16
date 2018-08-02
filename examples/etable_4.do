putdocx clear 
putdocx begin

sysuse auto_zh, clear

putdocx paragraph, style("Heading1")
putdocx text ("-estimates table-")

quietly regress 油耗 重量 变速比 转弯半径
estimates store 模型1
quietly regress 油耗 重量 变速比 转弯半径 国籍
estimates store  模型2
estimates table 模型1 模型2, 	///
	varlabel b(%7.4f) 			/// 
	stats(N r2 r2_a) star

putdocx table tbl_est = etable

putdocx save etable_4.docx, replace

exit
