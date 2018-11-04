<div class="card">
            <div class="card-header">
                 <h1 class="card-title">Chances of a mutation

                    </h1>
            </div>
            <div>
                <div class="card-body">
                    <div id="probably_input">
                         <h3>Input</h3>
                        <div class="row">
                            <!--section-->
                             <h4>Sequence</h4>
                            <p>In frame sequence that was mutagenised. Note that all symbols that aren&apos;t
                                uppecase ATUGC, will be discarded along with a Fasta header (<i>e.g.</i> &apos;&gt;T.
                                maritima Cystathionine &#x3B2;-lyase&apos;), therefore for masked sequences
                                use lowercase.</p>
                            <div class="col-xl-12">
                                <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" data-placement="top"
                                    title="In frame sequence that was mutagenised.">Sequence

                        </span>
                                    <textarea class="form-control custom-control"
                                    rows="5" style="resize:none" id="probably_sequence" name="probably_sequence"></textarea> <span class="input-group-addon">Retrieve previous<br>

            <button class="btn btn-secondary" type="button" id="probably_sequence_retrieve" data-toggle="tooltip" data-placement="top" title="In frame sequence that was mutagenised."><i class="fas fa-history"></i></button>

          </span>
                                </div>
                                <br>
                            </div>
                            <br>
                        </div>
                        <div class="row">
                            <div class="col-xl-3">
                                <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="Library size L"
                                    data-placement="top">Library size</span>
                                    <input type="number" min="0" class="form-control"
                                    placeholder="10000000" id="probably_size">
                                </div>
                                <br>
                            </div>
                        </div>
                         <h4>Nucleotide mutation matrix</h4>
(non-negative numbers. Overall scaling is unimportant as this is taken
                        from the &apos;mean number of substitutions per daughter sequence&apos;
                        parameter.)
                        <div class="row">
                            <div class="col-xl-12">
                                <table>
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
                                                            <input class="mutation_identity" type="text" disabled id="A2A" value="&#x2014;">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" type="text" id="A2T" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_Rtransition" id="A2G" type="text" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" id="A2C" type="text" value="0">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th width="20%">T</th>
                                                        <td width="20%">
                                                            <input class="mutation_transversion" type="text" id="T2A" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_identity" type="text" disabled id="T2T" value="&#x2014;">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" id="T2G" type="text" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_Ytransition" id="T2C" type="text" value="0">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th width="20%">G</th>
                                                        <td width="20%">
                                                            <input class="mutation_Rtransition" type="text" id="G2A" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" type="text" id="G2T" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_identity" disabled id="G2G" type="text" value="&#x2014;">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" id="G2C" type="text" value="0">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%">C</td>
                                                        <td width="20%" bgcolor="#FFFF99">
                                                            <input type="text" id="C2A" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_Ytransition" type="text" id="C2T" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_transversion" id="C2G" type="text" value="0">
                                                        </td>
                                                        <td>
                                                            <input class="mutation_identity" disabled id="C2C" type="text" value="&#x2014;">
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <br>
                            </div>
                            <div class="col-xl-6 offset-lg-2">
                                <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                    <div class="btn-group" role="group">
                                        <label class="btn btn-secondary btn-file" id="probably_load_group"> <i class="fas fa-upload" aria-hidden="true"></i> Load
                                            <input type="file"
                                            id="probably_load_spectrum" style="display: none;">
                                        </label>
                                    </div>
                                    <div class="btn-group" role="group">
                                        <label class="btn btn-secondary btn-file" id="probably_save_spectrum"> <i class="fas fa-download" aria-hidden="true"></i> Save</label>
                                    </div>
                                    <div class="btn-group" role="group">
                                        <label class="btn btn-secondary btn-file" id="probably_retrieve_spectrum"> <i class="fas fa-history" aria-hidden="true"></i> Previous</label>
                                    </div>
                                    <div class="btn-group" role="group">
                                        <label class="btn btn-secondary dropdown-toggle" data-toggle="dropdown"
                                        aria-haspopup="true" aria-expanded="false">Preset <span class="caret"></span>
                                        </label>
                                        <ul class="dropdown-menu">
                                            <li class="fake-link dropdown-item"><span id="probably_opt_mutazyme">Mutazyme II</span>
                                            </li>
                                            <li class="fake-link dropdown-item"><span id="probably_opt_manganese">Mn Taq</span>
                                            </li>
                                            <li class="fake-link dropdown-item"><span id="probably_opt_D473G">Pfu D215A D473G</span>
                                            </li>
                                            <li class="fake-link dropdown-item"><span id="probably_opt_analogues">dNTP oxodGTP</span>
                                            </li>
                                            <li class="fake-link dropdown-item"><span id="probably_opt_MP6">MP6</span>
                                            </li>
                                            <li class="fake-link dropdown-item"><span id="probably_opt_uniform">Uniform</span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <br>
                            </div>
                            <br>
                        </div>
                        <div class="row">
                            <div class="col-xl-4">
                                <div class="input-group">Values are
                                    <input type="checkbox" class="switch" id="probably_normal" data-off-text="Unnormalised"
                                    data-on-text="Normalised" data-off-color="warning">
                                </div>
                            </div>
                            <div class="col-xl-4">
                                <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="Mean number of nucleotide substitutions per daughter sequence"
                                    data-placement="top">Mutation load</span>
                                    <input type="number" min="0" class="form-control"
                                    placeholder="4.5" id="probably_load">
                                </div>
                            </div>
                            <div class="col-xl-4">
                                <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="List of mutations in a variant"
                                    data-placement="top">Mutations</span>
                                    <input type="text" class="form-control"
                                    placeholder="Y66W" id="probably_list">
                                </div>
                            </div>
                            <!--button row-->
                            <div class="row">
                                <div class="col-xl-6 offset-lg-3">
                                    <div class="btn-group" role="group" aria-label="...">
                                        <button type="button" class="btn btn-warning" id="probably_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
Clear</button>
                                        <button type="button"
                                        class="btn btn-info" id="probably_demo"><i class="fas fa-gift" aria-hidden="true"></i>
Demo</button>
                                        <button type="button"
                                        class="btn btn-success" id="probably_calculate"><i class="fas fa-exchange" aria-hidden="true"></i>
Calculate</button>
                                    </div>
                                </div>
                                <br>
                            </div>
                        </div>
                        <div class="row hidden" id="probably_result">
                            <div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Something went wrong</div>
                            <br>
                        </div>
                    </div>
                </div>
            </div>
        </div>