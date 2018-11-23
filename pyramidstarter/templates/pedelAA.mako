<%page args="page, collapse_section"/>
<div class="card" id="pedelAA">
    <div class="card-header">
        <h1 class="card-title">PedelAA</h1>
        <h3 class="card-subtitle mb-2 text-muted">Programme for Estimating Diversity in Error-prone PCR Libraries (amino acid version)</h3>
    </div>
    <div class="card-body">
        <div id="pedelAA_intro">
            <h3>Description</h3>
            ${collapse_section('pedelAA_overview','Overview', file='pedelAA_overview.mako') |n}
            ${collapse_section('pedelAA_Rx_note','Note on R<sub>x</sub> statistics', file='pedelAA_note_on_Rx.mako') |n}
        </div>


        <div id="pedelAA_input">
            <h3>Input</h3>
            <!--section-->
            <h4>Sequence</h4>
            <p>In frame sequence that was mutagenised. Note that all symbols that aren&apos;t
                uppecase ATUGC, will be discarded along with a Fasta header (<i>e.g.</i> &apos;&gt;T.
                maritima Cystathionine &#x3B2;-lyase&apos;), therefore for masked sequences
                use lowercase.</p>

            <div class="row">
                <div class="col-xl-12 mb-1">
                    <div class="input-group">
                        <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                             title="In frame sequence that was mutagenised.">
                            <span class="input-group-text">Sequence</span>

                        </div>
                        <textarea class="form-control custom-control"
                                  rows="5" style="resize:none" id="pedelAA_sequence" name="pedelAA_sequence">ATGGTGAGCAAGGGCGAGGAGCTGTTCACCGGGGTGGTGCCCATCCTGGTCGAGCTGGACGGCGACGTAAACGGCCACAAGTTCAGCGTCCGCGGCGAGGGCGAGGGCGATGCCACCAACGGCAAGCTGACCCTGAAGTTCATCTGCACCACCGGCAAGCTGCCCGTGCCCTGGCCCACCCTCGTGACCACCTTCGGCTACGGCGTGGCCTGCTTCAGCCGCTACCCCGACCACATGAAGCAGCACGACTTCTTCAAGTCCGCCATGCCCGAAGGCTACGTCCAGGAGCGCACCATCTCTTTCAAGGACGACGGTACCTACAAGACCCGCGCCGAGGTGAAGTTCGAGGGCGACACCCTGGTGAACCGCATCGAGCTGAAGGGCATCGACTTCAAGGAGGACGGCAACATCCTGGGGCACAAGCTGGAGTACAACTTCAACAGCCACTACGTCTATATCACGGCCGACAAGCAGAAGAACTGCATCAAGGCTAACTTCAAGATCCGCCACAACGTTGAGGACGGCAGCGTGCAGCTCGCCGACCACTACCAGCAGAACACCCCCATCGGCGACGGCCCCGTGCTGCTGCCCGACAACCACTACCTGAGCCATCAGTCCAAGCTGAGCAAAGACCCCAACGAGAAGCGCGATCACATGGTCCTGCTGGAGTTCGTGACCGCCGCCGGGATTACACATGGCATGGACGAGCTGTACAAGTAA</textarea>
                        <div class="input-group-append">
                            <button class="btn btn-secondary" type="button" id="pedelAA_sequence_retrieve"
                                    data-toggle="tooltip" data-placement="top"
                                    title="In frame sequence that was mutagenised."><i class="fa fa-history"></i><br/>Retrieve previous
                            </button>
                        </div>
                    </div>
                    <br>
                </div>
            </div>
            <div class="row">
                <div class="col-xl-5 mb-1">
                    <div class="input-group">
                        <div class="input-group-prepend" data-toggle="tooltip"
                             title="Library size L"
                             data-placement="top">
                            <span class="input-group-text">Library size</span>
                            <input type="number" min="0" class="form-control"
                                   placeholder="10000000" id="pedelAA_size">
                            <div class="input-group-append"><span class="input-group-text">nt</span></div>
                        </div>
                        <br>
                    </div>
                </div>
            </div>
            <h4>Nucleotide mutation matrix</h4>
            <p>(non-negative numbers. Overall scaling is unimportant as this is taken
                from the &apos;mean number of substitutions per daughter sequence&apos;
                parameter.)</p>
            <%include file="bias_block.mako" args="tool='pedelAA'"/>
            <div class="row">
                <div class="col-xl-4 mb-1">
                    <div class="input-group">
                        <input type="checkbox" class="switch" id="pedelAA_normal" data-off-text="Unnormalised"
                               data-on-text="Normalised" data-off-color="warning">
                        <div class="input-group-append"><span class="input-group-text">values</span></div>
                    </div>
                </div>
                <div class="col-xl-4 mb-1">
                    <div class="input-group">
                        <div class="input-group-prepend" data-toggle="tooltip"
                             title="Mean number of nucleotide substitutions per daughter sequence"
                             data-placement="top">
                            <span class="input-group-text">Load</span>
                        </div>
                        <input type="number" min="0" class="form-control"
                               placeholder="4.5" id="pedelAA_load">
                        <div class="input-group-append">
                            <span class="input-group-text">mutations/seq</span>
                        </div>
                    </div>
                </div>
                <br>
            </div>
            <div class="row">
                <div id="pedelAA_&#xA7;cycles" class="card bg-light card-body mb-3 well-lg">
                    <div class="col-xl-4 mb-1">
                        <div class="input-group">
                            <div class="input-group-prepend" data-toggle="tooltip"
                                 title="Number of PCR cycles"
                                 data-placement="top">
                                <span class="input-group-text">PCR cycles</span>
                            </div>
                            <input type="number" min="0" class="form-control"
                                   placeholder="4.5" id="pedelAA_cycles">
                        </div>
                    </div>
                    <div class="col-xl-4 mb-1">
                        <div class="input-group">
                            <div class="input-group-prepend" data-toggle="tooltip"
                                 title="PCR efficiency"
                                 data-placement="top">
                                <span class="input-group-text">PCR efficiency</span>
                            </div>
                            <input type="number" min="0"
                                   max="1" class="form-control" placeholder="0.6" id="pedelAA_efficiency">
                        </div>
                    </div>
                    <div class="col-xl-2 mb-1">
                        <button type="button" class="btn btn-info" data-toggle="modal"
                                data-target="#pedelAA_calc_modal"><i
                                class="fa fa-calculator" aria-hidden="true"></i> Calculator
                        </button>
                    </div>
                </div>
            </div>
            <!-- <p>For a note about Poisson vs. PCR distribution see <a href="#" data-toggle="modal"

                                                                                    data-target="#pedel_note">here</a>.</p>-->
            <!--button row-->
            <div class="row">
                <div class="col-xl-6 offset-lg-3 mt-1">
                    <div class="btn-group" role="group" aria-label="...">
                        <button type="button" class="btn btn-warning" id="pedelAA_clear"><i class="fa fa-eraser"
                                                                                            aria-hidden="true"></i>
                            Clear
                        </button>
                        <button type="button"
                                class="btn btn-info" id="pedelAA_demo"><i class="fa fa-gift" aria-hidden="true"></i>
                            Demo
                        </button>
                        <button type="button"
                                class="btn btn-success" id="pedelAA_calculate"><i class="fa fa-exchange"
                                                                                  aria-hidden="true"></i>
                            Calculate
                        </button>
                    </div>
                </div>
                <br>
            </div>
        </div>
        <div class="hidden" id="pedelAA_result">
            <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong
            </div>
            <br>
        </div>
        <!-- Modals -->
        <div id="pedelAA_calc_modal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&#xD7;</button>
                        <h4 class="modal-title">Modal Header</h4>
                    </div>
                    <div class="modal-body">
                        <p>Some text in the modal.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modals -->
        <div id="pedel_note" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&#xD7;</button>
                        <h4 class="modal-title">Modal Header</h4>
                    </div>
                    <div class="modal-body">
                        <p>In our paper (Firth &amp; Patrick, 2005), we assumed a Poisson distribution
                            to determine the fraction of sequences in an epPCR library that contain
                            exactly 0, 1, 2, 3, ... mutations, given the mean number of mutations, <i>m</i>,
                            per sequence.</p>
                        <p>Since publication of Firth &amp; Patrick (2005), however, Drummond et
                            al. (2005) have revisited the pioneering work of Sun (1995) and provided
                            experimental evidence in support of his more accurate equation describing
                            the distribution of <i>m</i>. This &apos;PCR distribution&apos; takes into
                            account the number of PCR thermal cycles <i>ncycles</i> and the PCR efficiency <i>eff</i>
                            (i.e.
                            the probability that any particular sequence is duplicated in a given PCR
                            cycle). We have therefore now included the PCR distribution as an optional
                            alternative to the Poisson distribution in PEDEL.</p>
                        <p>For large <i>m</i>, small <i>ncycles</i>, or low <i>eff</i>, the PCR distribution
                            is broader than the Poisson distribution. For low <i>m</i>, large <i>ncycles</i> and
                            large <i>eff</i>, the PCR distribution approximates the Poisson distribution.
                            In a &apos;typical&apos; epPCR (e.g. <i>ncycles</i> = 30, <i>eff</i> = 0.6, <i>m</i> =
                            4), the estimated total number of distinct sequences in a library typically
                            agrees to within 5% for the two distributions, though the sub-library statistics
                            can show more variation.</p>
                        <p>If you know <i>ncycles</i> and <i>eff</i>, then we recommend that you use
                            the PCR distribution instead of the Poisson distribution. Drummond et al.
                            (2005) use the formula <i>d</i> = <i>ncycles</i> &#xD7; <i>eff</i>, where <i>d</i> is
                            the number of doublings. For example, if you start with 10^9 identical
                            parent sequences and amplify them in an epPCR to 10^15 sequences, then
                            you have had about <i>d</i> = 20 doublings (10^9 &#xD7; 2^20 ~= 10^15), and
                            you can calculate <i>eff</i> = <i>d</i> &#xF7; <i>ncycles</i>. Actually the <i>d</i> =
                            <i>ncycles</i> &#xD7; <i>eff</i> formula
                            is wrong. The correct formula is 2^d = (1+eff)^ncycles, so that the efficiency
                            is given by eff = 2^(d/ncycles) - 1 (<a href="/cgi-bin/aef/PCReff.pl">PCR efficiency
                                calculator</a>).
                        </p>
                        <h3>References</h3>
                        <li>Drummond D.A., Iverson B.L., Georgiou G., Arnold F.H. (2005). Why high-error-rate
                            random mutagenesis libraries are enriched in functional and improved proteins, <i>J. Mol.
                                Biol.</i>,
                            <b>350</b>,
                            806-816.
                        </li>
                        <li>Firth A.E., Patrick W.M., (2005). Statistics of protein library construction, <i>Bioinformatics</i>,
                            <b>21</b>,
                            3314-3315.
                        </li>
                        <li>Sun F. (1995). The polymerase chain reaction and branching processes, <i>J. Comput.
                            Biol.</i>,
                            <b>2</b>,
                            63-86.
                        </li>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="pedelAA_exact_modal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&#xD7;</button>
                        <h4 class="modal-title">Notes about Cx estimations</h4>
                    </div>
                    <div class="modal-body">
                        <h2 id="pedelAA_exact">PEDEL-AA x = 0, 1 and 2 sub-library statistics</h2>
                        <p>For x = 0, 1 and 2, we calculate the expected number of distinct variants,
                            Cx, precisely. This calculation includes variants with multiple nucleotide
                            substitutions in the same codon.</p>
                        <p>The total number of each of the 64 codon types in the input sequence is
                            calculated. The 64 x 20 matrix of probabilities for each codon type mutating
                            to each amino acid type is calculated using the input nucleotide substitution
                            matrix and the input substitution rate.</p>
                        <p>For x = 0, 1 and 2 there are, respectively Vx_2 = 1, 19N and 361N(N-1)/2
                            total possible <a href="pedel-AA_variants.html">variants</a>
                            (i.e. N!/[x!(N-x)!]
                            19^x, where N is the length of the input sequence in codons). The probability
                            of the input sequence mutating to each of these possible variants is calculated
                            and renormalized by the respective probability sum P0, P1 or P2 (where
                            Px = Sum_{v_i in Vx_2} P(v_i)) to give the normalized probabilities Pn(v_i)
                            of the different variants within the respective sub-libraries Lx, rather
                            than within the whole library. The probability of a particular variant
                            v_i being present in the relevant sub-library Lx is given by 1 - exp(-Pn(v_i)
                            x Lx). These probabilities are quickly summed over all possible variants
                            using the codon counts. Computationally, this is very fast for x = 0, 1
                            and 2, but can take a few minutes for x = 3; hence the &apos;exact&apos;
                            calculation is not used on the webserver for x &gt;= 3. The sizes of the
                            sub-libraries Lx are determined separately for the Poisson and PCR distributions
                            as described in the <a href="pedel-AA-stats.html">notes on the PEDEL-AA algorithms</a>,
                            thus resulting in separate Cx estimates for the different distributions.</p>
                        <p>Ideally, for x &gt;= 3, we will enter the <a href="pedel-AA_CxLx.html">Cx ~

                            Lx</a> region. In this case all the individual Cx estimates, and the estimated
                            total number of distinct variants in the library C = C0 + C1 + C2 + ...,
                            will be fairly good. A warning is printed in the &apos;notes&apos; column
                            if there are any x &gt;= 3 values for which the Cx ~ Lx approximation may
                            not apply, in which case Cx is estimated with the formula Cx ~ Vx_1(1-exp(-Lx/Vx_1))
                            (i.e. ignoring, in these particular sub-libraries, any <a href="pedel-AA_variants.html">variants</a>
                            of
                            type Vx_2).</p>
                        <p>See also <a href="pedel-AA-stats.html">notes on the PEDEL-AA

                            algorithms</a>.</p>
                    </div>
                </div>
            </div>
        </div>
        <div id="pedelAA_CxLx_modal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&#xD7;</button>
                        <h4 class="modal-title">Notes about Cx estimations</h4>
                    </div>
                    <div class="modal-body">
                        <h2 id="pedelAA_CxLx">PEDEL-AA Cx ~ Lx region</h2>
                        <p>When Lx &lt;&lt; Vx then Cx ~ Lx. For equiprobable variants this approximation
                            is good to 5% for Lx &lt; 0.1 Vx (see the mathematical
                            <a href="../notes.pdf">notes</a> on
                            PEDEL). For PEDEL-AA, we use this approximation when Lx &lt; 0.1 Vx_1 (the
                            number of &apos;easy-to-reach&apos; variants).</p>
                        <p>See also <a href="pedel-AA_exact.html">notes on the &apos;exact&apos;

                            calculations</a> and <a href="pedel-AA-stats.html">notes on the PEDEL-AA

                            algorithms</a>.</p>
                    </div>
                </div>
            </div>
        </div>
        <div id="pedelAA_warningRx_modal" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&#xD7;</button>
                        <h4 class="modal-title">Notes about Cx estimations</h4>
                    </div>
                    <div class="modal-body">
                        <h2 id="pedelAA__warningRx">PEDEL-AA Rx warning</h2>
                        <p>For x = 0, 1 and 2, we calculate the expected number of distinct variants,
                            Cx, <a href="pedel-AA_exact.html">precisely</a>. When Lx &lt; 0.1 Vx_1 (i.e.
                            for large x values), we use the <a href="pedel-AA_CxLx.html">Cx ~ Lx</a> approximation.
                            Sometimes using the criterion &apos;Lx &lt; 0.1 Vx_1&apos; to determine
                            whether or not we are in the &apos;Cx ~ Lx&apos; region is not sufficient.
                            This is indicated by the corresponding Rx value not being &lt; 0.1. In
                            this case the corresponding Cx value may be an overestimate.</p>
                        <p>See also <a href="pedel-AA_Rx.html">notes on the &apos;Rx &lt; 0.1&apos;

                            criterion</a> and
                            <a href="pedel-AA-stats.html">notes on the PEDEL-AA

                                algorithms</a>.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>