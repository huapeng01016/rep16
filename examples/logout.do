putdocx clear 
putdocx begin

putdocx paragraph, style("Heading1")
putdocx text ("Stata命令输出")

log using logout.log, text replace nomsg
sysuse auto_zh, clear
describe 油耗 重量
regress 油耗 重量
log close

docxaddfile logout.log, stopat("log close")

cap erase logout.log

putdocx save logout.docx, replace

exit
