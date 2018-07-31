*! version 1.0.0  12jan2015

cscript

/* modify auto dataset to use Chinese variable names/labels*/

webuse auto

desc

/* variable labels */
label variable make "品牌型号"
label variable price "价格"
label variable mpg "里程(英里每加仑) "
label variable rep78 "1978年维修记录"
label variable headroom "头部空间(英寸)"
label variable trunk "后备厢空间(立方英尺)"
label variable weight "重量(英磅)"
label variable length "车长(英寸)"
label variable turn "转弯半径(英尺) "
label variable displacement "排气量(立方英寸)"
label variable gear_ratio "变速比"
label variable foreign "国籍"

/* value label */
label define 生产国籍 0 "国内" 1 "国外"
label values foreign 生产国籍

/* variable names */
rename make 品牌
rename price 价格
rename mpg 里程
rename rep78 维修记录78
rename headroom 头部空间
rename trunk 后备厢
rename weight 重量
rename length 车长
rename turn 转弯半径
rename displacement 排气量
rename gear_ratio 变速比
rename foreign 国籍

/* dataset label */
label data "1978年汽车数据"

global S_FN = "汽车数据.dta"

desc

save auto_zh.dta, replace
di "all is well"