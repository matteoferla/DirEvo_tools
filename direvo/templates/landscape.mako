<div class="card">
            <div class="card-header">
                <h1 class="card-title">Simulated Landscape</h1>
                <h4 class="card-subtitle mb-2 text-muted">Generate in silico a mutational landscape of a protein</h4>
            </div>
            <div class="card-body">
                <h2>Landscape</h2>
                <p>Determine the mutational landscape of a protein from a Rosetta pmut_scan output.</p>
                <p>The input files for this tool are the outputs from a pmut_scan run launched
                along with relevant constraints and params files thusly:
                <br>
                <pre><code>pmut_scan_parallel -ex1 -ex1aro -ex2 -extrachi_cutoff 1 -DDG_cutoff 999 -mute basic core -s your_structure.pdb &gt; scores.txt</code></pre>
                The <code>-DDG_cutoff 999</code> flag
                is high because we want all mutants. Actually, despite the memory, adding
                the <code>-output_mutant_structures true</code> flag is also rather handy
                for the analysis.
                <br>Provide one or more files (do not worry about header rows; the PDB numbering
                will be used. No negative positions):</p>
                <div class="row">
                    <div class="col-xl-5" id="Land_uploads">
                        <div class="input-group">
                            <label class="input-group-btn"> <span class="btn btn-primary">

                            Browse&#x2026; <input type="file" style="display: none;" id="land_upload" multiple>

                        </span>
                            </label>
                            <input type="text" class="form-control" readonly>
                        </div>
                    </div>
                    <div class="col-xl-6 offset-lg-1">
                        <div class="input-group"><div class="input-group-append" id="land_AA_order_label">
                            <span class="input-group-text">AA oder</span></div>
                            <input
                                    type="text" class="form-control" value="I V L F C M A G T S W Y P H N D E Q K R"
                                    aria-describedby="land_AA_order_label" id="land_AA_order">
                        </div>
                    </div>
                    <br>
                </div>
                <br>
                <div class="row" id="land_file_labels"></div>
                <br>
                <div class="row">
                    <div class="col-xl-6 offset-lg-3">
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-warning" id="land_clear"><i class="fas fa-eraser"
                                                                                             aria-hidden="true"></i>
                                Clear
                            </button>
                            <button type="button"
                                    class="btn btn-info" id="land_demo"><i class="fas fa-gift" aria-hidden="true"></i>
                                Demo
                            </button>
                            <button type="button"
                                    class="btn btn-success" id="land_calculate"><i class="fas fa-exchange"
                                                                                   aria-hidden="true"></i>
                                Calculate
                            </button>
                        </div>
                    </div>
                    <br>
                </div>
                <div class="" id="land_results"></div>
            </div>
        </div>