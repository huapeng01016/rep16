# Incorporating Stata into reproducible documents

##  [彭华@StataCorp][hpeng]
### 2017 Stata 中国用户大会 
### [https://huapeng01016.github.io/China18/](https://huapeng01016.github.io/China18/)

# Stata可重复研究与报告

## Stata可重复研究

- 简单收集手工操作到do-file  
- 不同版本间良好的数据和脚本文件兼容性(version control)

## Stata 15增加的可重复研究与报告工具 

- putdocx 
- dyndoc 
- putpdf 

# putdocx

- [Word文件](./examples/fuel_consumption.docx) 
- [do-file](./examples/fuel_consumption.do)

# 使用Stata命令结果产生表格 

## 估计命令结果表格

~~~~
regress 油耗 重量
putdocx table tbl_reg = etable
~~~~

- [Word文件](./examples/etable_1.docx) 
- [do-file](./examples/etable_1.do)

## **margins**

~~~~
regress 油耗 重量 i.国籍 i.维修记录78
margins 国籍 维修记录78 
putdocx table tbl_marg = etable
~~~~

- [Word文件](./examples/etable_3.docx) 
- [do-file](./examples/etable_3.do)


## **estimates table** 

~~~~
quietly regress 油耗 重量 变速比 转弯半径
estimates store 模型1
quietly regress 油耗 重量 变速比 转弯半径 国籍
estimates store  模型2
estimates table 模型1 模型2, 	///
	varlabel b(%7.4f) 			/// 
	stats(N r2 r2_a) star
putdocx table tbl_est = etable
~~~~

- [Word文件](./examples/etable_4.docx) 
- [source do-file](./examples/etable_4.do)


## 从dataset产生表格

~~~~
putdocx table tbl_data = data(_all)
~~~~

- [Word文件](./examples/data_table.docx) 
- [do-file](./examples/data_table.do)


## 改变表格格式外观 

~~~~
		// 去除边界
putdocx table tbl_data_1 = data(_all), border(all,nil)
		//  改变第一行边界
putdocx table tbl_data_1(1,.), border(bottom,double)
putdocx table tbl_data_1(3,.), border(bottom, dotted)
		// 扩展第一格占三列 
putdocx table tbl_data_1(1,1), colspan(3) halign(center)
putdocx table tbl_data_1(14,.), border(top,dotted)
putdocx table tbl_data_1(17,.), border(top,double)
		// 扩展17，18行第一格占三列，对齐左侧， 斜体 
putdocx table tbl_data_1(17,1), colspan(3) halign(left) italic
putdocx table tbl_data_1(18,1), colspan(3) halign(left) italic
~~~~

- [Word文件](./examples/data_table_1.docx) 
- [do-file](./examples/data_table_1.do)

## 嵌套表格

~~~~
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
~~~~

- [Word文件](./examples/nest_table.docx) 
- [do-file](./examples/nest_table.do)

# Stata命令输出 

- 用[docxaddfile](./examples/docxaddfile.ado)包括文件 
- [Word文件](./examples/logout.docx) 
- [do-file](./examples/logout.do)


# **dyndoc** 

- [动态文件](./examples/fuel.txt) 
- [油耗报告](./examples/fuel.html) 

~~~~
dyndoc fuel.txt, replace 	
~~~~
	

# 动态标签

## dd_do for a block of Stata code
````
<<dd_ignore>>
<<dd_do>>
use examples/auto_zh.dta, clear
regress 油耗 重量
<</dd_do>>
<</dd_ignore>>
````

##
````
<<dd_do>>
use examples/auto_zh.dta, clear
regress 油耗 重量
<</dd_do>>
````

##
改变标签属性

````
<<dd_ignore>>
<<dd_do:quietly>>
matrix eb = e(b)
<</dd_do>>
<</dd_ignore>>
````

<<dd_do:quietly>>
matrix eb = e(b)
<</dd_do>>

