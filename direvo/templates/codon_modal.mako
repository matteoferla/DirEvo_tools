<!--The JS is in static/sitewide.js-->
<div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="CodonScheme"
id="scheme_modal">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title">Codon choice</h1><button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
            </div>
            <div class="modal-body">
                <h1>Description</h1>
                <div class="row" id="codon_intro">

<p>This helper allows you to pick the most ideal degenerate codons. It comes
                    in two forms. You choose the required amino acids or you choose the codons
    to inspect.</p></div>
                 <h3>By codon (<a data-toggle="collapse" href="#codon_bycodon"><i class="fas fa-caret-down" aria-hidden="true"></i> show</a>)</h3>
                <div class="row collapse" id="codon_bycodon">
                    <div class="col-lg-4">
                        <div class="row">
                            <div class="input-group">
                                <div class="dropdown">
                                  <button class="btn btn-secondary dropdown-toggle" type="button" id="codon_down" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Codon...
                                  </button>
                                  <div class="dropdown-menu" id="codon_down_choice">
                                      <% options=(
                                          ('NNN','(Generic scheme. Unbalanced and with 3/64 stop codons.','NNN (unbalanced)'),
                                          ('NNK','Common scheme, identical to NNS. Cuts the number of stop codons while still making tryptophan','NNK (unbalance, few stop)'),
                                          ('NNS','Common scheme, identical to NNK. Cuts the number of stop codons while still making a tryptophan','NNS  (unbalance, few stop)'),
                                          ('NAN','Gives charged amino acids of various sizes.','NAN  (charged AA)'),
                                          ('NTN','Gives hydrophobic residues.','NTN (hydrophobics)'),
                                          ('NGN','Not generally empoyed alone: it yields gly, arg, trp, cys &#x2014;note the glycine. hence the NSN codon.','NGN (gly+cys etc)'),
                                          ('NCN','Gives small residues, but not glycine.','NCN (small, no gly'),
                                          ('NSN','Gives small redisues including glycine and cysteine','NSN (small inc. gly and cys)'),
                                          ('NDT','?????','NDT'),
                                          ('DBK','?????','DBK'),
                                          ('NRT','?????','NRT'),
                                          ('19c','Tang et. al. (19c)','Tang (19c)'),
                                          ('20c','','??? (20c)'),
                                          ('22c','Kille et al. (22c)','Kille (22c)'),
                                          ('other','User inputted codon(s)','Other'))
                                          %>
                                      % for (value, definition, text) in options:
                                          <button class="dropdown-item" type="button" data-value="${value}" data-toggle="tooltip" data-placement="left" title="${definition}">${value}</button>
                                      % endfor
                                  </div>
                                </div>
                                <br>
                            </div>
                        </div>
                        <div class="row">
                            <br>
                            <div id="codon_manual">
                                <div class="input-group">
                                    <div class="input-group-prepend" data-toggle="tooltip" title="The mutation used. The input is a string which can be simply four bases (e.g. &apos;NNK&apos;) or multiple codons separated by a space and optionally prefixed with a interger number denoting their ratios (e.g. &apos;12NDT 6VHA 1TGG 1ATG&apos;) or a special mix (e.g. &apos;Tang&apos;)."
                                    data-placement="top">
                                        <span class="input-group-text">Scheme</span>
                                    </div>
                                    <input type="text" class="form-control"
                                    placeholder="NNN" id="codon_mutation">
                                    <div class="input-group-append">
                                        <button class="btn btn-success" type="button"><i class="fas fa-calculator"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div id="codon_graph"></div>
                    </div>
                    <div id="codon_result"></div>
                </div>
                 <h3>By amino acids (<a data-toggle="collapse" href="#codon_byAA"><i class="fas fa-caret-down" aria-hidden="true"></i> show</a>)

                    </h3>
                <div class="collapse" id="codon_byAA">
                    <p>This section would be cool if it had a negative option and stuff like,
                        hydrophobics use Z.</p>
                    <p>It sorts with a 2x penalty for stop and give precence to more equal distributions,
                        in case of a tie to less degenerate codons.</p>
                    <p>Accepts three letter code with first letter capital separated by a space,
                        or one letter with spaces or not &#x2014; corner case: SER is Ser + Asp
                        + Arg while Ser is Serine.</p>
                    <div class="row">
                    <div class="col-lg-4">
                        <div class="input-group"> <div class="input-group-prepend" id="codonAA_list_addon">
                            <span class="input-group-text">Wanted AAs</span>
                        </div>
                            <input
                            type="text" class="form-control" placeholder="G P S" aria-describedby="codonAA_list_addon"
                            id="codonAA_list" required>
                            <div class="invalid-feedback">Please choose at least one amino acid</div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="input-group">
                            <div class="input-group-prepend" id="codonAA_antilist_addon">
                                <span class="input-group-text">Unwanted AAs</span>
                            </div>
                            <input
                            type="text" class="form-control" placeholder="C" aria-describedby="codonAA_antilist_addon"
                            id="codonAA_antilist">
                        </div>
                    </div>
                    <div class="col-lg-3 offset-1">
                        <div class="btn-group" role="group" aria-label="calculate">
                            <button type="button" class="btn btn-success" id="codonAA_calculate"><i class="fas fa-calculator"></i> Calculate
                            </button>
                        </div>
                    </div>
                    </div>
                    <div class="col-lg-12" id="codonAA_result"></div>
                </div>
            </div>
        </div>
    </div>
</div>