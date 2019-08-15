/* 2. Create a customized document with headings, and a footer with page numbers */

version 16
webuse lbw, clear

/* Create a document with a footer */
putdocx begin, footer(foot1)

/* Define the footer content */
putdocx paragraph, tofooter(foot1)
putdocx text ("Page ")
putdocx pagenumber

putdocx paragraph, style(Title)
putdocx text ("Analysis of birthweights")

/* Add a pagebreak */
putdocx pagebreak

/* Add a heading */
putdocx paragraph, style(Heading1)
putdocx text ("Data")

putdocx textblock begin
We have data on birthweights from Hosmer, Lemeshow, and Sturdivant(2013, 24).
 This dataset includes some demographic information on each infant's mother, 
 such as her age and race. We also have relevant medical history, including her 
 weight, history of hypertension and premature labor, and the number of 
 physician visits during her first trimester.
putdocx textblock end

/* Add another heading */
putdocx paragraph, style(Heading1)
putdocx text ("Summary statistics")

summarize bwt

putdocx textblock begin
We have the recorded weight for <<dd_docx_display: r(N)>> babies with an 
average birthweight of <<dd_docx_display: %5.2f r(mean)>> grams.
putdocx textblock end

local total = r(N)
count if smoke==1

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
graph export bweight.png, replace

putdocx paragraph
/* Specify the height and width of the image */
putdocx image bweight.png, width(4) height(2.8)

putdocx pagebreak

/* Add another heading */
putdocx paragraph, style(Heading1)
putdocx text ("Regression results")

putdocx textblock begin
Below, we fit a linear regression of birthweight on the mother's age and
 whether she smokes.
putdocx textblock end

regress bwt i.smoke age, noheader cformat(%9.2f)
putdocx table bweight = etable, title("Linear regression of birthweight")

/* Drop the third row */
putdocx table bweight(3,.), drop 

/* Shade in the second and fourth rows */
putdocx table bweight(2 4,.), shading(lightgray)

putdocx textblock begin
We find that on average, infants whose mothers smoked tend to weigh less, and
 the mother's age is not a statistically significant factor.
putdocx textblock end

putdocx save bwreport, replace
