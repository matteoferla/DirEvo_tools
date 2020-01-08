<div class="card">
    <div class="card-header">
        <h1 class="card-title">QQCC</h1>
        <h4 class="card-subtitle mb-2 text-muted">Quick quality control calculator</h4>
    </div>
    <div class="card-body">
        <h3>Aim</h3>
        <p>Determine the diversity of a library randomised at a single codon from a single sequencing file with the quick quality control method.</p>
        <h3>Input</h3>
        <div class="row">
            <div class="col-xl-3">
                <div class="btn-group btn-group-justified" role="group">
                    <label class="btn btn-warning btn-file" id="QQC_upload_group"> <i class="fas fa-upload" aria-hidden="true"></i> Upload
                        <input type="file"
                               id="QQC_upload" style="display: none;">
                        <div class="invalid-feedback" id="error_QQC_upload">No abi file provided.</div>
                    </label>
                </div>
                <br>
            </div>
            <div class="col-xl-5">
                <div class="input-group">
                    <div class="input-group-append" data-toggle="tooltip" title="The upstream sequence of bases to help find where the mutation is."
                         data-placement="top">
                        <span class="input-group-text">Upstream seq.</span></div>
                    <input type="text" class="form-control"
                           placeholder="NNNNNNNNNN" id="QQC_preceding">
                    <div class="invalid-feedback" id="error_QQC_preceding">Invalid sequence provided.</div>
                </div>
                <br>
            </div>
            <div class="col-xl-4">
                <div class="input-group">
                    <div class="input-group-append" data-toggle="tooltip"
                         title="The mutation used. The input is a string which can be simply four bases (e.g. &apos;NNK&apos;) or multiple codons separated by a space and optionally prefixed with a interger number denoting their ratios (e.g. &apos;12NDT 6VHA 1TGG 1ATG&apos;) or a special mix (e.g. &apos;Tang&apos;)."
                         data-placement="top">
                        <span class="input-group-text">Scheme</span></div>
                    <input type="text" class="form-control"
                           placeholder="NNK" id="QQC_mutation"> <span class="input-group-btn">

                                <button class="btn btn-secondary" type="button" data-toggle="modal" data-target="#scheme_modal"><i class="fas fa-flask"
                                                                                                                                   aria-hidden="true"></i></button>

                            </span>
                    <div class="invalid-feedback" id="error_QQC_mutation">Invalid mutation provided.</div>
                </div>
                <br>
            </div>
            <div class="col-xl-4">
                <div class="input-group">
                    <div class="input-group-append" data-toggle="tooltip" title="Read direction"
                         data-placement="top">
                        <span class="input-group-text">Direction</span></div>
                    <input type="checkbox" class="switch"
                           id="QQC_direction" data-off-text="rv" data-on-text="fw" data-off-color="warning"
                           data-size="large" checked="checked">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xl-6 offset-lg-3">
                <div class="btn-group my-4" role="group" aria-label="...">
                    <button type="button" class="btn btn-warning" id="QQC_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
                        Clear
                    </button>
                    <button type="button"
                            class="btn btn-info" id="QQC_demo"><i class="fas fa-files-o" aria-hidden="true"></i> Demo
                    </button>
                    <button type="button"
                            class="btn btn-success" id="QQC_calculate"><i class="fas fa-exchange" aria-hidden="true"></i>
                        Calculate
                    </button>
                </div>
            </div>
            <br>
        </div>
        <div class="hidden" id="QQC_result">
            <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
            <br>
        </div>
    </div>
</div>