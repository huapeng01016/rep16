/* 1. Create a basic report */

version 16
webuse lbw, clear

/* Create a document in memory */
putdocx begin

/* Add a title */
putdocx paragraph, style(Title)
putdocx text ("Analysis of birthweights")

/* Add a block of text */
putdocx textblock begin
We have data on birthweights from Hosmer, Lemeshow, and Sturdivant(2013, 24).
 This dataset includes some demographic information on each infant's mother, 
 such as her age and race. We also have relevant medical history, including her 
 weight, history of hypertension and premature labor, and the number of 
 physician visits during her first trimester.
putdocx textblock end

summarize bwt

/* Add a block of text with formatted returned results */
putdocx textblock begin
We have the recorded weight for <<dd_docx_display: r(N)>> babies with an 
average birthweight of <<dd_docx_display: %5.2f r(mean)>> grams.
putdocx textblock end

local total = r(N)
count if smoke==1

/* Append a block of text to the active paragraph */
putdocx textblock append
 There are <<dd_docx_display: r(N)>> mothers who smoked during pregnancy,
 and <<dd_docx_display: `total'-r(N)>> who did not. Below we graph the mean 
birthweight for babies with mothers who smoke versus those who do not, 
separately for mothers with and without a history of hypertension.
putdocx textblock end

graph hbar bwt, ///
over(ht,relabel(1 "No hypertension" 2 "Has history of hypertension")) ///
 over(smoke) asyvars ytitle(Average birthweight (grams)) ///
 title(Baby birthweights) ///
 subtitle(by mother's smoking status and history of hypertension)

/* Convert the graph to one of the supported image formats */
graph export bweight.png, replace

/* Append the image to a new paragraph */
putdocx paragraph
putdocx image bweight.png

/* Insert a page break */
putdocx pagebreak

putdocx textblock begin
Below, we fit a linear regression of birthweight on the mother's age and
 whether she smokes.
putdocx textblock end

regress bwt i.smoke age, noheader cformat(%9.2f)

/* Export the table of estimation results with the following title */
putdocx table bweight = etable, title("Linear regression of birthweight")

putdocx textblock begin
We find that on average, infants whose mothers smoked tend to weigh less, and
 the mother's age is not a statistically significant factor.
putdocx textblock end

/* Save and close the document */
putdocx save bwreport, replace

