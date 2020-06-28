<%page args="page, collapse_section"/>
<div class="card">
            <div class="card-header">
                 <h1 class="card-title">Rosetta Parameterisation</h1>
                <h4 class="card-subtitle mb-2 text-muted">Generation of Rosetta topology files from SMILES or Mol files</h4>
            </div>
            <div class="card-body">
                <form>
                    <div class="border border-secondary rounded p-3 mb-3">
                    <div class="row">
                        <div class="col-6 pb-3">
                            <div class="input-group">
                                <div class="input-group-prepend" data-toggle="tooltip" title="3-letter name of the ligand or AA"
                                data-placement="top">
                                    <span class="input-group-text">3-letter name</span></div>
                                <input type="text" class="form-control"
                                value="LIG" id="params_name">
                            </div>
                        </div>
                        <div class="col-6 pb-3">
                            <div class="input-group">
                                <div class="input-group-prepend" data-toggle="tooltip" title="Name of the ligand or AA for humans"
                                data-placement="top">
                                    <span class="input-group-text">Longer name</span></div>
                                <input type="text" class="form-control"
                                value="ligand" id="params_title">
                            </div>
                        </div>
                        <div class="col-6 col-md-3 pb-3">
                            <div class="border border-dark rounded bg-secondary text-muted p-2" title="Checked: use generic atom types, unchecked: use standard atom types (default). Generic atom types require a generic score function. If in doubt, you indubitably want the standard ones." data-toggle="tooltip">
                        <div class="custom-control custom-switch">
                          <input class="custom-control-input"  id="params_generic" type="checkbox" >
                          <label class="custom-control-label" for="params_generic">Generic atom types</label>
                        </div>
                    </div>
                    </div>
                    </div>
                    </div>
                    <div class="row">
                        <div class="col-12 pb-3">
                            <div class="input-group">
                                <div class="input-group-prepend" data-toggle="tooltip" title="SMILES"
                                data-placement="top">
                                    <span class="input-group-text">SMILES</span></div>
                                <input type="text" min="0" class="form-control"
                                placeholder="CC[OH]" id="params_smiles">
                            </div>
                        </div>
                            <p class="col-12 text-center">or</p>
                        <div class="col-12">
                            <div class="input-group mb-3">
                              <div class="input-group-prepend">
                                <span class="input-group-text">Mol/PDB/Mol2</span>
                              </div>
                              <div class="custom-file">
                                <input type="file" class="custom-file-input" id="params_file">
                                <label class="custom-file-label" for="params_file">Choose file</label>
                              </div>
                            </div>
                            <br>
                        </div>
                    </div>
                    <!-- row-->
                </form>
                <div class="row">
                    <div class="col-xl-6 offset-lg-3">
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-warning" id="params_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
Clear</button>
                            <button type="button"
                            class="btn btn-info" id="params_demo"><i class="fas fa-gift"></i> Demo</button>
                            <button type="button"
                            class="btn btn-success" id="params_calculate"><i class="fas fa-exchange" aria-hidden="true"></i>
Calculate</button>
                        </div>
                    </div>
                    <br>
                </div>
                <!-- The results -->
                <div class="row" id="params_result">
                    <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
                    <br>
                </div>
            </div>
        </div>