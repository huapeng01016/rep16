/* 3. Create a document with chapter and page numbers */

version 16
webuse lbw, clear

/* Include chapter numbers, using a colon as a separator */
putdocx begin, footer(foot1) pagenum(, , Heading1,colon)

/* We removed the text "Page" from the footer */
putdocx paragraph, tofooter(foot1)
putdocx pagenumber

putdocx paragraph, style(Title)
putdocx text ("Analysis of birthweights")

putdocx pagebreak

putdocx paragraph, style(Heading1)
putdocx text ("Data")

putdocx textblock begin
We have data on birthweights from Hosmer, Lemeshow, and Sturdivant(2013, 24).
 This dataset includes some demographic information on each infant's mother, 
 such as her age and race. We also have relevant medical history, including her 
 weight, history of hypertension and premature labor, and the number of 
 physician visits during her first trimester.
putdocx textblock end

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
putdocx image bweight.png, width(4) height(2.8)

putdocx pagebreak

putdocx paragraph, style(Heading1)
putdocx text ("Regression results")

putdocx textblock begin
Below, we fit a linear regression of birthweight on the mother's age and
 whether she smokes.
putdocx textblock end

regress bwt i.smoke age, noheader cformat(%9.2f)
putdocx table bweight = etable, title("Linear regression of birthweight")
putdocx table bweight(3,.), drop 
putdocx table bweight(2 4,.), shading(lightgray)

putdocx textblock begin
We find that on average, infants whose mothers smoked tend to weigh less, and
 the mother's age is not a statistically significant factor.
putdocx textblock end

putdocx save bwreport, replace
/* We only see page numbers, so what we need to do is select a
multilevel list that includes the heading style we used.

As soon as I do that, you'll see that we are currently on 
chapter two, page 2.	*/


/* 4. Append a file with references */
putdocx append bwreport references, saving(report, replace) pagebreak

/* Above, the footer from the first document was applied all throughout the 
document, this is the default behavior. But, we can instead specify
that each document use its own header and footer by typing */

putdocx append bwreport references, saving(report, replace) pagebreak ///
headsrc(own) pgnumrestart

/* The headsrc option specifies the document from which headers and footers are
to be used. (You can specify first, last, or own for the source of the header.)

Because we want the page numbering to start over on the first page
of the references file, we also added the option -pgnumrestart- */

/* Also, if you add a table of contents, you'll see that all the headers are
included in the table. */
