# 使用Stata生成可重复报告

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


# 更多动态标签

## 条件标签
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

## 加入文本文件

````
<<dd_ignore>>
<<dd_include: /path/file>>
<</dd_ignore>>
````

# Markdown

## 标题

~~~~
# 标题 1
## 标题 2
### 标题 3
~~~~

## 代码块

~~~~
"~~~~" 或 "````"代码块
~~~~

## 重点

~~~~
asterisks (*) underscores (_)重点 
~~~~

## 图像

~~~~
![Alt text](/path/to/img.jpg "Optional title")
~~~~

## 链接

~~~~
This is [an example](http://example.com/ "Title") link.
~~~~

# Example 2

- [web page](./examples/fuel_consumption.html)
- [dynamic document](./examples/fuel_consumption.txt) 

~~~~
dyndoc fuel_consumption.txt, replace 
~~~~

# **dyndoc** with arguments

从一个[动态文件](./examples/auto_78.txt)应用参数生成一组网页

<<dd_do:quietly>>
use examples/auto_78_img.dta, clear
desc
<</dd_do>>

<<dd_do:nocommand>>
forval i=1/`r(N)' {
  di "- [" make[`i'] "](./examples/cars/" make[`i'] ".html)"
}
<</dd_do>>

# 用户开发命令 

[ssc](https://www.stata.com/support/ssc-installation/)
使用[pandoc](http://pandoc.org) to convert Markdown documents:

- dynpandoc
- markstat 
- markdoc 
- webdoc 

# 使用pandoc

## 从[dynamic document](./examples/fuel_cc.txt)生成

- [web page](./examples/fuel_pandoc.html) 
- [Word document](./examples/fuel_pandoc.docx)
- [PDF document](./examples/fuel_pandoc.pdf)

## 命令
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

# 总结

- **putdocx**生成Word文件 
- **dyndoc**生成网页web pages
- **putpdf**生成PDF文件

# 谢谢!

[hpeng]: hpeng@stata.com
