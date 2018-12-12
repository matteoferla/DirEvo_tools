<div class="card">
    <div class="card-header">
        <h1 class="card-title">QQCC</h1>
        <h4 class="card-subtitle mb-2 text-muted">Quick quality control calculator</h4>
    </div>
    <div class="card-body">
        <h2>QQC</h2>
        <h3>Description</h3>
        <p>Site saturation mutagenesis uses primers with a degenerate codon to scramble
            a single residue. Quick-quality control (QQC) is a way to determine extent
            of randomisation by sequencing the pool of plasmids, measuring the peaks
            and calculating the deviation from an ideal mix (<a href="http://www.nature.com/articles/srep10654"
                                                                target="_blank"><span data-toggle="tooltip" data-placement="top"
                                                                                      title="Acevedo-Rocha, CG, Reetz, MT, Nov, Y., (2015). Economical analysis of saturation mutagenesis experiments. Sci. Rep. 5:10654">Acevedo-Rocha <i>et al.</i>, 2015 <i
                    class="fas fa-external-link" aria-hidden="true"></i></span></a>).</p>
        <p>This tool performs automatically the peak measurements, Q-value calculations
            and expected amino acid proportions. In the case of sequences mutated with
            multiple codons a rough estimate of the contributions of each is obtained
            by optimining the function:</p>
        <div class="d-flex py-2">
            <div align="center" class="px-4">
                \(\min_{\boldsymbol{x} \in{\Bbb{N}}} \sum\limits_{i=1; j=1}^{4; 3} \left|{\sum\limits_{k=1}^{n} d_k x_{ijk} h_{ijk} - m_{ij}}\right|\)
            </div>
            <div>Where <i><b>x</b></i> is a scaling factor (4x3xN tensor) of the deviation
            from expected, <i><b>m</b></i>
            is the empirical proportions of bases (4x3
            matrix), <i><b>d</b></i> is the proportions of the primers (N dimension vector)
            and <i><b>h</b></i> is the ideal proportionl of bases in each primer (4x3xN
            tensor). </div>
        </div>
        <p>This approach therefore tries to balance the primers so to minimise
            the deviation from the ideal primer mix. The usage of the ideal primer
            mix is unfortunate, but is the only way to tackle the problem of deconvoluting
            the primers.</p>
        <h3>Input</h3>
        <div class="row">
            <div class="col-xl-3">
                <div class="btn-group btn-group-justified" role="group">
                    <label class="btn btn-warning btn-file" id="QQC_upload_group"> <i class="fas fa-upload" aria-hidden="true"></i> Upload
                        <input type="file"
                               id="QQC_upload" style="display: none;">
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
                </div>
                <br>
            </div>
            <div class="col-xl-4">
                <div class="input-group">
                    <div class="input-group-append" data-toggle="tooltip" title="Read direction"
                         data-placement="top">
                        <span class="input-group-text">Direction</span></div>
                    <input type="checkbox" class="switch"
                           id="QQC_direction" checked data-off-text="rv" data-on-text="fw" data-off-color="warning"
                           data-size="large">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xl-6 offset-lg-3">
                <div class="btn-group" role="group" aria-label="...">
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
        <div class="row hidden" id="QQC_result">
            <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
            <br>
        </div>
    </div>
</div>