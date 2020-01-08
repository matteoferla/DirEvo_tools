<div class="card">
            <div class="card-header">
                 <h1 class="card-title">xxxx</h1>
            </div>
            <div class="card-body">
                 <h3>Input</h3>
                <div class="row">
                    <div class="col-xl-3">
                        <div class="btn-group btn-group-justified" role="group">
                            <label class="btn btn-warning btn-file" id="facs_upload_group"> <i class="fas fa-upload" aria-hidden="true"></i> Upload
                                <input type="file"
                                id="facs_upload" style="display: none;">
                            </label>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="File name of output"
                            data-placement="top">Output filename</span>
                            <input type="text" class="form-control"
                            value="munged_facs_file.csv" id="facs_outfile">
                        </div>
                        <br>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xl-6 offset-lg-3">
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-warning" id="facs_clear"><i class="fas fa-eraser" aria-hidden="true"></i> Clear</button>
                            <button type="button"
                            class="btn btn-info" id="facs_demo"><i class="fas fa-gift" aria-hidden="true"></i> Demo</button>
                            <button type="button"
                            class="btn btn-success" id="facs_calculate"><i class="fas fa-exchange" aria-hidden="true"></i> Calculate</button>
                        </div>
                    </div>
                    <br>
                </div>
                <div class="row hidden" id="facs_result">
                    <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
                    <br>
                </div>
            </div>
        </div>