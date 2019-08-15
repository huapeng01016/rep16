putdocx clear 
putdocx begin, header(info) footer(china19) pagenum(decimal)

putdocx paragraph, style("Heading1")
putdocx text ("Stata车辆数据文件中车型的重量和油耗之间关系的对比和分析")

putdocx paragraph, toheader(info)
putdocx text ("彭华 StataCorp LLC")

putdocx table china19 = (1, 2), border(all, nil) tofooter(china19)
putdocx table china19(1,1) = ("2019中国用户大会"), halign(left)  
putdocx table china19(1,2) = ("page: "), pagenumber halign(right)  

use auto_zh, clear

putdocx textblock begin
我们希望研究1978车辆数据中两个变量<<dd_docx_display bold:"油耗">>和<<dd_docx_display bold:"重量">>之间的关系。
putdocx textblock end


preserve
describe 油耗 重量, replace clear

putdocx paragraph, style("Heading2")
putdocx text ("检查数据")

putdocx textblock begin
首先我们检查<<dd_docx_display bold:"油耗">>和<<dd_docx_display bold underline:"重量">>的变量描述和摘要统计数据。
putdocx textblock end


		// generate the describe table from dataset in memory
sort name
putdocx table tbl_desc = data("name type format vallab varlab"), ///
	varnames				///
	border(start, nil) 		/// 
	border(insideV, nil) 	/// 
	border(insideH, nil) 	/// 
	border(end, nil)

putdocx table tbl_desc(1, 1) = ("变量名")
putdocx table tbl_desc(1, 2) = ("类型")
putdocx table tbl_desc(1, 3) = ("格式")
putdocx table tbl_desc(1, 4) = ("值标签")
putdocx table tbl_desc(1, 5) = ("标签")
putdocx table tbl_desc(1, .), border(bottom, single)

restore

tabstat 油耗 重量, stats(n mean sd min max) save
matrix stats = r(StatTotal)'

putdocx table tbl_summ = matrix(stats),  ///
		nformat(%9.4g)					 ///
        rownames colnames                ///
        border(start, nil)               ///
        border(insideV, nil)             ///
        border(insideH, nil)             ///
        border(end, nil)

putdocx table tbl_summ(1, 1) = ("变量")
putdocx table tbl_summ(1, 2) = ("观测")
putdocx table tbl_summ(1, 3) = ("均值")
putdocx table tbl_summ(1, 4) = ("标准差")
putdocx table tbl_summ(1, 5) = ("最小值")
putdocx table tbl_summ(1, 6) = ("最大值")
putdocx table tbl_summ(1, .), border(bottom, single)

putdocx paragraph
putdocx textblock append
我们检查<<dd_docx_display bold:"油耗">>和<<dd_docx_display bold underline:"重量">>的摘要统计数据。
putdocx textblock end

summarize 油耗
putdocx textblock append
从摘要统计数据看出,变量<<dd_docx_display bold:"油耗">>的最小值<<dd_docx_display italic: %4.2f `r(min)'>>,最大值<<dd_docx_display italic: %4.2f `r(max)'>>,极差<<dd_docx_display italic: %4.2f `r(max)'-`r(min)'>>;
putdocx textblock end

summarize 重量
putdocx textblock append
变量<<dd_docx_display bold:"重量">>的最小值<<dd_docx_display italic: %4.2f `r(min)'>>,最大值<<dd_docx_display italic: %4.2f `r(max)'>>,极差<<dd_docx_display italic: %4.2f `r(max)'-`r(min)'>>。
putdocx textblock end

putdocx paragraph, style("Heading2")
putdocx text ("用散点图显示油耗与重量关系")

twoway lfitci 油耗 重量 || scatter 油耗 重量, mcolor(%20) scheme(538)
graph export temp.png, replace 
putdocx paragraph, halign(center)
putdocx image temp.png, width(4) linebreak
putdocx text ("图1: 油耗与重量"), bold

putdocx textblock begin
我们在<<dd_docx_display bold:"油耗">>和<<dd_docx_display bold:"重量">>的散点图上叠加拟合值与均值的置信区间。
putdocx textblock end

putdocx sectionbreak, header(info2)
putdocx paragraph, toheader(info2)
putdocx text ("油耗与重量关系")


putdocx paragraph, style("Heading2")
putdocx text ("用线性回归研究油耗与重量关系")

regress 油耗 重量

		// add the regression table
putdocx table tbl_reg = etable

matrix define eb = e(b)

local a : di %-6.2g eb[1,1]*100
local a = trim("`a'")

local b : di %-6.2g e(r2)*100
local b = trim("`b'")

putdocx textblock begin
线性回归结果显示<<dd_docx_display bold:"重量">>每增加一百公斤,<<dd_docx_display bold:"每百公里油耗">>增加<<dd_docx_display italic:"`a'">>公升,可由模型解释的观察到的方差量为<<dd_docx_display:"`b'">>%。
putdocx textblock end

