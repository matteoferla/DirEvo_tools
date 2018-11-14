<div class="card">
    <div class="card-header">
        <h1 class="card-title">Glue</h1>
        <h4 class="card-subtitle mb-2 text-muted">Library diversity and completeness (Acronymn means?)</h4>
    </div>
    <div class="card-body">
        <div id="glue_intro">
            <h3>Description</h3>
            <p>Given a library of <i>L</i> sequences, where each sequence is chosen at
                random from a set of <i>V</i> equiprobable variants, we wish to calculate
                the expected number of distinct (i.e. unique) sequences represented in
                the library. Alternatively, given a set of <i>V</i> equiprobable variants,
                we wish to calculate the library size <i>L</i> necessary to obtain a given
                percentage completeness, or to have a given probability of being 100% complete.
                (Typically assuming <i>V</i> &gt;&gt; 1, e.g. V &gt; 10.)</p>
            <h3>Example (<a data-toggle="collapse" href="#glue_example"><i class="fas fa-caret-down"
                                                                           aria-hidden="true"></i> show</a>)

            </h3>
            <div class="collapse" id="glue_example">
                <p>For the default values on the web server, there are a total of one million
                    possible variants. This is roughly equivalent to an oligonucleotide directed
                    randomization experiment involving four NNS codons (which gives <i>V</i> =
                    32<sup>4</sup> = 1048576).</p>
                <p>In the first panel, the experimenter has constructed a library of three
                    million transformants and wishes to estimate how many of the one million
                    possible variants are represented in the library. The answer is ~95.02%
                    or 950200 variants.</p>
                <p>In the second panel, s/he knows that there are one million possible variants,
                    and wants to know how big her/his library should be in order to ensure
                    that ~95% of them (i.e. 950000 variants) are represented. The answer is
                    that a library of ~2.996 million transformants is required.</p>
                <p>In the ideal situation her/his library would contain all one million variants.
                    In the third panel s/he calculates the library size required in order to
                    be 95% sure of complete representation. The answer is ~16.79 million transformants.</p>
            </div>
        </div>
        <h3>Calculations</h3>
        <div class="row" id="glue_form">
                <div class="col-xl-4">
                    <div class="input-group">
                        <div class="input-group-prepend" data-toggle="tooltip"
                             title="number of variants"
                             data-placement="top">
                            <span class="input-group-text">N variants</span></div>
                        <input type="number" min="0" class="form-control"
                               placeholder="1000000" id="glue_nvariants">
                    </div>
                    <br>
                </div>
                <div class="col-xl-5 offset-lg-2">
                    <div class="input-group">
                        <div class="input-group-prepend" data-toggle="tooltip"
                             title="Library size L"
                             data-placement="top">
                            <span class="input-group-text">Library size</span></div>
                        <input type="number" min="0" class="form-control"
                               placeholder="3000000" id="glue_library_size">
                        <div class="input-group-btn">

                            <button class="btn btn-success" type="button" id="glue_library_size_on"
                                    data-toggle="tooltip" title="known" data-placement="top">Use
                            </button>

                        </div>
                    </div>
                    <br>
                </div>
                <div class="col-xl-5">
                    <div class="input-group">
                        <div class="input-group-prepend" data-toggle="tooltip"
                             title="Completeness"
                             data-placement="top">
                            <span class="input-group-text">Completeness</span></div>
                        <input type="number" min="0" class="form-control"
                               placeholder="0.95" id="glue_completeness" disabled> <span
                            class="input-group-btn">

                                <button class="btn btn-secondary" type="button" id="glue_completeness_on"
                                        data-toggle="tooltip" title="known" data-placement="top">Use</button>

                              </span>
                    </div>
                    <br>
                </div>
                <div class="col-xl-5  offset-lg-1">
                    <div class="input-group">
                        <div class="input-group-prepend" data-toggle="tooltip"
                             title="prob complete"
                             data-placement="top">
                            <span class="input-group-text">prob 100% complete</span></div>
                        <input type="number" min="0"
                               class="form-control" placeholder="0.95" id="glue_prob_complete" disabled> <span
                            class="input-group-btn">

                                <button class="btn btn-secondary" type="button" id="glue_prob_complete_on"
                                        data-toggle="tooltip" title="known" data-placement="top">Use</button>

                              </span>
                    </div>
                    <br>
                </div>
            </poo>
        </div>
        <!-- row-->
        <div class="row">
            <div class="col-xl-6 offset-lg-3">
                <div class="btn-group" role="group" aria-label="...">
                    <button type="button" class="btn btn-warning" id="glue_clear"><i class="fas fa-eraser"
                                                                                     aria-hidden="true"></i>
                        Clear
                    </button>
                    <button type="button"
                            class="btn btn-info" id="glue_demo"><i class="fas fa-gift" aria-hidden="true"></i>
                        Demo
                    </button>
                    <button type="button"
                            class="btn btn-success" id="glue_calculate"><i class="fas fa-exchange"
                                                                           aria-hidden="true"></i>
                        Calculate
                    </button>
                </div>
            </div>
            <br>
        </div>
        <!-- The results -->
        <div class="row hidden" id="glue_result">
            <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went
                wrong
            </div>
            <br>
        </div>
    </div>
