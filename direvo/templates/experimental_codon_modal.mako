<div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                        aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="codon_title">Helper to plan degenerate codons</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="bs-callout bs-callout-warning">Under construction. The ones with question marks fail and
                        this section.
                    </div>
                </div>
                <div class="row">
                    <p>Choose option:</p>
                    <div class="col-md-4">
                        <div class="row">
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <input type="radio" name="codon_opt">
                                </span>
                                <div class="well" style="background-color:#222222;"><p> Choose a common degenerate codon scheme:</p>


                                <div class="input-group"><span class="input-group-addon">Codon</span><select
                                    class='selectpicker' aria-labelledby="codon_drop" id="codon_drop" title="Choose...">
                                <option value="NNN" data-def="Generic scheme. Unbalanced and with 3/64 stop codons.">
                                    NNN
                                </option>
                                <option value="NNK"
                                        data-def="Common scheme, identical to NNS. Cuts the number of stop codons while still making tryptophan.">
                                    NNK
                                </option>
                                <option value="NNS"
                                        data-def="Common scheme, identical to NNK. Cuts the number of stop codons while still making a tryptophan">
                                    NNS
                                </option>
                                <option value="NAN" data-def="Gives charged amino acids of various sizes.">NAN</option>
                                <option value="NTN" data-def="Gives hydrophobic residues.">NTN</option>
                                <option value="NGN"
                                        data-def="Not generally empoyed alone: it yields GRWC —note the glycine. hence the NSN codon.">
                                    NGN
                                </option>
                                <option value="NCN" data-def="Gives small residues, but not glycine.">NCN</option>
                                <option value="NSN" data-def="Gives small redisues including glycine and cysteine">NSN
                                </option>
                                <option value="NDT" data-def="">NDT</option>
                                <option value="DBK" data-def="">DBK</option>
                                <option value="NRT" data-def="">NRT</option>
                                <option data-divider="true"></option>
                                <option value="19c" data-def="">??? (19c)</option>
                                <option value="20c" data-def="">Tang (20c)</option>
                                <option value="21c" data-def="">??? (21c)</option>
                                <option value="22c" data-def="">Kille (22c)</option>
                                <option data-divider="true"></option>
                                <option value="other" data-def="">other...</option>
                            </select>
                                <br/>

                            </div>

                                </div>
                                </div><!-- /input-group -->

                            <div class="input-group">
                                <span class="input-group-addon">
                                    <input type="radio"  name="codon_opt">
                                </span>
                                <div class="well" style="background-color:#222222;"><p> Input a degenerate codon scheme:</p>

                                <div class="input-group">
                                    <span class="input-group-addon" data-toggle="tooltip"
                                          title="The mutation used. The input is a string which can be simply four bases (e.g. 'NNK') or multiple codons separated by a space and optionally prefixed with a interger number denoting their ratios (e.g. '12NDT 6VHA 1TGG 1ATG') or a special mix (e.g. 'Tang')."
                                          data-placement="top">Scheme</span>
                                    <input type="text" class="form-control" placeholder="NNN" id="codon_mutation">
                                </div>
                                </div>
                            </div><!-- /input-group -->

                            <div class="input-group">
                                <span class="input-group-addon">
                                    <input type="radio"  name="codon_opt">
                                </span>
                                <div class="well" style="background-color:#222222;"><p> Choose:</p>

                                xxxx
                                </div>
                            </div><!-- /input-group -->


                        </div>
                        <div class="row">
                            <br/>
                            <div id="codon_manual" hidden>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div id="codon_graph"></div>
                    </div>
                    <div id="codon_result"></div>
                </div>
            </div>
        </div>