<%page args="page, collapse_section"/>
<div class="card">
    <div class="card-header">
        <h1 class="card-title">Mutanalyst<img src="/static/mutanalyst logo-01.svg" alt="Mutanalyst logo" style="height:2em; vertical-align: -50%;"></h1>
        <h4 class="card-subtitle mb-2 text-muted">Mutational load and spectrum calculator for epPCR libraries
            with poor sampling</h4>
    </div>
    <div class="card-body">
        <h3>Choose starting point</h3>
        <div class="row">
            <div class="col-12 col-lg-8">
                <p>There are two possible starting points for mutanalysts.
            <br/>One is proving a sequence and the mutations sampled, for which the ${page.term_helper('load','mutational load')|n},
            ${page.term_helper('spectrum','mutational spectrum')|n} and the ${page.term_helper('bias','mutational bias indicators')|n} will be calculated.
            <br/>The other is more downstream, wherein one proves a mutational spectrum
            and mutational load and the mutational bias indicators will be calculated.</p>
            </div>
            <div class="col-12 col-lg-4 py-4">
                <div class="input-group">
                <div class="input-group-prepend" data-toggle="tooltip" title="Choose starting point"
                     data-placement="top">
                    <span class="input-group-text">Choose:</span></div>
                <input type="checkbox" class="switch"
                       id="mutanalyst_method" checked data-off-text="Spectrum" data-on-text="Mutations"
                       data-off-color="warning" data-size="large">
            </div>
            </div>
        </div>
        <p>If you want to know what mutations you have in a series of ab1 files check
        out out <a href="mutantcaller">Mutantcaller</a>.
        <br/>If you want to know the library composition (<i>e.g.</i> redundancy) check
        out <a href="pedel">PedelAA</a> or go to the bottom of this page.</p>

        <!--section-->
        <div id="mutanalyst_seq&#xA7;">
            <h3>Starting from a sequence and a mutant genotype list</h3>
            <!--section-->
            <h4>Sequence</h4>
            <p>In frame sequence that was mutagenised. Note that all symbols that aren&apos;t
                uppecase ATUGC, will be discarded along with a Fasta header (<i>e.g.</i> &apos;&gt;T.
                maritima Cystathionine &#x3B2;-lyase&apos;), therefore for masked sequences
                use lowercase.</p>
            <div class="row">
                <div class="col-xl-12">
                    <div class="input-group">
                        <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                             title="In frame sequence that was mutagenised.">
                            <span class="input-group-text">Sequence</span>

                        </div>
                        <textarea class="form-control custom-control"
                                  rows="5" style="resize:none; min-width: 60%;" id="sequence" name="sequence"></textarea>
                        <div class="input-group-append">

                            <button class="btn btn-secondary" type="button" id="sequence_retrieve" data-toggle="tooltip" data-placement="top"
                                    title="In frame sequence that was mutagenised."><i class="fa fa-history"></i><br/>Retrieve previous
                            </button>

                        </div>
                    </div>
                    <br/>
                </div>
            </div>
            <br/>
            <!--section-->

            <h4>Library size</h4>
            <div class="row mb-3">
                <div class="col-12 col-lg-6">For Pedel-AA calculations, the library size is required.</div>
                <div class="col-12 col-lg-6"><div class="input-group">
                    <div class="input-group-prepend" id="library_addon">
                        <span class="input-group-text">Size</span></div>
                    <input type="number"
                           class="form-control" placeholder="1000000" aria-describedby="library_addon"
                           id="library_size">
                </div></div>
            </div>

                <h4>Mutations found</h4>
                <p>This is the list of the mutations found. Identifying the mutations can
                    be done using the <a href="/main/mutantcaller">Mutantcaller</a> tool.
                    <br/>The format is as follows:</p>

                <ul>
                    <li>Each <span class="note" data-toggle="tooltip" data-placement="top"
                                   title="separated by space, new-line (Enter on Win), carriage return (Enter on Mac), both (Enter on Linux) or semicolon (MatLab style).">line</span>
                        contains
                        <span
                                class="note"
                                data-tooltip="separated by a space, tab or comma, but not non-breaking space, hyphens, dashes or dots">one or more</span>mutations
                        of a variant sampled.
                    </li>
                    <li>The mutations can only be in the forms A123C (technically non-standard for nucleotides) or 123A&gt;C, where the number
                        is irrelevant (and can be omitted).
                    </li>
                    <li>A wild type sequence can be indicated with <span class="note" data-toggle="tooltip"
                                                                         data-placement="top"
                                                                         title="wt or WT or wild, but not an identity 123A&gt;A as that will count as a mutation (roundtrip)">&apos;wt&apos;</span>,
                        it is not needed for the main calculations and it is used solely for the
                        mutational frequency &#x2014;and useful for Pedel.
                    </li>
                    <li>Rarer events such as insertions, deletion, duplications, frameshifts and
                        inversions, are not taken into account, but their frequency can be easily
                        calculated using the &apos;values for further analysis&apos; below.
                    </li>
                </ul>
            <div class="row pb-4">
                <div class="input-group">
                    <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                         title="List of the mutations found">
                        <span class="input-group-text">Variants</span>

                    </div>
                    <textarea class="form-control custom-control"
                              name="baseList" rows="5" id="baseList" style="resize:none"></textarea>
                </div>
            </div>
            <%include file="calculate_btns.mako" args="tool='mutanalyst_freq'"/>

        </div>
        <div id="mutanalyst_freq&#xA7;">
            <!--section-->
            <h3>Mutational frequency</h3>
            <p>The simplest estimate of the frequency of mutations per sequence is the
                average of the point mutations per sequence (<i>m</i>), however due to
                the small sample size this may be off. The distribution of number of mutations
                per sequence follows a PCR distribution, which can <span class="note" data-toggle="tooltip"
                                                                         data-placement="bottom"
                                                                         title="converging as the number of PCR cycles tends to infinity">approximated</span>
                with
                a Poisson distribution (<span class="note" data-toggle="tooltip" data-placement="bottom"
                                              title="Sun F. (1995). The polymerase chain reaction and branching processes, J. Comput. Biol., 2, 63-86.">Sun, 1995</span>).
                In the <span class="note" data-toggle="tooltip" data-placement="bottom"
                             title="and the former at number of cycles (&lt;i&gt;n&lt;/i&gt;&lt;sub&gt;PCR&lt;/sub&gt;) = &#x221E;  as the variance is equal to the mean &lt;b&gt;plus&lt;/b&gt; the square of the mean divided by the &lt;i&gt;n&lt;/i&gt;&lt;sub&gt;PCR&lt;/sub&gt; scaled by the PCR efficiency.">latter</span>,
                the mean and the variance are the same (&#x3BB; &#x2014;unrelated to PCR
                efficiency&#x2014;). The <em>sample</em> average and variance may differ,
                especially at low sampling. The number to trust the most is the &#x3BB;<sub>Poisson</sub>.</p>
            <p
                    class="marginless">The average is <strong><span id="freqMean">N/A</span></strong> mutations
                per sequence (<span id="size">N/A</span> kb).</p>
            <p class="marginless">The sample variance is <strong><span id="freqVar">N/A</span></strong> mutations
                per sequence.</p>
            <p class="marginless">The &#x3BB;<sub>Poisson</sub> is <strong><span id="freq&#x3BB;">N/A</span></strong> mutations
                per sequence.</p>
            <br/>
            <div id="disChart" style="width: 80%; height:400px"></div>
            <p class="marginless">If the &#x3BB;<sub>Poisson</sub> and average are very different and the
                plot is very poor, sequencing more variants from the test library may be
                reccomendable.</p>
        </div>
        <div id="mutanalyst_freq_alt_in&#xA7;">
            <!--section-->
            <h3><span id="altH">Starting from a</span> table of tallied nucleotide specific mutations &#xA0;<span id="altH_showing"><button type="button"
                                                                                                                                            class="btn btn-info"
                                                                                                                                            id="altH_showing_button_on">Show</button><button
                    type="button" class="btn btn-warning" id="altH_showing_button_off">hide</button></span></h3>
            <div id="alt&#xA7;">
                <p>Rows represent the wildtype base, while columns the base in the mutant.</p>
                <%include file="bias_block.mako" args="tool='mutanalyst'"/>
                <br/>
                <div class="row pb-3">
                    <div class="col-12 col-md-6"><div class="input-group">
                    <div class="input-group-prepend" id="basic-addonA">
                        <span class="input-group-text">Proportion of adenine</span></div>
                    <input
                            type="text" class="form-control" id="sumA" value="25" aria-describedby="basic-addonA">
                    <div class="input-group-append">
                        <span class="input-group-text">%</span>
                    </div>
                </div></div>
                    <div class="col-12 col-md-6"><div class="input-group">
                    <div class="input-group-prepend" id="basic-addonT">
                        <span class="input-group-text">Proportion of thymine</span></div>
                    <input
                            type="text" class="form-control" id="sumT" value="25" aria-describedby="basic-addonT">
                    <div class="input-group-append">
                        <span class="input-group-text">%</span>
                    </div>
                </div></div>
                    <div class="col-12 col-md-6"><div class="input-group">
                    <div class="input-group-prepend" id="basic-addonG">
                        <span class="input-group-text">Proportion of guanine</span>
                    </div>
                    <input
                            type="text" class="form-control" id="sumG" value="25" aria-describedby="basic-addonG">
                    <div class="input-group-append">
                        <span class="input-group-text">%</span>
                    </div>
                </div></div>
                    <div class="col-12 col-md-6"><div class="input-group">
                    <div class="input-group-prepend" id="basic-addonC">
                        <span class="input-group-text">Proportion of cytosine</span>
                    </div>
                    <input
                            type="text" class="form-control" id="sumC" value="25" aria-describedby="basic-addonC">
                    <div class="input-group-append">
                        <span class="input-group-text">%</span>
                    </div>
                </div></div>
                </div>
                <%include file="calculate_btns.mako" args="tool='mutanalyst_bias'"/>
            </div>
        </div>
        <div id="mutanalyst_corrected&#xA7;">
            <!--section-->
            <div class="col-xl-7">
                <h2>Corrected mutation incidence</h2>
                <table class="clearless">
                    <tr>
                        <th width="25%" class="clearless">Data display options</th>
                        <td width="5%" class="clearless">
                            <input type="radio" name="fig" value="1" onclick="svg();">
                        </td>
                        <td width="20%" class="clearless">Raw data</td>
                        <td width="5%" class="clearless">
                            <input name="fig" type="radio" onclick="svg();" value="2" checked>
                        </td>
                        <td width="20%" class="clearless">Frequency normalised</td>
                        <td width="5%" class="clearless">
                            <input type="radio" name="fig" value="3" onclick="svg();">
                        </td>
                        <td width="20%" class="clearless">Strand complimentary normalised</td>
                    </tr>
                </table>
                <p id="mutBlabla">Sequence-composition&#x2013;corrected incidence of mutations (%):</p>
                <table
                        id="outTable" width="80%">
                    <thead>
                    <tr>
                        <th width="20%">From/To</th>
                        <th width="20%">A</th>
                        <th width="20%">T</th>
                        <th width="20%">G</th>
                        <th width="20%">C</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <th>A</th>
                        <td bgcolor="#CCCCCC"></td>
                        <td bgcolor="#FFFF99"></td>
                        <td bgcolor="#99FFFF"></td>
                        <td bgcolor="#FFFF99"></td>
                    </tr>
                    <tr>
                        <th>T</th>
                        <td bgcolor="#FFFF99"></td>
                        <td bgcolor="#CCCCCC"></td>
                        <td bgcolor="#FFFF99"></td>
                        <td bgcolor="#99FF99"></td>
                    </tr>
                    <tr>
                        <th>G</th>
                        <td bgcolor="#99FFFF"></td>
                        <td bgcolor="#FFFF99"></td>
                        <td bgcolor="#CCCCCC"></td>
                        <td bgcolor="#FFFF99"></td>
                    </tr>
                    <tr>
                        <th>C</th>
                        <td bgcolor="#FFFF99"></td>
                        <td bgcolor="#99FF99"></td>
                        <td bgcolor="#FFFF99"></td>
                        <td bgcolor="#CCCCCC"></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="col-xl-5">
                <h3>Graphical Representation</h3>
                <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg"
                        x="0px" y="0px" width="250px" height="250px" viewbox="0 0 250 250" enable-background="new 0 0 250 250"
                        xml:space="preserve" style="stroke-width: 0px; background-color: white;">
                            <text transform="matrix(1 0 0 1 27.1714 46.6031)" font-family="&apos;Verdana&apos;"
                            font-size="36">A</text>
                            <text transform="matrix(1 0 0 1 25.5189 224.1352)" font-family="&apos;Verdana&apos;"
                            font-size="36">G</text>
                            <text transform="matrix(1 0 0 1 194.2528 46.6032)" font-family="&apos;Verdana&apos;"
                            font-size="36">C</text>
                            <text transform="matrix(1 0 0 1 198.715 224.1356)" font-family="&apos;Verdana&apos;"
                            font-size="36">T</text>
                            <line id="AC_line" fill="none" stroke="#000000" stroke-width="2"
                            stroke-miterlimit="10" x1="177.808" y1="41.518" x2="60.122" y2="41.518"
                            />
                            <line id="AG_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="34.476" y1="174.303" x2="34.476" y2="56.616" />
                    <!--issue. seems right-->
                            <line id="AT_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="57.354" y1="59.616" x2="178.576" y2="180.838" />
                            <line id="TA_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="73.889" y1="62.151" x2="195.111" y2="183.373" />
                    <!--issue?? Appaers TA-->
                            <line id="TC_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="214.821" y1="186.373" x2="214.821" y2="68.687" />
                            <line id="CG_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="188.111" y1="52.616" x2="66.889" y2="173.838" />
                    <!--issue-->
                            <line id="CA_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="189.878" y1="31.518" x2="72.192" y2="31.518" />
                    <!--CA? -->
                            <line id="TG_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="189.878" y1="209.05" x2="72.192" y2="209.05" />
                            <line id="CT_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="204.821" y1="174.303" x2="204.821" y2="56.616" />
                            <line id="GA_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="44.476" y1="186.373" x2="44.476" y2="68.687" />
                            <line id="GC_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="185.576" y1="69.151" x2="64.354" y2="190.373" />
                            <line id="GT_line" fill="none" stroke="#000000" stroke-width="2" stroke-miterlimit="10"
                            x1="177.808" y1="219.05" x2="60.122" y2="219.05" />
                            <path d="M65.354,53.616c2.526,5.506,4.966,13.032,5.362,18.814l4.293-9.159l9.157-4.292

                        C78.384,58.584,70.859,56.144,65.354,53.616z" />
                            <path d="M34.476,186.373c2.107-5.68,5.703-12.727,9.512-17.095l-9.512,3.44l-9.51-3.44

                        C28.775,173.647,32.371,180.694,34.476,186.373z"
                            />
                            <path d="M44.476,56.616c2.107,5.68,5.703,12.727,9.512,17.095l-9.512-3.44l-9.51,3.44C38.775,69.343,42.371,62.296,44.476,56.616

                        z" />
                            <path d="M189.878,41.518c-5.68-2.107-12.727-5.703-17.095-9.512l3.44,9.512l-3.44,9.51

                        C177.152,47.219,184.199,43.623,189.878,41.518z"
                            />
                            <path d="M60.122,31.518c5.68-2.107,12.727-5.703,17.095-9.512l-3.44,9.512l3.44,9.51C72.848,37.219,65.801,33.623,60.122,31.518z

                        " />
                            <path d="M189.878,219.05c-5.68-2.107-12.727-5.703-17.095-9.512l3.44,9.512l-3.44,9.51

                        C177.152,224.751,184.199,221.155,189.878,219.05z"
                            />
                            <path d="M60.122,209.05c5.68-2.107,12.727-5.703,17.095-9.512l-3.44,9.512l3.44,9.51

                        C72.848,214.751,65.801,211.155,60.122,209.05z"
                            />
                            <path d="M204.821,186.373c2.107-5.68,5.703-12.727,9.512-17.095l-9.512,3.44l-9.51-3.44

                        C199.12,173.647,202.716,180.694,204.821,186.373z"
                            />
                            <path d="M214.821,56.616c2.107,5.68,5.703,12.727,9.512,17.095l-9.512-3.44l-9.51,3.44

                        C209.12,69.343,212.716,62.296,214.821,56.616z"
                            />
                            <path d="M187.111,189.373c-5.506-2.526-13.032-4.966-18.814-5.362l9.159-4.293l4.292-9.157

                        C182.143,176.343,184.584,183.868,187.111,189.373z"
                            />
                            <path d="M194.111,60.616c-5.506,2.526-13.032,4.966-18.814,5.362l9.159,4.293l4.292,9.157

                        C189.143,73.647,191.584,66.121,194.111,60.616z"
                            />
                            <path d="M58.354,182.373c2.526-5.506,4.966-13.032,5.362-18.814l4.293,9.159l9.157,4.292

                        C71.384,177.405,63.859,179.846,58.354,182.373z"
                            />
                        </svg>
                <p><a id="down" href-lang="image/svg+xml" href="#" target="_blank"><i class="fa fa-download" style="margin-left:20px;"></i>

                    Download</a>
                </p>
            </div>
            <!--section-->
        </div>
        <div id="mutanalyst_bias&#xA7;">
            <!--section-->
            <h2>Bias indicators</h2>
            <table id="biasTable" class="table table-striped">
                <thead>
                <tr>
                    <th>Indicator</th>
                    <th>Calculated</th>
                    <th>Estimated error</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th>Ts/Tv</th>
                    <td id="TsOverTv"></td>
                    <td id="TsOverTv_error"></td>
                </tr>
                <tr>
                    <th>AT&#x2192;GC/GC&#x2192;AT</th>
                    <td id="W2SOverS2W"></td>
                    <td id="W2SOverS2W_error"></td>
                </tr>
                <tr>
                    <th>A&#x2192;N, T&#x2192;N (%)</th>
                    <td id="W2N"></td>
                    <td id="W2N_error"></td>
                </tr>
                <tr>
                    <th>G&#x2192;N,C&#x2192;N (%)</th>
                    <td id="S2N"></td>
                    <td id="S2N_error"></td>
                </tr>
                <tr>
                    <th>AT&#x2192;GC (%)</th>
                    <td id="W2S"></td>
                    <td id="W2S_error"></td>
                </tr>
                <tr>
                    <th>GC&#x2192;AT (%)</th>
                    <td id="S2W"></td>
                    <td id="S2W_error"></td>
                </tr>
                <tr>
                    <th>Transitions (%) total</th>
                    <td id="&#x3A3;Ts"></td>
                    <td id="&#x3A3;Ts_error"></td>
                </tr>
                <tr>
                    <th>A&#x2192;G, T&#x2192;C (%)</th>
                    <td id="Ts1"></td>
                    <td id="Ts1_error"></td>
                </tr>
                <tr>
                    <th>G&#x2192;A, C&#x2192;T (%)</th>
                    <td id="Ts2"></td>
                    <td id="Ts2_error"></td>
                </tr>
                <tr>
                    <th>transversions (%) Total</th>
                    <td id="&#x3A3;Tv"></td>
                    <td id="&#x3A3;Tv_error"></td>
                </tr>
                <tr>
                    <th>A&#x2192;T, T&#x2192;A (%)</th>
                    <td id="TvW"></td>
                    <td id="TvW_error"></td>
                </tr>
                <tr>
                    <th>A&#x2192;C, T&#x2192;G (%)</th>
                    <td id="TvN1"></td>
                    <td id="TvN1_error"></td>
                </tr>
                <tr>
                    <th>G&#x2192;C, C&#x2192;G (%)</th>
                    <td id="TvS"></td>
                    <td id="TvS_error"></td>
                </tr>
                <tr>
                    <th>G&#x2192;T, C&#x2192;A (%)</th>
                    <td id="TvN2"></td>
                    <td id="TvN2_error"></td>
                </tr>
                </tbody>
            </table>
            <br/>
            <div id="biasChart" style="width: 80%; height:400px"></div>
            <br/>
        </div>
        <div id="mutanalyst_more&#xA7;">
            <h2>Pedel-AA results</h2>
            <p>For details about pedel-AA see <a href="/main/pedel" target="_blank">pedel-AA homepage</a>.</p>
            <div
                    id="pedelAA_result"></div>
        </div>
    </div>
</div>