putdocx paragraph, style("Heading2")
putdocx text ("用-esttab-对比线性回归结果")

		//table from esttab
preserve
cap erase esttab_ex.csv
eststo clear
eststo, title("油耗"): quietly regress 油耗 重量 变速比 转弯半径
eststo, title("油耗"): quietly regress 油耗 重量 变速比 转弯半径 国籍
esttab using esttab_ex.csv, 		///
	b(3) t(2) r2(2) ar2(2)			/// 
	plain star notes par label 		/// 
	width(80%)

import delimited using esttab_ex.csv, encoding("utf-8") clear
putdocx table d = data(_all), border(all,nil)
putdocx table d(1, .), addrows(1, before)
putdocx table d(1, 1) = ("线性回归表使用esttab")
putdocx table d(1,.), border(bottom,double)
putdocx table d(3,.), border(bottom, dotted)
putdocx table d(1,1), colspan(3) halign(center)
putdocx table d(14,.), border(top,dotted)
putdocx table d(17,.), border(top,double)
putdocx table d(17,1), colspan(3) halign(left) italic
putdocx table d(18,1), colspan(3) halign(left) italic
restore

putdocx sectionbreak, landscape
putdocx paragraph, style("Heading2")
putdocx text ("不同国籍车辆对比")

putdocx table tbl_l = (4, 2), border(all, nil) border(top, double) border(bottom, double)

tabstat 油耗 重量 if 国籍, stats(n mean sd min max) save
matrix stats = r(StatTotal)'
putdocx table tbl_summ1 = matrix(stats),  ///
		memtable						  ///	
		nformat(%9.4g)					  ///
        rownames colnames                 ///
        border(start, nil)                ///
        border(insideV, nil)              ///
        border(insideH, nil)              ///
        border(end, nil)

putdocx table tbl_summ1(1, 1) = ("")
putdocx table tbl_summ1(1, 2) = ("观测")
putdocx table tbl_summ1(1, 3) = ("均值")
putdocx table tbl_summ1(1, 4) = ("标准差")
putdocx table tbl_summ1(1, 5) = ("最小值")
putdocx table tbl_summ1(1, 6) = ("最大值")
putdocx table tbl_summ1(1, .), border(bottom, dashed) valign(bottom)

tabstat 油耗 重量 if !国籍, stats(n mean sd min max) save
matrix stats = r(StatTotal)'
putdocx table tbl_summ2 = matrix(stats),  ///
		memtable						  ///	
		nformat(%9.4g)					  ///
        rownames colnames                 ///
        border(start, nil)                ///
        border(insideV, nil)              ///
        border(insideH, nil)              ///
        border(end, nil)

putdocx table tbl_summ2(1, 1) = ("")
putdocx table tbl_summ2(1, 2) = ("观测")
putdocx table tbl_summ2(1, 3) = ("均值")
putdocx table tbl_summ2(1, 4) = ("标准差")
putdocx table tbl_summ2(1, 5) = ("最小值")
putdocx table tbl_summ2(1, 6) = ("最大值")
putdocx table tbl_summ2(1, .), border(bottom, dashed) valign(bottom)
putdocx table tbl_summ2(2, 1) = ("")
putdocx table tbl_summ2(3, 1) = ("")

putdocx table tbl_l(1, 1)  = ("国外"), halign(center)
putdocx table tbl_l(1, 2)  = ("国内"), halign(center)
putdocx table tbl_l(2, 1)  = table(tbl_summ1)
putdocx table tbl_l(2, 2)  = table(tbl_summ2)

scatter 油耗 重量 if 国籍, mcolor(%20) scheme(538)
graph export temp_f.png, replace 
scatter 油耗 重量 if !国籍, mcolor(%20) scheme(538)
graph export temp_d.png, replace 

putdocx table tbl_l(3, 1)  = image(temp_f.png)
putdocx table tbl_l(3, 2)  = image(temp_d.png)

cap erase esttab_ex.csv
eststo clear
eststo, title("Foreign") : quietly regress 油耗 重量 变速比 转弯半径 if 国籍 
eststo, title("Domestic"): quietly regress 油耗 重量 变速比 转弯半径 if !国籍
esttab using esttab_ex.csv, 		///
	b(3) t(2) r2(2) ar2(2)			/// 
	plain star par label 			///
	wide							/// 
	nomtitles

import delimited using esttab_ex.csv, encoding("utf-8") clear
putdocx table d = data(_all), memtable border(all,nil)
putdocx table d(1,.), border(bottom, dashed)

putdocx table tbl_l(4, 1), colspan(2)
putdocx table tbl_l(4, 1) = table(d)

cap erase outputs.log
cap erase esttab_ex.csv
cap erase temp.png
cap erase temp_f.png
cap erase temp_d.png

putdocx save fuel_consumption_1.docx, replace

exit
