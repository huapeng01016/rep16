putdocx clear 
putdocx begin

putdocx paragraph, style("Heading1")
putdocx text ("在Word中导入Stata log文件")

putdocx textfile toinclude.log

putdocx pagebreak

putdocx paragraph, style("Heading2")
putdocx text ("在某行停止")

putdocx textfile toinclude.log, stopat("log close")

putdocx save textfile.docx, replace
