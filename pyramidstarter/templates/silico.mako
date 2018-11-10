<div class="card">
            <div class="card-header">
                 <h1 class="card-title">Generator</h1>
                <h4 class="card-subtitle mb-2 text-muted">Generate mutants in silico</h4>
            </div>
            <div>
                <div class="card-body">
                    <div id="silico_intro">
                        <p>You never know when you need a random sequence.</p>
                    </div>
                    <div class="bs-callout bs-callout-warning">Under construction. Half-abandonned actually as I figured something out.</div>
                    <div
                    id="silico_input">
                        <div class="row">
                            <!--section-->
                             <h4>Sequence</h4>
                            <p>In frame nt sequence that is to be mutagenised.</p>
                            <div class="col-xl-12">
                                <div class="input-group">
                                    <div class="input-group-prepend" data-toggle="tooltip" data-placement="top"
                                    title="In frame sequence that was mutagenised.">
                                    <span class="input-group-text">Sequence</span>
                        </div>
                                    <textarea class="form-control custom-control"
                                    rows="5" style="resize:none" id="silico_sequence" name="silico_sequence"></textarea>
                                    <div class="input-group-append">
            <button class="btn btn-secondary" type="button" id="silico_sequence_retrieve" data-toggle="tooltip" data-placement="top" title="In frame sequence that was mutagenised."><i class="fas fa-history"></i><br> Retrieve previous</button>



          </div>
                                </div>
                                <br>
                            </div>
                            <br>
                        </div>
                        <div class="row">
                            <div class="col-xl-12">
                                <table class="table">
                                    <tr>
                                        <td></td>
                                        <td align="center"><b>To</b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="middle"><b>From</b>&#xA0;&#xA0;</td>
                                        <td>
                                            <table width="50%" border="0" id="mutTable_raw">
                                                <thead>
                                                    <tr></tr>
                                                    <tr>
                                                        <th width="20%"></th>
                                                        <th width="20%">A</th>
                                                        <th width="20%">T</th>
                                                        <th width="20%">G</th>
                                                        <th width="20%">C</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <th>A</th>
                                                        <td>
                                                            <input class="mutation_identity" type="number" disabled id="A2A" value="&#x2014;">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" type="number" id="A2T" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_Rtransition" id="A2G" type="number" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" id="A2C" type="number" value="0">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th width="20%">T</th>
                                                        <td width="20%">
                                                            <input class="mutation_transversion" type="number" id="T2A" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_identity" type="number" disabled id="T2T" value="&#x2014;">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" id="T2G" type="number" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_Ytransition" id="T2C" type="number" value="0">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th width="20%">G</th>
                                                        <td width="20%">
                                                            <input class="mutation_Rtransition" type="number" id="G2A" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" type="number" id="G2T" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_identity" disabled id="G2G" type="number" value="&#x2014;">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" id="G2C" type="number" value="0">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%">C</td>
                                                        <td width="20%">
                                                            <input type="number" id="C2A" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_Ytransition" type="number" id="C2T" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" id="C2G" type="number" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_identity" disabled id="C2C" type="number" value="&#x2014;">
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <br>
                            </div>
                            <div class="col-xl-4">
                                <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                    <div class="btn-group" role="group">
                                        <label class="btn btn-secondary btn-file" id="silico_load_group"> <i class="fas fa-upload" aria-hidden="true"></i> Load
                                            <input type="file"
                                            id="silico_load_spectrum" style="display: none;">
                                        </label>
                                    </div>
                                    <div class="btn-group" role="group">
                                        <label class="btn btn-secondary btn-file" id="silico_save_group"> <i class="fas fa-download" aria-hidden="true"></i> Load
                                            <input type="file"
                                            id="silico_save_spectrum" style="display: none;">
                                        </label>
                                    </div>
                                    <div class="btn-group" role="group">
                                        <button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown"
                                        aria-haspopup="true" aria-expanded="false">Preset <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li class="fake-link dropdown-item"><span id="silico_opt_mutazyme">Mutazyme II</span>
                                            </li>
                                            <li class="fake-link dropdown-item"><span id="silico_opt_manganese">Mn Taq</span>
                                            </li>
                                            <li class="fake-link dropdown-item"><span id="silico_opt_D473G">Pfu D215A D473G</span>
                                            </li>
                                            <li class="fake-link dropdown-item"><span id="silico_opt_analogues">dNTP oxodGTP</span>
                                            </li>
                                            <li class="fake-link dropdown-item"><span id="silico_opt_MP6">MP6</span>
                                            </li>
                                            <li class="fake-link dropdown-item"><span id="silico_opt_uniform">Uniform</span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <br>
                        </div>
                        <div class="row">
                            <div class="col-xl-4">
                                <div class="input-group">
                                    <div class="input-group-prepend" data-toggle="tooltip" title="Mean number of nucleotide substitutions per daughter sequence"
                                    data-placement="top">
                                        <span class="input-group-text">Mutation load</span></div>
                                    <input type="number" min="0" class="form-control"
                                    placeholder="4.5" id="silico_load">
                                </div>
                                <br>
                            </div>
                        </div>
                </div>
                <div class="row">
                    <div class="col-xl-6 offset-lg-3">
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-warning" id="silico_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
Clear</button>
                            <button type="button"
                            class="btn btn-info" id="silico_demo"><i class="fas fa-gift" aria-hidden="true"></i>
Demo</button>
                            <button type="button"
                            class="btn btn-success" id="silico_calculate"><i class="fas fa-exchange" aria-hidden="true"></i>
Calculate</button>
                        </div>
                    </div>
                    <br>
                </div>
                <div class="row hidden" id="silico_result">
                    <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
                </div>
            </div>
        </div>
    </div>