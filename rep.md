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

# Generate tables from saved results 

## From estimation command

~~~~
regress fuel weight
putdocx table tbl_reg = etable
~~~~

- [Word document](./examples/etable_1.docx) 
- [source do-file](./examples/etable_1.do)

## From **margins**

~~~~
regress fuel weight i.foreign i.rep78
margins foreign rep78 
putdocx table tbl_marg = etable
~~~~

- [Word document](./examples/etable_3.docx) 
- [source do-file](./examples/etable_3.do)


## From **estimates table** 

~~~~
quietly regress fuel weight gear turn
estimates store model1
quietly regress fuel weight gear turn foreign
estimates store model2
estimates table model1 model2, b(%7.4f) stats(N r2 r2_a) star
putdocx table tbl_est = etable
~~~~

- [Word document](./examples/etable_4.docx) 
- [source do-file](./examples/etable_4.do)


## From dataset

~~~~
putdocx table tbl_data = data(_all)
~~~~

- [Word document](./examples/data_table.docx) 
- [source do-file](./examples/data_table.do)


## Change table styles and layout 

~~~~
		// add a table without borders
putdocx table tbl_data_1 = data(_all), border(all,nil)
		// add a double width line border 
		// at the bottom of the first row
putdocx table tbl_data_1(1,.), border(bottom,double)
putdocx table tbl_data_1(3,.), border(bottom, dotted)
		// make the first cell of 
		// the first row span 3 columns
putdocx table tbl_data_1(1,1), colspan(3) halign(center)
putdocx table tbl_data_1(14,.), border(top,dotted)
putdocx table tbl_data_1(17,.), border(top,double)
		// make the first cells of 17th and 18th 
		// rows span 3 columns, also make the contents 
		// of the cells left aligned and italic  
putdocx table tbl_data_1(17,1), colspan(3) halign(left) italic
putdocx table tbl_data_1(18,1), colspan(3) halign(left) italic
~~~~

## After change table styles and layout

- [Word document](./examples/data_table_1.docx) 
- [source do-file](./examples/data_table_1.do)

## Nested table

~~~~
	// table may be created in memory using -memtable- option
regress fuel weight if foreign
putdocx table tbl_f = etable, memtable
regress fuel weight if !foreign
putdocx table tbl_d = etable, memtable
	// add tables in memory into cells of another tbale
putdocx table tbl_l = (2, 2)
putdocx table tbl_l(1, 1)  = ("Foreign"), halign(center)
putdocx table tbl_l(1, 2)  = ("Domestic"), halign(center)
putdocx table tbl_l(2, 1)  = table(tbl_f)
putdocx table tbl_l(2, 2)  = table(tbl_d)	
~~~~

## Resulted nested table

- [Word document](./examples/nest_table.docx) 
- [source do-file](./examples/nest_table.do)

# Include output from Stata commands 

- Include text file using [docxaddfile](./examples/docxaddfile.ado) 
- [Word document](./examples/logout.docx) 
- [source do-file](./examples/logout.do)


# Community-contributed software based on **putdocx** 

Some commands on [ssc](https://www.stata.com/support/ssc-installation/)

- sum2docx
- reg2docx
- t2docx
- corr2docx

# A **dyndoc** example 

- [dynamic document](./examples/fuel.txt) 
- [fuel consumption report](./examples/fuel.html) 

~~~~
dyndoc fuel.txt, replace 	
~~~~
	

# Dynamic tags

## dd_do for a block of Stata code
````
<<dd_ignore>>
<<dd_do>>
sysuse auto, clear
generate fuel = 100/mpg
label variable fuel "Fuel consumption (Gallons per 100 Miles)"
regress fuel weight
<</dd_do>>
<</dd_ignore>>
````

##
````
<<dd_do>>
sysuse auto, clear
generate fuel = 100/mpg
label variable fuel "Fuel consumption (Gallons per 100 Miles)"
regress fuel weight
<</dd_do>>
````

##
Attributes change a tag's behavior

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

## dd_display for inline Stata results
<<dd_ignore>>
- For every unit increase in weight, a <<dd_display:%9.4f eb[1,1]>> unit
increase in fuel consumption is predicted.
<</dd_ignore>>

> - For every unit increase in weight, a <<dd_display:%9.4f eb[1,1]>> unit
increase in fuel consumption is predicted.

## dd_graph
````
<<dd_ignore>>
<<dd_do>>
scatter fuel weight, mcolor(%50)
<</dd_do>>
<<dd_graph:sav(sc_gp100m_weight.png) replace>>
<</dd_ignore>>
````

<<dd_do:quietly>>
scatter fuel weight, mcolor(%50)
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
# H1
## H2
### H3
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

# Recap

- Stata tools for reproducible research 
- **putdocx** to generate Word documents 
- **dyndoc** to generate web pages
- **putpdf** to generate PDF files
- Many  community-contributed packages

# Thanks!

[hpeng]: hpeng@stata.com
