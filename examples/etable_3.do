putdocx clear 
putdocx begin

sysuse auto_zh, clear

putdocx paragraph, style("Heading1")
putdocx text ("margins")

regress 油耗 重量 i.国籍 i.维修记录78
margins 国籍 维修记录78

putdocx table tbl_marg = etable

putdocx save etable_3.docx, replace

exit
