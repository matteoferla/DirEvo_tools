<div class="card">
    <div class="card-header">
        <h1 class="card-title">Glue</h1>
        <h4 class="card-subtitle mb-2 text-muted">Library diversity and completeness (Acronymn means?)</h4>
    </div>
    <div class="card-body">
        <p>Determine how well a library of randomised sequences covers its potential sequence complexity.</p>
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
        <p>Calculate the completeness of a library mutated at 1–6 codons.</p>
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
        <%include file="calculate_btns.mako" args="tool='glueIT'"/>
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