</div>
<!-- AA -->
<div class="card">
    <div class="card-header">
        <h1 class="card-title">Glue-IT &#x2014;amino acid level</h1>
    </div>
    <div class="card-body">
        <h2>GlueIT</h2>
        <h3>Description</h3>
        <p>Programme to find the expected amino acid completeness of a given library
            (not counting any variants with introduced stop codons) where the sequences
            in the library are chosen at random from a set of XYZ codon variants (where
            X,Y,Z are <a href="#" data-toggle="modal" data-target="#nucleotide_modal">standard

                nucleotide codes</a> chosen by the user, e.g. XYZ
            = NNS [N = A/C/G/T; S = C/G; 32 possible equiprobable codon variants; 20
            + 1 possible non-equiprobable amino acid/stop codon variants]). Up to six
            codons may be independently varied.
            <br>
            <br>To calculate the library size required in order to obtain a given completeness,
            or to have a given probability of being 100% complete, just try entering
            different library sizes and check the resulting library statistics until
            you home in on your required values.</p>
        <p>
        <div class="bs-callout bs-callout-warning">I&apos;ll need to make options for glue1AA</div>
        </p>
        <h3>Input</h3>
        <div class="row">
            <div class="col-xl-4  offset-lg-2">
                <div class="input-group">
                    <div class="input-group-prepend" data-toggle="tooltip"
                         title="Library size L"
                         data-placement="top">
                        <span class="input-group-text">Library size</span></div>
                    <input type="number" min="0" class="form-control"
                           placeholder="3000000" id="glueIT_library_size">
                </div>
                <br>
                <div class="input-group">
                    <div class="input-group-prepend" data-toggle="tooltip"
                         title="Number of codons"
                         data-placement="top">
                        <span class="input-group-text">Varied codons</span></div>
                    <input type="number" min="1" max="6"
                           class="form-control" placeholder="1" id="glueIT_num_codons">
                </div>
            </div>
            <div class="col-xl-4  offset-lg-1" id="glueIT_codon_mother">
                <div class="input-group" id="glueIT_overcodon1">
                    <div class="input-group-prepend"
                         data-toggle="tooltip"
                         title="The mutation used. The input is a string which can be simply four bases (e.g. &apos;NNK&apos;) or multiple codons separated by a space and optionally prefixed with a interger number denoting their ratios (e.g. &apos;12NDT 6VHA 1TGG 1ATG&apos;) or a special mix (e.g. &apos;Tang&apos;)."
                         data-placement="top">
                        <span class="input-group-text">Scheme</span></div>
                    <input type="text" class="form-control"
                           placeholder="NNK" id="glueIT_codon1"> <span class="input-group-btn">

                                <button class="btn btn-secondary" type="button" data-toggle="modal"
                                        data-target="#scheme_modal"><i class="fas fa-flask"
                                                                       aria-hidden="true"></i></button>

                            </span>
                </div>
                <br>
                <div class="input-group" id="glueIT_overcodon2">
                    <div class="input-group-addon"
                         data-toggle="tooltip"
                         title="The mutation used. The input is a string which can be simply four bases (e.g. &apos;NNK&apos;) or multiple codons separated by a space and optionally prefixed with a interger number denoting their ratios (e.g. &apos;12NDT 6VHA 1TGG 1ATG&apos;) or a special mix (e.g. &apos;Tang&apos;)."
                         data-placement="top">
                        <span class="input-group-text">Scheme</span></div>
                    <input type="text" class="form-control"
                           placeholder="NNK" id="glueIT_codon2"> <span class="input-group-btn">

                                <button class="btn btn-secondary" type="button" data-toggle="modal"
                                        data-target="#scheme_modal"><i class="fas fa-flask"
                                                                       aria-hidden="true"></i></button>

                            </span>
                </div>
                <br>
                <div class="input-group" id="glueIT_overcodon3">
                    <div class="input-group-prepend"
                         data-toggle="tooltip"
                         title="The mutation used. The input is a string which can be simply four bases (e.g. &apos;NNK&apos;) or multiple codons separated by a space and optionally prefixed with a interger number denoting their ratios (e.g. &apos;12NDT 6VHA 1TGG 1ATG&apos;) or a special mix (e.g. &apos;Tang&apos;)."
                         data-placement="top">
                        <span class="input-group-text">Scheme</span></div>
                    <input type="text" class="form-control"
                           placeholder="NNK" id="glueIT_codon3"> <span class="input-group-btn">

                                <button class="btn btn-secondary" type="button" data-toggle="modal"
                                        data-target="#scheme_modal"><i class="fas fa-flask"
                                                                       aria-hidden="true"></i></button>

                            </span>
                </div>
                <br>
                <div class="input-group" id="glueIT_overcodon4">
                    <div class="input-group-prepend"
                         data-toggle="tooltip"
                         title="The mutation used. The input is a string which can be simply four bases (e.g. &apos;NNK&apos;) or multiple codons separated by a space and optionally prefixed with a interger number denoting their ratios (e.g. &apos;12NDT 6VHA 1TGG 1ATG&apos;) or a special mix (e.g. &apos;Tang&apos;)."
                         data-placement="top">
                        <span class="input-group-text">Scheme</span></div>
                    <input type="text" class="form-control"
                           placeholder="NNK" id="glueIT_codon4"><span class="input-group-btn">

                                <button class="btn btn-secondary" type="button" data-toggle="modal"
                                        data-target="#scheme_modal"><i class="fas fa-flask"
                                                                       aria-hidden="true"></i></button>

                            </span>
                </div>
                <br>
                <div class="input-group" id="glueIT_overcodon5">
                    <div class="input-group-prepend"
                         data-toggle="tooltip"
                         title="The mutation used. The input is a string which can be simply four bases (e.g. &apos;NNK&apos;) or multiple codons separated by a space and optionally prefixed with a interger number denoting their ratios (e.g. &apos;12NDT 6VHA 1TGG 1ATG&apos;) or a special mix (e.g. &apos;Tang&apos;)."
                         data-placement="top">
                        <span class="input-group-text">Scheme</span></div>
                    <input type="text" class="form-control"
                           placeholder="NNK" id="glueIT_codon5"><span class="input-group-btn">

                                <button class="btn btn-secondary" type="button" data-toggle="modal"
                                        data-target="#scheme_modal"><i class="fas fa-flask"
                                                                       aria-hidden="true"></i></button>

                            </span>
                </div>
                <br>
                <div class="input-group" id="glueIT_overcodon6">
                    <div class="input-group-prepend"
                         data-toggle="tooltip"
                         title="The mutation used. The input is a string which can be simply four bases (e.g. &apos;NNK&apos;) or multiple codons separated by a space and optionally prefixed with a interger number denoting their ratios (e.g. &apos;12NDT 6VHA 1TGG 1ATG&apos;) or a special mix (e.g. &apos;Tang&apos;)."
                         data-placement="top">
                        <span class="input-group-text">Scheme</span></div>
                    <input type="text" class="form-control"
                           placeholder="NNK" id="glueIT_codon6">
                    <div class="input-group-btn">

                        <button class="btn btn-secondary" type="button" data-toggle="modal"
                                data-target="#scheme_modal"><i class="fas fa-flask"
                                                               aria-hidden="true"></i></button>

                    </div>
                </div>
                <br>
            </div>
        </div>
        <!-- row-->
        <div class="row">
            <div class="col-xl-6 offset-lg-3">
                <div class="btn-group" role="group" aria-label="...">
                    <button type="button" class="btn btn-warning" id="glueIT_clear"><i class="fas fa-eraser"
                                                                                       aria-hidden="true"></i>
                        Clear
                    </button>
                    <button type="button"
                            class="btn btn-info" id="glueIT_demo"><i class="fas fa-gift"
                                                                     aria-hidden="true"></i> Demo
                    </button>
                    <button type="button"
                            class="btn btn-success" id="glueIT_calculate"><i class="fas fa-exchange"
                                                                             aria-hidden="true"></i> Calculate
                    </button>
                </div>
            </div>
            <br>
        </div>
        <!-- The results -->
        <div class="row hidden" id="glueIT_result">
            <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went
                wrong
            </div>
            <br>
        </div>
    </div>
