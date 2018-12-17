<%page args="page"/>
<p>The calculations to obtain the expected ${page.term_helper('load','mutational load')|n} differ depending on whether they are in verification or planning mode.</p>

<p>In the planner mode, you have yet to do the epPCR and would like to know how much template to add in order to achieve a given load (say 5 mutations on average).</p>

\[duplication_{\textrm{desired}} = load_{\textrm{desired}} / errorRate\]

\[template_{\textrm{predicted}} = \frac{product_{\textrm{guessed}}}{2^{duplication}} \]

<p>In the verification mode, you have done the epPCR and would like to know how many mutations you can expect when you get your sequencing back.</p>

\[duplications_{\textrm{obtained}}=\log_2{\frac{product}{template}}\]

\[load_{\textrm{predicted}}=duplications \cdot errorRate\]


