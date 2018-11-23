<p>Error prone PCR is a method to create a pool of amplicons with some random
errors. For the best results the number of mutations and the ${page.term_helper('spectrum')|n} of
the mutations needs to be controlled, hence the need for a test library.
The calculations of a test libray are slightly laborious and are affected
by the very small sample size. This calculator tries to overcome these
two issues by computing the ${page.term_helper('bias', 'mutational biases')|n} given a starting sequence
and list of mutant genotypes, by calculating the mutations per sequence
by fitting it to a Poisson distribution and by estimating the errors in
the values. In particular, the errors are calculated using the assumption
that a mutation and its complementary are equally likely in light of the
double helix nature of DNA (<i>e.g.</i> A to G on one strand will result
in T to C on the other). For the specific formulae used see <a href="/static/variance_note.html"
                                                               data-tooltip="walkthrough of variance calculations"> this note about propagating
    errors.</a>
<br>The program can calculate mutation frequencies from the list of mutations
found and the template sequence or it can also accept the frequencies directly.
The <a href="javascript:Btn_demo();">&apos;Demo&apos;</a> values are from
an actual experiment.</p>