</div>
<!-- Modal -->
<div id="nucleotide_modal" class="modal fade" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&#xD7;</button>
                <h4 class="modal-title">Nucleotide codes</h4>
            </div>
            <div class="modal-body" style="max-height: calc(100vh - 200px); overflow-y: auto;">
                <p>Standard IUPAC code for ambiguous nucleotides.</p>
                <table class="table table-striped table-sm">
                    <tr align="left">
                        <th>Symbol</th>
                        <th>Meaning</th>
                    </tr>
                    <tr align="left">
                        <td>G</td>
                        <td>G</td>
                    </tr>
                    <tr align="left">
                        <td>A</td>
                        <td>A</td>
                    </tr>
                    <tr align="left">
                        <td>T</td>
                        <td>T</td>
                    </tr>
                    <tr align="left">
                        <td>C</td>
                        <td>C</td>
                    </tr>
                    <tr align="left">
                        <td>R</td>
                        <td>G or A</td>
                    </tr>
                    <tr align="left">
                        <td>Y</td>
                        <td>T or C</td>
                    </tr>
                    <tr align="left">
                        <td>M</td>
                        <td>A or C</td>
                    </tr>
                    <tr align="left">
                        <td>K</td>
                        <td>G or T</td>
                    </tr>
                    <tr align="left">
                        <td>S</td>
                        <td>G or C</td>
                    </tr>
                    <tr align="left">
                        <td>W</td>
                        <td>A or T</td>
                    </tr>
                    <tr align="left">
                        <td>H</td>
                        <td>A or C or T</td>
                    </tr>
                    <tr align="left">
                        <td>B</td>
                        <td>G or T or C</td>
                    </tr>
                    <tr align="left">
                        <td>V</td>
                        <td>G or C or A</td>
                    </tr>
                    <tr align="left">
                        <td>D</td>
                        <td>G or A or T</td>
                    </tr>
                    <tr align="left">
                        <td>N</td>
                        <td>G or A or T or C</td>
                    </tr>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>