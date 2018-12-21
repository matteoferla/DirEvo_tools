<%page args="page"/>
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

<h4>Mutational load</h4>
<p>The simplest and most commonly employed estimate of the frequency of mutations per sequence is the
average of the point mutations per sequence (<i>m</i>), however due to
the small sample size this may be off. </p>
<p>The distribution of number of mutations per sequence follows a PCR distribution, which can <span class="note" data-toggle="tooltip"
                                                         data-placement="bottom"
                                                         title="converging as the number of PCR cycles tends to infinity">approximated</span>
with a Poisson distribution (<span class="note" data-toggle="tooltip" data-placement="bottom"
                                   title="Sun F. (1995). The polymerase chain reaction and branching processes, J. Comput. Biol., 2, 63-86.">Sun, 1995</span>).</p>
<p>Due to the fact that calculating the PCR efficiency using the total set PCR cycles is misleading, the distribution is omitted here, but would give similar results (cf. <a href="/main/glossary#Sun">FAQ</a>)</p>
<p>In the <span class="note" data-toggle="tooltip" data-placement="bottom"
             title="and the former at number of cycles (&lt;i&gt;n&lt;/i&gt;&lt;sub&gt;PCR&lt;/sub&gt;) = &#x221E;  as the variance is equal to the mean &lt;b&gt;plus&lt;/b&gt; the square of the mean divided by the &lt;i&gt;n&lt;/i&gt;&lt;sub&gt;PCR&lt;/sub&gt; scaled by the PCR efficiency.">latter</span>,
the mean and the variance are the same (&#x3BB; &#x2014;unrelated to PCR
efficiency&#x2014;). The <em>sample</em> average and variance may differ,
especially at low sampling. The number to trust the most is the &#x3BB;<sub>Poisson</sub>.</p>