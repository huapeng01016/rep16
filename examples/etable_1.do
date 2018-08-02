putdocx clear 
putdocx begin

use auto_zh, clear

putdocx paragraph, style("Heading1")
putdocx text ("线性回归结果")

regress 油耗 重量

putdocx table tbl_est = etable

putdocx save etable_1.docx, replace

exit
