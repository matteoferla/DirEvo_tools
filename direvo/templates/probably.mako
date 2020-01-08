<div class="card">
            <div class="card-header">
                 <h1 class="card-title">Chances of a mutation

                    </h1>
            </div>
            <div>
                <div class="card-body">
                    <div id="probably_input">
                         <h3>Input</h3>
                        <h4>Sequence</h4>
                            <p>In frame sequence that was mutagenised. Note that all symbols that aren&apos;t
                                uppecase ATUGC, will be discarded along with a Fasta header (<i>e.g.</i> &apos;&gt;T.
                                maritima Cystathionine &#x3B2;-lyase&apos;), therefore for masked sequences
                                use lowercase.</p>
                        <div class="row">
                            <!--section-->

                            <div class="col-xl-12">
                                <div class="input-group"> <span class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                                    title="In frame sequence that was mutagenised.">
                                    <span class="input-group-text">Sequence</span>


                        </span>
                                    <textarea class="form-control custom-control"
                                    rows="5" style="resize:none" id="probably_sequence" name="probably_sequence"></textarea> <span class="input-group-append">
            <button class="btn btn-secondary" type="button" id="probably_sequence_retrieve" data-toggle="tooltip" data-placement="top" title="In frame sequence that was mutagenised."><i class="fas fa-history"></i> Retrieve previous</button>

          </span>
                                </div>
                                <br>
                            </div>
                            <br>
                        </div>
                        <div class="row">
                            <div class="col-xl-3">
                                <div class="input-group"> <span class="input-group-prepend" data-toggle="tooltip" title="Library size L"
                                                                data-placement="top"><span class="input-group-text">Library size</span></span>
                                    <input type="number" min="0" class="form-control"
                                    placeholder="10000000" id="probably_size">
                                </div>
                                <br>
                            </div>
                        </div>
                         <h4>Nucleotide mutation matrix</h4>
(non-negative numbers. Overall scaling is unimportant as this is taken
                        from the &apos;mean number of substitutions per daughter sequence&apos;
                        parameter.)
                        <%include file="bias_block.mako" args="tool='probably'"/>
                        <div class="row mb-4">
                            <div class="col-xl-4">
                                <div class="input-group"><span class="input-group-append"><span class="input-group-text">Values are</span></span>
                                    <input type="checkbox" class="switch" id="probably_normal" data-off-text="Unnormalised"
                                    data-on-text="Normalised" data-off-color="warning">
                                </div>
                            </div>
                            <div class="col-xl-4">
                                <div class="input-group"> <span class="input-group-prepend" data-toggle="tooltip" title="Mean number of nucleotide substitutions per daughter sequence"
                                    data-placement="top"><span class="input-group-text">Mutation load</span></span>
                                    <input type="number" min="0" class="form-control"
                                    placeholder="4.5" id="probably_load">
                                </div>
                            </div>
                            <div class="col-xl-4">
                                <div class="input-group"> <span class="input-group-prepend" data-toggle="tooltip" title="List of mutations in a variant"
                                    data-placement="top"><span class="input-group-text">Mutations</span> </span>
                                    <input type="text" class="form-control"
                                    placeholder="Y66W" id="probably_list">
                                </div>
                            </div>

                        </div>
                        <!--button row-->
                        <div class="row">
                                <div class="col-lg-6 offset-lg-4">
                                    <div class="btn-group" role="group" aria-label="...">
                                        <button type="button" class="btn btn-warning" id="probably_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
Clear</button>
                                        <button type="button"
                                        class="btn btn-info" id="probably_demo"><i class="fas fa-gift" aria-hidden="true"></i>
Demo</button>
                                        <button type="button"
                                        class="btn btn-success" id="probably_calculate"><i class="fas fa-exchange" aria-hidden="true"></i>
Calculate</button>
                                    </div>
                                </div>
                                <br>
                            </div>
                        <div class="hidden" id="probably_result">
                            <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
                            <br>
                        </div>
                    </div>
                </div>
            </div>
        </div>