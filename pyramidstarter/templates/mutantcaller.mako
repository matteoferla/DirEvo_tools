<%page args="page"/>
<div class="card">
                <div class="card-header">
                     <h1 class="card-title">MutantCaller</h1>
                    <h4 class="card-subtitle mb-2 text-muted">Quickly identify mutations</h4>
                </div>
                <div class="card-body">
                     <h3>Description</h3>
                    <div class="bs-callout bs-callout-warning">Add description!</div>
                    <p></p>
                     <h3>Input</h3>
                    <div id="MC_input">
                        <div class="row">
                            <div class="col-xl-12">
                                <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                                    title="In frame sequence that was mutagenised.">
                                    <span class="input-group-text">Sequence</span>

                        </div>
                                    <textarea class="form-control custom-control"
                                    rows="5" style="resize:none" id="MC_sequence" name="MC_sequence"></textarea>
                                    <button class="btn btn-secondary" type="button" id="MC_sequence_retrieve" data-toggle="tooltip" data-placement="top" title="In frame sequence that was mutagenised."><i class="fas fa-history"></i><br/>Retrieve previous</button>
                                </div>
                                <br>
                            </div>
                            <div class="col-xl-3">
                                <div class="btn-group btn-group-justified" role="group">
                                    <label class="btn btn-warning btn-file" id="MC_upload_group"> <i class="fas fa-upload" aria-hidden="true"></i> Upload Trace
                                        <input type="file"
                                        id="MC_upload" style="display: none;">
                                    </label>
                                </div>
                                <br>
                            </div>
                            <div class="col-xl-4">
                                <div class="input-group">
                                    <div class="input-group-prepend" data-toggle="tooltip" title="Read direction"
                                    data-placement="top">
                                        <span class="input-group-text">Direction </span></div>
                                    <input type="checkbox" class="switch"
                                    id="MC_direction" checked data-off-text="rv" data-on-text="fw" data-off-color="warning"
                                    data-size="large">
                                </div>
                                <br>
                            </div>
                            <div class="col-xl-3">
                                <div class="input-group">
                                    <div class="input-group-prepend" data-toggle="tooltip" title="N sigma background cutoff for minor peaks"
                                    data-placement="top">
                                        <span class="input-group-text">Noise sigma</span></div>
                                    <input type="number" min="0" class="form-control"
                                    placeholder="5" id="MC_sigma">
                                </div>
                                <br>
                            </div>
                            <div class="col-xl-3">
                                <div class="input-group">
                                    <div class="input-group-prepend" data-toggle="tooltip" title="N sigma background cutoff for minor peaks"
                                    data-placement="top">
                                        <span class="input-group-text">PDB code (opt.)</span></div>
                                    <input type="text" class="form-control"
                                    placeholder="XXXX" id="MC_pdb_code">
                                </div>
                                <br>
                            </div>
                            <div class="col-xl-3">
                                <div class="btn-group btn-group-justified" role="group">
                                    <label class="btn btn-warning btn-file" id="MC_upload_pdb_group"> <i class="fas fa-upload" aria-hidden="true"></i> Upload PDB
                                        <input type="file"
                                        id="MC_upload_pdb" style="display: none;">
                                    </label>
                                </div>
                                <br>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xl-6 offset-lg-3">
                                <div class="btn-group" role="group" aria-label="...">
                                    <button type="button" class="btn btn-warning" id="MC_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
Clear</button>
                                    <button type="button"
                                    class="btn btn-info" id="MC_demo"><i class="fas fa-gift" aria-hidden="true"></i>
Demo</button>
                                    <button type="button"
                                    class="btn btn-success" id="MC_calculate"><i class="fas fa-exchange" aria-hidden="true"></i>
Calculate</button>
                                </div>
                            </div>
                            <br>
                        </div>
                    </div>
                    <div class="row hidden" id="MC_result">
                        <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
                        <br>
                    </div>
                </div>
            </div>