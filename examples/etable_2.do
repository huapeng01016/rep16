putdocx clear 
putdocx begin

use auto_zh, clear

putdocx paragraph, style("Heading1")
putdocx text ("线性回归结果")
regress 油耗 重量

putdocx table tbl_est = etable
		// change cell contents
putdocx table tbl_est(3, 1) = ("常数")
putdocx table tbl_est(1, 2) = ("参数")
putdocx table tbl_est(1, 3) = ("标准误差")
putdocx table tbl_est(1, 4) = ("t统计量")
putdocx table tbl_est(1, 5) = ("P值")
putdocx table tbl_est(1, 6) = ("置信区间")

		// change the alignment of first column and row
putdocx table tbl_est(.,1), halign(center)	
putdocx table tbl_est(1,.), halign(center)	

putdocx save etable_2.docx, replace

exit
