<div class="card">
            <div class="card-header">
                 <h1 class="card-title">Generator</h1>
                <h4 class="card-subtitle mb-2 text-muted">Generate mutants in silico</h4>
            </div>
            <div>
                <div class="card-body">
                    <div id="silico_intro">
                        <p>You never know when you need a random sequence.</p>
                    </div>
                    <div class="bs-callout bs-callout-warning">Under construction. Half-abandonned actually as I figured something out.</div>
                    <div
                    id="silico_input">
                            <!--section-->
                             <h4>Sequence</h4>
                            <p>In frame nt sequence that is to be mutagenised.</p>
                        <div class="row">
                            <div class="col-xl-12">
                                <div class="input-group">
                                    <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                                    title="In frame sequence that was mutagenised.">
                                    <span class="input-group-text">Sequence</span>
                        </div>
                                    <textarea class="form-control custom-control"
                                    rows="5" style="resize:none" id="silico_sequence" name="silico_sequence"></textarea>
                                    <div class="input-group-append">
            <button class="btn btn-secondary" type="button" id="silico_sequence_retrieve" data-toggle="tooltip" data-placement="top" title="In frame sequence that was mutagenised."><i class="fas fa-history"></i><br> Retrieve previous</button>



          </div>
                                </div>
                                <br>
                            </div>
                            <br>
                        </div>
                        <%include file="bias_block.mako" args="tool='silico'"/>
                        <div class="row">
                            <div class="col-xl-4">
                                <div class="input-group">
                                    <div class="input-group-prepend" data-toggle="tooltip" title="Mean number of nucleotide substitutions per daughter sequence"
                                    data-placement="top">
                                        <span class="input-group-text">Mutation load</span></div>
                                    <input type="number" min="0" class="form-control"
                                    placeholder="4.5" id="silico_load">
                                </div>
                                <br>
                            </div>
                        </div>
                </div>
                <div class="row">
                    <div class="col-xl-6 offset-lg-3">
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-warning" id="silico_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
Clear</button>
                            <button type="button"
                            class="btn btn-info" id="silico_demo"><i class="fas fa-gift" aria-hidden="true"></i>
Demo</button>
                            <button type="button"
                            class="btn btn-success" id="silico_calculate"><i class="fas fa-exchange" aria-hidden="true"></i>
Calculate</button>
                        </div>
                    </div>
                    <br>
                </div>
                <div class="hidden" id="silico_result">
                    <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
                </div>
            </div>
        </div>
    </div>