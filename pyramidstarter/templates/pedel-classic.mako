<div class="card" id="pedelbasic">
    <div class="card-header">
        <h1 class="card-title">Pedel</h1>
        <h3 class="card-subtitle mb-2 text-muted">Programme for Estimating Diversity in Error-prone PCR Libraries</h3>
    </div>
    <div class="card-body">
        <div id="pedel_intro">
            <h3>Description</h3>
            <p>Given a library of <i>L</i> sequences, comprising variants of a sequence
                of <i>N</i> nucleotides, into which random point mutations have been introduced,
                we wish to calculate the expected number of distinct sequences in the library.
                (Typically assuming <i>L</i> &gt; 10, <i>N</i> &gt; 5, and the mean number
                of mutations per sequence <i>m</i> &lt; 0.1 x <i>N</i>).</p>
            <h3>Example (<a data-toggle="collapse" href="#pedel_example"><i class="fa fa-caret-down"
                                                                            aria-hidden="true"></i> show</a>)

            </h3>
            <div class="collapse" id="pedel_example">
                <p>Saab-Rincon et al (2001, <i>Protein Eng.</i>, <b>14</b>, 149-155) constructed
                    a library of 5 million clones with a single round of epPCR on a 700 bp
                    gene. Sequencing 10 of these, indicated an error rate of 3-4 nucleotide
                    substitutions per daughter sequence. Entering <i>L</i>
                    = 5000000, <i>N</i> =
                    700 and <i>m</i> = 3.5 into the base PEDEL sever page, and clicking &apos;Calculate&apos;,
                    shows that the expected number of distinct sequences in the library is
                    4.153 x 10^6, or about 4.2 million.</p>
                <p>If you follow the link to &apos;detailed statistics&apos; and, once again,
                    enter <i>L</i> = 5000000, <i>N</i> = 700 and <i>m</i> = 3.5 and click &apos;Calculate&apos;,
                    you get a breakdown of library statistics for each of the sub-libraries
                    comprising all those daughter sequences with exactly <i>x</i> base substitutions
                    (<i>x</i> = 0, 1, 2, 3, ...).</p>
                <p>For example the first line of the table shows that <b>Px</b> = 3.02% of
                    the library (i.e. <b>Lx</b> = 1.51 x 10^5 daughter sequences) have <i>x</i> =
                    0 base substitutions (i.e. they are identical to the parent sequence).
                    The total number of possible variants with 0 base substitutions is, of
                    course, <b>Vx</b> = 1 (just the parent sequence) and the total number of
                    distinct sequences with 0 base substitutions present in the library is,
                    similarly, <b>Cx</b> = 1. The completeness of the <i>x</i> = 0 sub-library
                    is <b>Cx/Vx</b> = 100%. The redundancy of this sub-library - i.e. wasted
                    duplication - is <b>Lx-Cx</b> = 1.51 x 10^5.</p>
                <p>You also have the option to plot this data by following the &apos;Plot
                    this data&apos; link. Choose the statistic to plot and whether or not to
                    use a logscale on the y-axis. For example, a plot of <b>Px</b> or <b>Lx</b>
                    gives
                    a Poisson distribution. A plot of <b>Vx</b> shows how the number of possible
                    variants increases very rapidly as the number of base substitutions is
                    increased. A plot of <b>Cx</b> shows how the expected number of distinct
                    sequences in the sub-libraries initially increases - limited by the number
                    of possible variants, <b>Vx</b> - and then decreases - limited by the size
                    of the sub-library, <b>Lx</b>. A plot of <b>Lx-Cx</b> shows the extent of
                    wasted duplication in the lower <i>x</i>-value sub-libraries.</p>
                <p>Returning to the base PEDEL server page, you can follow links to plot
                    the expected number of distinct sequences in a library for a range of mutation
                    rates, library sizes or sequence lengths. The third option probably won&apos;t
                    be very useful, but the first two will help you to decide what library
                    size to aim for in order to obtain a given diversity, and what mutation
                    rate to use to maximize the diversity for a given library size.</p>
                <p>For example, follow the &apos;mutation rates&apos; link, enter <i>L</i> =
                    5000000, <i>N</i> = 700 and <i>m</i> = 0.2 - 20, and click &apos;Calculate&apos;.
                    From the plot, you can see that the expected number of distinct sequences
                    increases rapidly with <i>m</i> until <i>m</i> ~ 5, and then levels off with
                    &lt; 10% redundancy in the library. On the other hand, if you chose <i>m</i> ~
                    1.5, then the library would be about 60% redundant. After selecting an
                    optimal mutation rate <i>m</i>, you can go back to the &apos;detailed statistics&apos;
                    page to check the expected completeness of the <i>x</i> = 0, 1, 2, 3, ...
                    sub-libraries.</p>
            </div>
            <h3>Caveats (<a data-toggle="collapse" href="#pedel_caveats"><i class="fa fa-caret-down"
                                                                            aria-hidden="true"></i> show</a>)

            </h3>
            <div class="collapse" id="pedel_caveats">
                <p>PEDEL uses a generic Poisson model of sequence mutations. There are a
                    couple of simplifications that you should be aware of:
                <ul>
                    <li>All base substitution are assumed equally likely. In reality, under error-prone
                        conditions, the polymerase favours some substitutions over others. This
                        has the effect of reducing the expected number of distinct sequences compared
                        with the PEDEL predictions. This is in fact not as big an issue as you
                        might expect. Using the notation from the &apos;detailed statistics&apos;
                        page (see link on base PEDEL server page), this is not an issue when the
                        number of possible variants <b>Vx</b> is much greater than the sub-library
                        size <b>Lx</b> (i.e. large <i>x</i> values), since here there are so many possible
                        variants that there is little duplication within the sub-library even if
                        there is strong bias. Conversely, if <b>Lx</b> is much greater than <b>Vx</b> (i.e.
                        small <i>x</i>
                        values) then, unless the bias is very strong, nearly all the
                        possible variants will still be sampled. Note that it is now possible,
                        by using sequential PCR amplifications with two different polymerases that
                        have opposite substitution biases, to produce unbiased libraries.
                    </li>
                    <li>Inherent to the PCR process used to produce epPCR libraries, is amplification
                        bias: any mutation introduced in an early PCR cycle, will be present in
                        a significant fraction of the final library. In practice, researchers use
                        a variety of techniques to reduce amplification bias - e.g. reduce the
                        number of epPCR cycles and combine a number of individual libraries. For
                        example, one might start with 10^9 identical parent sequences; amplify
                        them in an epPCR to 10^15 sequences; and, after ligation and transformation
                        of <i>E. coli</i>, end up with a library of 10^7 sequences. Any amplification
                        bias would have a maximum frequency of only 1 in 10^9 so would not show
                        up in the final library.
                    </li>
                    <li>During the PCR cycles, different parent sequences may be amplified a different
                        number of times. However, empirically, the end result is a library with
                        a Poisson distribution of mutations (e.g. Cadwell R.C., Joyce G.F., 1992,
                        Randomization of genes by PCR mutagenesis, <i>PCR Methods Appl.</i>, <b>2</b>,
                        28-33). <b>But see

                            also this <a href="https://blog.matteoferla.com/2018/08/pcr-distribution.html"
                                         target="_blank">note <i class="fa fa-external-link"
                                                                 aria-hidden="true"></i></a>.</b>
                    </li>
                    <li>Any biases in library construction will decrease the actual number of
                        distinct variants represented in the library. In such cases, PEDEL provides
                        the user with a useful upper bound on the diversity present in the library.
                    </li>
                </ul>
                Please refer to Patrick W. M., Firth A. E., Blackburn J.M., 2003, User-friendly
                algorithms for estimating completeness and diversity in randomized protein-encoding
                libraries, <i>Protein Eng.</i>, <b>16</b>, 451-457 for further discussion
                of PEDEL.</p>
                <p>A good review of the sources of bias in epPCR (and other directed evolution
                    protocols) can be found in Neylon C., 2004, Chemical and biochemical strategies
                    for the randomization of protein encoding DNA sequences: library construction
                    methods for directed evolution, <i>Nucleic Acids Res.</i>, <b>32</b>, 1448-1459.</p>
            </div>
        </div>
        <h3>Input</h3>
        <div class="row">
            <div class="col-xl-4">
                <div class="input-group">
                    <span class="input-group-prepend" data-toggle="tooltip" title="Library size L" data-placement="top">
                        Library size</span>
                    <input type="number" min="0" class="form-control"
                           placeholder="10000000" id="pedel_size">
                </div>
                <br>
            </div>
            <div class="col-xl-4">
                <div class="input-group"> <span class="input-group-prepend" data-toggle="tooltip"
                                                title="Sequence length N (nt)"
                                                data-placement="top">Seq. length</span>
                    <input type="number" min="0" class="form-control"
                           placeholder="1000" id="pedel_len"> <span class="input-group-addon">nt</span>
                </div>
                <br>
            </div>
            <div class="col-xl-4">
                <div class="input-group"> <span class="input-group-prepend" data-toggle="tooltip"
                                                title="Mean number of point mutations per sequence m"
                                                data-placement="top">Load</span>
                    <input type="number" min="0" class="form-control"
                           placeholder="4" id="pedel_mutload"> <span
                            class="input-group-addon">Mutations/seq</span>
                </div>
                <br>
            </div>
            <!-- <div class="col-xl-4">

                <div class="input-group">

                    Distribution

                    <input type="checkbox"

                           title="Number of mutations per sequence: use Poisson or PCR distribution (see note; PCR efficiency calculator)."

                           class="switch" id="pedel_PCR" data-off-text="Poisson"

                           data-on-text="+ PCR" data-off-color="warning">

                </div>

                <br/>

            </div>-->
            <br>
        </div>
        <!--row-->
        <div class="row">
            <div id="pedel_&#xA7;cycles" class="card bg-light card-body mb-3 well-lg">
                <div class="col-xl-4">
                    <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip"
                                                    title="Number of PCR cycles"
                                                    data-placement="top">PCR cycles</span>
                        <input type="number" min="0" class="form-control"
                               placeholder="4.5" id="pedel_cycles">
                    </div>
                </div>
                <div class="col-xl-4">
                    <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip"
                                                    title="PCR efficiency"
                                                    data-placement="top">PCR efficiency</span>
                        <input type="number" min="0"
                               max="1" class="form-control" placeholder="0.6" id="pedel_efficiency">
                    </div>
                </div>
                <div class="col-xl-2">
                    <button type="button" class="btn btn-info" data-toggle="modal"
                            data-target="#pedel_calc_modal"><i class="fa fa-calculator" aria-hidden="true"></i>
                        Calculator
                    </button>
                </div>
                <br>
            </div>
        </div>
        <!-- <p>For a note about Poisson vs. PCR distribution see <a href="#" data-toggle="modal"

                                                                data-target="#pedel_note">here</a>.</p>-->
        <div class="row">
            <div class="col-xl-6 offset-lg-3">
                <div class="btn-group" role="group" aria-label="...">
                    <button type="button" class="btn btn-warning" id="pedel_clear"><i class="fa fa-eraser"
                                                                                      aria-hidden="true"></i>
                        Clear
                    </button>
                    <button type="button"
                            class="btn btn-info" id="pedel_demo"><i class="fa fa-gift"
                                                                    aria-hidden="true"></i> Demo
                    </button>
                    <button type="button"
                            class="btn btn-success" id="pedel_calculate"><i class="fa fa-exchange"
                                                                            aria-hidden="true"></i>
                        Calculate
                    </button>
                </div>
            </div>
            <br>
        </div>
        <div class="row hidden" id="pedel_result">
            <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went
                wrong
            </div>
            <br>
        </div>
    </div>
</div>