<%page args="page, collapse_section"/>
<div class="card">
            <div class="card-header">
                 <h1 class="card-title">DRIVeR</h1>
                <h4 class="card-subtitle mb-2 text-muted">Diversity Resulting from In Vitro Recombination</h4>
            </div>
            <div class="card-body">
                <form>
                    <div class="row">
                        <div class="col-xl-3">
                            <div class="input-group">
                                <div class="input-group-prepend" data-toggle="tooltip" title="Library size"
                                data-placement="top">
                                    <span class="input-group-text">Library size</span></div>
                                <input type="number" min="0" class="form-control"
                                placeholder="1600" id="driver_library_size">
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-3">
                            <div class="input-group">
                                <div class="input-group-prepend" data-toggle="tooltip" title="Sequence length in nucleotides (or amino acids) N"
                                data-placement="top">
                                    <span class="input-group-text">Length</span></div>
                                <input type="number" min="1" class="form-control"
                                       placeholder="1425" id="driver_length"> <div class="input-group-append"><span class="input-group-text">nt</span></div>
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-3">
                            <div class="input-group">
                                <div class="input-group-prepend" data-toggle="tooltip" title="Mean number of crossovers per sequence m"
                                data-placement="top">
                                    <span class="input-group-text">Mean</span></div>
                                <input type="number" min="0" class="form-control"
                                placeholder="2" id="driver_mean">
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-6">
                            <div class="input-group">
                                <div class="input-group-prepend" data-toggle="tooltip" title="Specify whether the crossovers are the observed ones or all crossovers."
                                data-placement="top">
                                    <span class="input-group-text">Crossovers counting</span></div>
                                <input type="checkbox" class="switch"
                                id="driver_xtrue" checked data-off-text="Observable" data-on-text="All"
                                data-off-color="warning" data-size="large">
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-6">
                            <div class="input-group">
                                <div class="input-group-prepend" data-toggle="tooltip" title="Two alternative input ways"
                                data-placement="top">
                                    <span class="input-group-text">xover input</span></div>
                                <input type="checkbox" class="switch"
                                id="driver_mode" checked data-off-text="positions" data-on-text="sequences"
                                data-off-color="warning" data-size="large">
                            </div>
                            <br>
                        </div>
                    </div>
                    <div class="row" id="driver_by_seq">
                        <div class="col-xl-6">
                            <div class="input-group">
                                <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                                title="In frame sequence that was mutagenised.">
                                    <span class="input-group-text">Sequence</span>

                        </div>
                                <textarea class="form-control custom-control"
                                rows="5" style="resize:none" id="driver_sequenceA" name="driver_sequenceA"
                                placeholder="ATGCAAACGCTCAGCATCCAGCACGGTACCCTCGTCACGATGGATCAGTACCGCAGAGTCCTTGGGGATAGCTGGGTTCACGTGCAGGATGGACGGATCGTCGCGCTCGGAGTGCACGCCGAGTCGGTGCCTCCGCCAGCGGATCGGGTGATCGATGCACGCGGCAAGGTCGTGTTACCCGGTTTCATCAATGCCCACACCCATGTGAACCAGATCCTCCTGCGCGGAGGGCCCTCGCACGGGCGTCAATTCTATGACTGGCTGTTCAACGTTGTGTATCCGGGACAAAAGGCGATGAGACCGGAGGACGTAGCGGTGGCGGTGAGGTTGTATTGTGCGGAAGCTGTGCGCAGCGGGATTACGACGATCAACGAAAACGCCGATTCGGCCATCTACCCAGGCAACATCGAGGCCGCGATGGCGGTCTATGGTGAGGTGGGTGTGAGGGTCGTCTACGCCCGCATGTTCTTTGATCGGATGGACGGGCGCATTCAAGGGTATGTGGACGCCTTGAAGGCTCGCTCTCCCCAAGTCGAACTGTGCTCGATCATGGAGGAAACGGCTGTGGCCAAAGATCGGATCACAGCCCTGTCAGATCAGTATCATGGCACGGCAGGAGGTCGTATATCAGTTTGGCCCGCTCCTGCCACTACCACGGCGGTGACAGTTGAAGGAATGCGATGGGCACAAGCCTTCGCCCGTGATCGGGCGGTAATGTGGACGCTTCACATGGCGGAGAGCGATCATGATGAGCGGATTCATGGGATGAGTCCCGCCGAGTACATGGAGTGTTACGGACTCTTGGATGAGCGTCTGCAGGTCGCGCATTGCGTGTACTTTGACCGGAAGGATGTTCGGCTGCTGCACCGCCACAATGTGAAGGTCGCGTCGCAGGTTGTGAGCAATGCCTACCTCGGCTCAGGGGTGGCCCCCGTGCCAGAGATGGTGGAGCGCGGCATGGCCGTGGGCATTGGAACAGATAACGGGAATAGTAATGACTCCGTAAACATGATCGGAGACATGAAGTTTATGGCCCATATTCACCGCGCGGTGCATCGGGATGCGGACGTGCTGACCCCAGAGAAGATTCTTGAAATGGCGACGATCGATGGGGCGCGTTCGTTGGGAATGGACCACGAGATTGGTTCCATCGAAACCGGCAAGCGCGCGGACCTTATCCTGCTTGACCTGCGTCACCCTCAGACGACTCCTCACCATCATTTGGCGGCCACGATCGTGTTTCAGGCTTACGGCAATGAGGTGGACACTGTCCTGATTGACGGAAACGTTGTGATGGAGAACCGCCGCTTGAGCTTTCTTCCCCCTGAACGTGAGTTGGCGTTCCTTGAGGAAGCGCAGAGCCGCGCCACAGCTATTTTGCAGCGGGCGAACATGGTGGCTAACCCAGCTTGGCGCAGCCTCTAG"></textarea>
                            </div>
                            <br>
                        </div>
                        <div class="col-xl-6">
                            <div class="input-group">
                                <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                                title="In frame sequence that was mutagenised.">
                                    <span class="input-group-text">Sequence</span>

                        </div>
                                <textarea class="form-control custom-control"
                                rows="5" style="resize:none" id="driver_sequenceB" name="driver_sequenceB"
                                placeholder="ATGCAAACGCTCAGCATCCAGCACGGTACCCTCGTCACGATGGATCAGTACCGCAGAGTCCTTGGGGATAGCTGGGTTCACGTGCAGGATGGACGGATCGTCGCGCTCGGAGTGCACGCCGAGTCGGTGCCTCCGCCAGCGGATCGGGTGATCGATGCACGCGGCAAGGTCGTGTTACCCGGTTTCATCAATGCCCACACCCATGTGAACCAGATCCTCCTGCGCGGAGGGCCCTCGCACGGGCGTCAACTCTATGACTGGCTGTTCAACGTTTTGTATCCGGGACAAAAGGCGATGAGACCGGAGGACGTAGCGGTGGCGGTGAGGTTGTATTGTGCGGAAGCTGTGCGCAGCGGGATTACGACGATCAACGACAACGCCGATTCGGCCATCTACCCAGGCAACATCGAGGCCGCGATGGCGGTCTATGGTGAGGTGGGTGTGAGGGTCGTCTACGCCCGCATGTTCTTTGATCGGATGGACGGGCGCATTCAAGGGTATGTGGACGCCTTGAAGGCTCGCTCTCCCCAAGTCGAACTGTGCTCGATCATGGAGGAAACGGCTGTGGCCAAAGATCGGATCACAGCCCTGTCAGATCAGTATCATGGCACGGCAGGAGGTCGTATATCAGTTTGGCCCGCTCCTGCCATTACCCCGGCGGTGACAGTTGAAGGAATGCGATGGGCACAAGCCTTCGCCCGTGATCGGGCGGTAATGTGGACGCTTCACATGGCGGAGAGCGATCATGATGAGCGGCTTCATTGGATGAGTCCCGCCGAGTACATGGAGTGTTACGGACTCTTGGATGAGCGTCTGCAGGTCGCGCATTGCGTGTACTTTGACCGGAAGGATGTTCGGCTGCTGCACCGCCACAATGTGAAGGTCGCGTCGCAGGTTGTGAGCAATGCCTACCTCGGCTCAGGGGTGGCCCCCGTGCCAGAGATGGTGGAGCGCGGCATGGCCGTGGGCATTGGAACAGATGACGGGAATTGTAATGACTCCGTAAACATGATCGGAGACATGAAGTTTATGGCCCATATTCACCGCGCGGTGCATCGGGATGCGGACGTGCTGACCCCAGAGAAGATTCTTGAAATGGCGACGATCGATGGGGCGCGTTCGTTGGGAATGGACCACGAGATTGGTTCCATCGAAACCGGCAAGCGCGCGGACCTTATCCTGCTTGACCTGCGTCACCCTCAGACGACTCCTCACCATCATTTGGCGGCCACGATCGTGTTTCAGGCTTACGGCAATGAGGTGGACACTGTCCTGATTGACGGAAACGTTGTGATGGAGAACCGCCGCTTGAGCTTTCTTCCCCCTGAACGTGAGTTGGCGTTCCTTGAGGAAGCGCAGAGCCGCGCCACAGCTATTTTGCAGCGGGCGAACATGGTGGCTAACCCAGCTTGGCGCAGCCTCTAG"></textarea>
                            </div>
                        </div>
                        <br>
                    </div>
                    <div class="row">
                        <div class="col-xl-5" id="driver_by_list">
                            <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                                title="Positions of variable nucleotides (or amino acids). (Maximum 15 or 20)">
                                <span class="input-group-text">Positions</span>

                        </div>
                                <textarea class="form-control custom-control"
                                rows="2" style="resize:none" id="driver_positions" name="sequence" placeholder="250 274 375 650 655 757 763 982 991"></textarea>
                            </div>
                            <br>
                        </div>
                    </div>
                    <!-- row-->
                </form>
                <div class="row">
                    <div class="col-xl-6 offset-lg-3">
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-warning" id="driver_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
Clear</button>
                            <button type="button"
                            class="btn btn-info" id="driver_demo"><i class="fas fa-gift"></i> Demo</button>
                            <button type="button"
                            class="btn btn-success" id="driver_calculate"><i class="fas fa-exchange" aria-hidden="true"></i>
Calculate</button>
                        </div>
                    </div>
                    <br>
                </div>
                <!-- The results -->
                <div class="row hidden" id="driver_result">
                    <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
                    <br>
                </div>
            </div>
        </div>