## 用dd_display显示Stata结果
<<dd_ignore>>
- 线性回归结果显示重量每增加一百公斤,每百公里油耗增加<<dd_display:%9.4f eb[1,1]*100>>公升。
<</dd_ignore>>

> - 线性回归结果显示重量每增加一百公斤,每百公里油耗增加<<dd_display:%9.4f eb[1,1]*100>>公升。

## dd_graph
````
<<dd_ignore>>
<<dd_do>>
scatter 油耗 重量, mcolor(%50)
<</dd_do>>
<<dd_graph:sav(sc_gp100m_weight.png) replace>>
<</dd_ignore>>
````

<<dd_do:quietly>>
scatter 油耗 重量, mcolor(%50)
<</dd_do>>

##
#### <<dd_graph:sav(sc_gp100m_weight.png) height(400) replace>>


# More dynamic tags

## Display contents based on condition
````
<<dd_ignore>>
<<dd_skip_if: ("`details'"=="")>>
The following explains why Gallons per 100 Mile is a better 
measurement than Miles per Gallon. Going from a 10 Miles per Gallon 
car to a 20 Miles per Gallon car saves 5 Gallons per 100 Miles when 
Miles per Gallon increases 10. Going from a 20 Miles per Gallon car 
to a 40 Miles per Gallon car *only* saves 2.5 Gallons per 100 Miles 
when Miles per Gallon increases 20.      
<<dd_skip_end>>
<</dd_ignore>>
````

## Include a text file

````
<<dd_ignore>>
<<dd_include: /path/file>>
<</dd_ignore>>
````

# Some Markdown syntax

## Headings

~~~~
# Head 1
## Head 2
### Head 3
~~~~

## Fenced code block

~~~~
Use "~~~~" or "````" for fenced code block
~~~~

## Emphasis

~~~~
Use asterisks (*) and underscores (_) for emphasis. 
~~~~

## Image

~~~~
![Alt text](/path/to/img.jpg "Optional title")
~~~~

## Link

~~~~
This is [an example](http://example.com/ "Title") link.
~~~~

# A longer example

- [web page](./examples/fuel_consumption.html)
- [dynamic document](./examples/fuel_consumption.txt) 

~~~~
dyndoc fuel_consumption.txt, replace 
~~~~


# Use arguments in **dyndoc**

Produce a set of different HTML pages from one [dynamic document](./examples/auto_78.txt) 
with different arguments  

<<dd_do:quietly>>
use examples/auto_78_img.dta, clear
desc
<</dd_do>>

<<dd_do:nocommand>>
forval i=1/`r(N)' {
  di "- [" make[`i'] "](./examples/cars/" make[`i'] ".html)"
}
<</dd_do>>

# Community-contributed software 

Some commands on [ssc](https://www.stata.com/support/ssc-installation/)
that use [pandoc](http://pandoc.org) to convert Markdown documents:

- dynpandoc
- markstat 
- markdoc 
- webdoc 

# Use pandoc instead of Stata's **markdown** command

## From a single [dynamic document](./examples/fuel_cc.txt), we may produce

- [web page](./examples/fuel_pandoc.html) 
- [Word document](./examples/fuel_pandoc.docx)
- [PDF document](./examples/fuel_pandoc.pdf)

## The commands used are 
~~~~
	// web page
dynpandoc fuel_cc.txt, saving(fuel_pandoc.html) /// 
		from(markdown) replace	
	// docx
dynpandoc fuel_cc.txt, saving(fuel_pandoc.docx) /// 
		from(markdown) replace 					/// 
     	pargs("--reference-doc=reference.docx") 
	// PDF
dynpandoc fuel_cc.txt, saving(fuel_pandoc.pdf)  /// 
		from(markdown) replace
~~~~

# Recap

- Stata tools for reproducible research 
- **putdocx** to generate Word documents 
- **dyndoc** to generate web pages
- **putpdf** to generate PDF files
- Many  community-contributed packages

# Thanks!

[hpeng]: hpeng@stata.com
