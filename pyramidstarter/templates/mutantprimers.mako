<div class="card">
    <div class="card-header">
        <h1 class="card-title">Mutant Primers</h1>
        <h4 class="card-subtitle mb-2 text-muted">Primer design for semi-random mutagenesis</h4>
    </div>
    <div class="card-body">
        <h3>Description</h3>
        <p>This tool designs site-directed mutagenesis primer pairs in bulk based on specified amino acid mutations required. This includes options for degerate codons (see <a href="#codon_scheme_descriptor">below</a>).</p>
        <p>The primer pairs can be made to be fully overlapping like traditional QuikChange primers or a partially overlapping primer pair strategy (<a href="http://nar.oxfordjournals.org/content/43/2/e12.long"
                    target="_blank"><span data-toggle="tooltip" data-placement="top" title="Xia, Y., et al., (2015) New insights into the QuikChange process guide the use of

                    Phusion DNA polymerase for site-directed mutagenesis. Nucleic Acids Res

43(2):e12">Xia <i>et al.</i>, 2015 <i class="fas fa-external-link" aria-hidden="true"></i></span></a>).</p>
                    <p>As the traditional Quikchange protocol (Agilent)
                    works poorly for codon mutants, a better option is to have the primers with an user-defined overlap length
                    ( <i>e.g.</i> 22 bp) centred around the codon to mutate and will have a 3&#x2019;
                    overhand long enough to allow the region beyond the mutagenized codon to
                    anneal with the template above a given melting temperature, while taking
                    into account terminal GC clamp.</p>
        <p>If the overlap is in the 20–30 bases range, the primers can be also be used for Gibson assembly.</p>
        <h3>Input</h3>
        <div class="col-xl-12">
            <p>To make primers at the ends of the coding sequence, the neighbouring noncoding
                sequence are required. Two options are available:</p>
            <input type="radio"
                   name="MP_opt" value="split" checked>To give the upstream and downstream sequence separately.
            <br>
            <input type="radio" name="MP_opt" value="pos">To give a sequence with a start and end position. A variant of this is
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

                    <input type="checkbox" class="switch" id="MP_choose" checked data-off-text="2"

                           data-on-text="1" data-off-color="warning" data-size="large" checked>

                </div>

            </div>

            -->
        <!--</div>-->
        <div class="form-group">
            <div id="MP_upSequence_group" class="pb-4">
                <div class="input-group">
                    <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                         title="Sequence of the upstream region to prime off.">
                        <span class="input-group-text">Upstream<br>Sequence</span>
                    </div>
                    <textarea class="form-control custom-control"
                              rows="5" style="resize:none" id="MP_upSequence" name="upsequence"></textarea>
                </div>
            </div>

            <div id="MP_sequence_group"  class="pb-4">
                <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                                                title="Sequence with some of the upstream and downstream region to prime off if position mode active, else just the coding sequence.">
                    <span class="input-group-text">Sequence</span>
                        </div>
                    <textarea class="form-control custom-control"
                              rows="5" style="resize:none" id="MP_sequence" name="sequence"></textarea>
                </div>
            </div>

            <div id="MP_downSequence_group"  class="pb-4">
                <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                                                title="Sequence with downstream region to prime off.">
                    <span class="input-group-text">Downstream<br>Sequence</span>
                        </div>
                    <textarea class="form-control custom-control"
                              rows="5" style="resize:none" id="MP_downSequence" name="downsequence"></textarea>
                </div>
            </div>
            <div class="row pb-4">
                <div class="col-xl-4" id="MP_startBase_group">
                    <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip"
                                                    title="The value can be a number &#x2014;the first base of the given sequence will be 1&#x2014; or a short sequence starting with the first base of the target"
                                                    data-placement="top">
                        <span class="input-group-text">First base</span></div>
                        <input type="text" class="form-control"
                               id="MP_startBase" placeholder="number or string">
                    </div>
                </div>
                <div class="col-xl-4" id="MP_stopBase_group">
                    <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip"
                                                    title="The value can be a number &#x2014;the first base of the given sequence will be 1&#x2014; or a short sequence ending with the last base of the target"
                                                    data-placement="top">
                        <span class="input-group-text">Last base</span></div>
                        <input type="text" class="form-control"
                               id="MP_stopBase" placeholder="number or string">
                    </div>
                </div>
                <div class="col-xl-9" id="codon_scheme_descriptor">
                    <p>Add to the following textarea the list of mutations desired, such as A13P.
                        If more complex mutations, such as degenerate codons are to be use mark
                        the destination codon in square brakets after the AA residue and its number, <i>e.g.</i> A13[NNK].
                        For mutations to multiple amino acids (<i>e.g.</i> A13GP) please specify
                        the required codon for now. If considering degenerate codons and are not
                        sure which to pick, try using the helper tool.</p>
                </div>
                <div class="col-xl-3">
                    <button class="btn btn-info" type="button" data-toggle="modal" data-target="#scheme_modal"><i class="fas fa-flask" aria-hidden="true"></i>
                        helper tool
                    </button>
                    <br>
                    <br>
                </div>
            </div>
            <div class="row">
                <div class="col-xl-12  pb-4">
                    <div id="MP_mutationList_group">
                        <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                                                        title="Sequence with downstream region to prime off.">
                            <span class="input-group-text">Mutation<br/>List</span>

                        </div>
                            <textarea class="form-control custom-control"
                                      rows="5" style="resize:none" id="MP_mutationList" name="mutationList"></textarea>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xl-4  pb-4">
                    <div class="input-group"> <div class="input-group-prepend warning" data-toggle="tooltip" title="Enzyme system used, which affects the Tm"
                                                    data-placement="top">
                        <span class="input-group-text">Enzyme</span></div>
                        <select class="form-control" id="MP_enzyme">
                            <option value="1">no salts (+0&#xB0;C)</option>
                            <option value="2">50 mM Na (+2.8&#xB0;C)</option>
                            <option value="3">Taq buffer (+4.9&#xB0;C)</option>
                            <option value="4" selected="selected">Phusion buffer (+11.6&#xB0;C)</option>
                            <option value="5">Q5 buffer (+13.3&#xB0;C)</option>
                        </select>
                    </div>
                </div>
                <div class="col-xl-4  pb-4">
                    <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" title="Target melting temperature"
                                                    data-placement="top">
                        <span class="input-group-text">Target T<sub>m</sub></span></div>
                        <input type="text" class="form-control"
                               placeholder="55" id="MP_targetTemp"> <div class="input-group-append"><span class="input-group-text">&#xB0;C</span></div>
                    </div>
                </div>
                <div class="col-xl-4  pb-4">
                    <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" title="&#xB0;C tollerance for GC clamp"
                                                    data-placement="top"><span class="input-group-text">GC clamp bonus</span></div>
                        <input type="text" class="form-control"
                               placeholder="1" id="MP_GCclamp"> <div class="input-group-append"><span class="input-group-text">&#xB0;C</span></div>
                    </div>
                </div>
                <div class="col-xl-4  pb-4">
                    <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip"
                                                    title="Method used: full overlap (traditional) of primers or staggered overlap"
                                                    data-placement="top"><span class="input-group-text">Method</span></div>
                        <input type="checkbox" class="switch"
                               id="MP_method" checked data-off-text="Full" data-on-text="Stagger" data-switch-value="large"
                               data-off-color="warning">
                    </div>
                </div>
                <div class="col-xl-3 pb-4">
                    <div class="input-group" id="MP_overlap_group"> <div class="input-group-prepend" data-toggle="tooltip" title="The length of the overlap"
                                                                          data-placement="top"><span class="input-group-text">Overlap</span></div>
                        <input type="text" class="form-control"
                               placeholder="22" id="MP_overlap"> <div class="input-group-append"><span class="input-group-text">nt</span></div>
                    </div>
                </div>
                <div class="col-xl-5 pb-4">
                    <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" title="Total length range of the primers"
                                                    data-placement="top"><span class="input-group-text">Length</span></div>
                        <input id="MP_primerRange" type="text"
                               class="form-control span2 slider" value="" data-slider-min="18" data-slider-max="60"
                               data-slider-step="1" data-slider-value="[22,40]">
                    </div>
                </div>
            </div>
            <div class="row pb-4">
                <div class="col-xl-6 offset-lg-3">
                    <div class="btn-group" role="group" aria-label="...">
                        <button type="button" class="btn btn-warning" id="MP_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
                            Clear
                        </button>
                        <button type="button"
                                class="btn btn-info" id="MP_demo"><i class="fas fa-gift" aria-hidden="true"></i> Demo
                        </button>
                        <button type="button"
                                class="btn btn-success" id="MP_calculate"><i class="fas fa-exchange" aria-hidden="true"></i> Calculate
                        </button>
                    </div>
                </div>
            </div>

            <div class="hidden" id="MP_download">
                <h3>Downloads</h3>
                <div class="row pb-4">
                <div class="input-group">
                <div class="input-group-prepend">
                <span class="input-group-text">Dowload results as:</span>
                </div>
                    <div class="btn-group" role="group" aria-label="...">
                        <button type="button" class="btn btn-success" id="MP_table"><i class="fas fa-bars" aria-hidden="true"></i>
                            CSV
                        </button>
                        <button type="button"
                                class="btn btn-warning" id="MP_json"><i class="fas fa-cog" aria-hidden="true"></i>
                            JSON
                        </button>
                        <button type="button"
                                class="btn btn-info" id="MP_IDT_bulk"><i class="fas fa-shopping-basket" aria-hidden="true"></i> IDT bulk
                        </button>
                        <a
                                class="btn btn-info" id="MP_IDT_plate96" href="/deepscan_IDT96" download="deepscan_primers_IDT96.xlsx"><i
                                class="fas fa-shopping-cart" aria-hidden="true"></i> IDT 96-plate</a>
                        <a
                                class="btn btn-info" id="MP_IDT_plate384" href="/deepscan_IDT384" download="deepscan_primers_IDT384.xlsx"><i
                                class="fas fa-shopping-cart" aria-hidden="true"></i> IDT 384-plate</a>
                </div>


                <br/>
            </div></div>
                </div>
            <div class="hidden" id="MP_result">
                <div class="row pb-4">
                <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
                <br>
            </div>
                </div>
            <!-- <div class="modal fade" tabindex="-1" role="dialog">

              <div class="modal-dialog modal-lg" role="document">

                <div class="modal-content">

                  <div class="modal-header">

                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

                    <h4 class="modal-title">Results</h4>

                  </div>

                  <div class="modal-body" id="MP_result">

                    <p><span class="pycorpse"></span> Oh Snap. Something went wrong</p>

                  </div>

                  <div class="modal-footer">

                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>

                    <button type="button" class="btn btn-primary">Download</button>

                  </div>

                </div>

              </div>

            </div>--></div>
    </div>
</div>