putdocx clear 
putdocx begin, landscape

sysuse auto_zh, clear

putdocx paragraph, style("Heading1")
putdocx text ("嵌套表格")

	// table may be created in memory using -memtable- option
regress 油耗 重量 if 国籍, cformat(%9.4f) 
putdocx table tbl_f = etable, memtable
regress 油耗 重量 if !国籍, cformat(%9.4f) 
putdocx table tbl_d = etable, memtable
	// add tables in memory into cells of another tbale
putdocx table tbl_l = (2, 2)
putdocx table tbl_l(1, 1)  = ("国外"), halign(center)
putdocx table tbl_l(1, 2)  = ("国内"), halign(center)
putdocx table tbl_l(2, 1)  = table(tbl_f)
putdocx table tbl_l(2, 2)  = table(tbl_d)	

putdocx save nest_table.docx, replace

exit
