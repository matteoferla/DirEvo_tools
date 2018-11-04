<div class="card">
            <div class="card-header">
                <h1 class="card-title">Simulated Landscape</h1>
            </div>
            <div class="card-body">
                <h2>Landscape</h2>
                <h3>Description</h3>
                By using the Rosetta application pmut_scan one can obtain a mutational
                landscape of the &#x2206;G for every possible mutation at each position.
                <br>In the case of enzymes, by repeating the same operation on the enzyme
                without substrate docked, with substrate docked, with transition state
                and with product one can find which residues are increase the reactivity.
                <br>This tool gets the output of different point-mutation scans, aligns them
                into a single table and plots them. A few cases will fail entirely, hence
                why the datasets are aligned by the tool.
                <br>As the energies are relative to wild type, it does not matter if in the
                unbound state the ligand is not in the system or that in the transition
                state has a strong constraint.
                <br>The quality of the results depends on the model, so it is important the
                unconstrained scores form a typical Gibbs free energy curve, with negative
                &#x2206;G<sub>rxn</sub> and positive &#x2206;G<sup>&#x2021;</sup>.
                <br>Due to the fact that preparing the models cannot be automated without
                affecting the results, these are not done here.
                <br>If unfamiliar with Rosetta, feel free to contact Matteo Ferla (author),
                who might be able to parameterise your ligands, prepare your models and
                run them for you.
                <br>
                <div class="alert alert-warning" role="alert"><b>[Citation needed]</b>Note that you have to cite the
                    relevant David
                    Baker paper in addition to us...
                </div>
                <h3>Input</h3>
                The input files for this tool are the outputs from a pmut_scan run launched
                along with relevant constraints and params files thusly:
                <br>
                <pre><code>pmut_scan_parallel -ex1 -ex1aro -ex2 -extrachi_cutoff 1 -DDG_cutoff 999 -mute basic core -s your_structure.pdb &gt; scores.txt</code></pre>
                The <code>-DDG_cutoff 999</code> flag
                is high because we want all mutants. Actually, despite the memory, adding
                the <code>-output_mutant_structures true</code> flag is also rather handy
                for the analysis.
                <br>Provide one or more files (do not worry about header rows; the PDB numbering
                will be used. No negative positions):
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
                        <div class="input-group"><span class="input-group-addon" id="land_AA_order_label">AA oder</span>
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
                <div class="row" id="land_results"></div>
            </div>
        </div>