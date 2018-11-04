<div class="card">
            <div class="card-header">
                 <h1 class="card-title">Primer design for deep mutational scanning</h1>
            </div>
            <div class="card-body">
                 <h2>Deepscan</h2>
                 <h3>Description</h3>
                <p>Deepscan generates a list of partially overlapping QuikChange-based primers
                    aimed at constructing mutability landscapes using PCR. It iterates across
                    a DNA sequence, codon by codon and generates a primer pair that employs
                    the partially overlapping primer pair strategy (<a href="http://nar.oxfordjournals.org/content/43/2/e12.long"
                    target="_blank"><span data-toggle="tooltip" data-placement="top" title="Xia, Y., et al., (2015) New insights into the QuikChange process guide the use of

                    Phusion DNA polymerase for site-directed mutagenesis. Nucleic Acids Res

43(2):e12">Xia <i>et al.</i>, 2015 <i class="fas fa-external-link" aria-hidden="true"></i></span></a>).
                    Namely, the primers in a pair will have an user-defined overlap length
                    ( <i>e.g.</i> 22 bp) centred around the codon to mutate and will have a 3&#x2019;
                    overhand long enough to allow the region beyond the mutagenized codon to
                    anneal with the template above a given melting temperature, while taking
                    into account terminal GC clamp. The traditional Quikchange protocol (Agilent)
                    works poorly for codon mutants.
                    <br>The serverside calculations use a Python 3 script obtainable from: <a target="_blank"
                    href="https://github.com/matteoferla/mutational_scanning">

                        mutational scanning <i class="fas fa-github" aria-hidden="true"></i></a>).</p>
                 <h3>Input</h3>
                <div class="col-xl-12">
                    <p>To make primers at the ends of the coding sequence, the neighbouring noncoding
                        sequence are required. Two options are available:</p>
                    <input type="radio"
                    name="DS_opt" value="split" checked>To give the upstream and downstream sequence separately.
                    <br>
                    <input type="radio" name="DS_opt" value="pos">To give a sequence with a start and end position. A variant of this is
                    to give the starting/end position as a short sequence to match as opposed
                    to a number.
                    <br>
                    <br>
                </div>
                <!-- <div class="col-xl-5">

                        <div class="input-group">

                    <span class="input-group-addon" data-toggle="tooltip"

                          title="Choose input method."

                          data-placement="top">Choose given:</span>

                            <input type="checkbox" class="switch" id="DS_choose" checked data-off-text="2"

                                   data-on-text="1" data-off-color="warning" data-size="large" checked>

                        </div>

                    </div>

                    -->
                <!--</div>-->
                <div class="form-group">
                    <div id="DS_upSequence_group">
                        <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" data-placement="top"
                            title="Sequence of the upstream region to prime off.">Upstream<br>Sequence

                        </span>
                            <textarea class="form-control custom-control"
                            rows="5" style="resize:none" id="DS_upSequence" name="upsequence"></textarea>
                        </div>
                        <br>
                    </div>
                    <div id="DS_sequence_group">
                        <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" data-placement="top"
                            title="Sequence with some of the upstream and downstream region to prime off if position mode active, else just the coding sequence.">Sequence

                        </span>
                            <textarea class="form-control custom-control"
                            rows="5" style="resize:none" id="DS_sequence" name="sequence"></textarea>
                        </div>
                        <br>
                    </div>
                    <div id="DS_downSequence_group">
                        <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" data-placement="top"
                            title="Sequence with downstream region to prime off.">Downstream<br>Sequence

                        </span>
                            <textarea class="form-control custom-control"
                            rows="5" style="resize:none" id="DS_downSequence" name="downsequence"></textarea>
                        </div>
                        <br>
                    </div>&#xA0;
                    <div class="row">
                        <div class="col-xl-4" id="DS_startBase_group">
                            <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="The value can be a number &#x2014;the first base of the given sequence will be 1&#x2014; or a short sequence starting with the first base of the target"
                                data-placement="top">First base</span>
                                <input type="text" class="form-control"
                                id="DS_startBase" placeholder="number or string">
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-4" id="DS_stopBase_group">
                            <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="The value can be a number &#x2014;the first base of the given sequence will be 1&#x2014; or a short sequence ending with the last base of the target"
                                data-placement="top"> Last base</span>
                                <input type="text" class="form-control"
                                id="DS_stopBase" placeholder="number or string">
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-4">
                            <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="Codon to insert in place of each codon in the target region"
                                data-placement="top">Mutation</span>
                                <input type="text" class="form-control"
                                placeholder="NNK" id="DS_mutationCodon"> <span class="input-group-btn">

                                <button class="btn btn-info" type="button" data-toggle="modal" data-target="#scheme_modal"><i class="fas fa-flask" aria-hidden="true"></i></button>

                            </span>
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-4">
                            <div class="input-group"> <span class="input-group-addon warning" data-toggle="tooltip" title="Enzyme system used, which affects the Tm"
                                data-placement="top">Enzyme</span>
                                <select class="form-control" id="DS_enzyme">
                                    <option value="1">no salts (+0&#xB0;C)</option>
                                    <option value="2">50 mM Na (+2.8&#xB0;C)</option>
                                    <option value="3">Taq buffer (+4.9&#xB0;C)</option>
                                    <option value="4" selected="selected">Phusion buffer (+11.6&#xB0;C)</option>
                                    <option value="5">Q5 buffer (+13.3&#xB0;C)</option>
                                </select>
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-4">
                            <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="Target melting temperature"
                                data-placement="top">Target T<sub>m</sub></span>
                                <input type="text" class="form-control"
                                placeholder="55" id="DS_targetTemp"> <span class="input-group-addon">&#xB0;C</span>
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-4">
                            <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="&#xB0;C tollerance for GC clamp"
                                data-placement="top">GC clamp bonus</span>
                                <input type="text" class="form-control"
                                placeholder="1" id="DS_GCclamp"> <span class="input-group-addon">&#xB0;C</span>
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-4">
                            <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="Method used: full overlap (traditional) of primers or staggered overlap"
                                data-placement="top">Method</span>
                                <input type="checkbox" class="switch"
                                id="DS_method" checked data-off-text="Full" data-on-text="Stagger" data-switch-value="large"
                                data-off-color="warning">
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-4">
                            <div class="input-group" id="DS_overlap_group"> <span class="input-group-addon" data-toggle="tooltip" title="The length of the overlap"
                                data-placement="top">Overlap</span>
                                <input type="text" class="form-control"
                                placeholder="22" id="DS_overlap"> <span class="input-group-addon">nt</span>
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-4">
                            <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="Total length range of the primers"
                                data-placement="top">Length</span>
                                <input id="DS_primerRange" type="text"
                                class="form-control span2 slider" value="" data-slider-min="18" data-slider-max="60"
                                data-slider-step="1" data-slider-value="[22,40]">
                            </div>
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xl-6 offset-lg-3">
                            <div class="btn-group" role="group" aria-label="...">
Clear</button>
                                <button type="button"
                                class="btn btn-info" id="DS_demo"><i class="fas fa-gift" aria-hidden="true"></i> Demo</button>
                                <button type="button"
                                class="btn btn-success" id="DS_calculate"><i class="fas fa-exchange" aria-hidden="true"></i> Calculate</button>
                            </div>
                        </div>
                        <br>
                    </div>
                    <div class="row hidden" id="DS_download">
                         <h3>Downloads</h3>
                        <br>
                        <div class="col-xl-3">Dowload results as:</div>
                        <div class="col-xl-9">
                            <div class="btn-group" role="group" aria-label="...">
                                <button type="button" class="btn btn-success" id="DS_table"><i class="fas fa-bars" aria-hidden="true"></i>
CSV</button>
                                <button type="button"
                                class="btn btn-warning" id="DS_json"><i class="fas fa-cog" aria-hidden="true"></i>
JSON</button>
                                <button type="button"
                                class="btn btn-info" id="DS_IDT_bulk"><i class="fas fa-shopping-basket" aria-hidden="true"></i> IDT bulk</button>
                                <a
                                class="btn btn-info" id="DS_IDT_plate96" href="/deepscan_IDT96" download="deepscan_primers_IDT96.xlsx"><i class="fas fa-shopping-cart" aria-hidden="true"></i> IDT 96-plate</a>
                                    <a
                                    class="btn btn-info" id="DS_IDT_plate384" href="/deepscan_IDT384" download="deepscan_primers_IDT384.xlsx"><i class="fas fa-shopping-cart" aria-hidden="true"></i> IDT 384-plate</a>
                            </div>
                        </div>
                        <br>
                    </div>
                    <div class="row hidden" id="DS_result">
                        <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
                        <br>
                    </div>
                    <br></div>
            </div>
        </div>