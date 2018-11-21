<%page args="tool"/>
<div class="d-flex align-items-center">
                    <div class="order-2">
                        <div class="btn-group-vertical" role="group" aria-label="...">
                            <div class="btn-group" role="group">
                                <span class="btn btn-secondary btn-file" id="${tool}_load_group"> <i class="fa fa-upload"
                                                                                                      aria-hidden="true"></i>
                                    Load
                                    <input type="file"
                                           id="pedelAA_load_spectrum" style="display: none;">
                                </span>
                            </div>
                            <div class="btn-group" role="group">
                                <span class="btn btn-secondary btn-file" id="${tool}_save_spectrum"> <i
                                        class="fa fa-download"
                                        aria-hidden="true"></i>
                                    Save</span>
                            </div>
                            <div class="btn-group" role="group">
                                <span class="btn btn-secondary btn-file" id="${tool}_retrieve_spectrum"> <i
                                        class="fa fa-history"
                                        aria-hidden="true"></i>&nbsp;Previous</span>
                            </div>
                            <div class="btn-group" role="group">
                                <span class="btn btn-secondary dropdown-toggle" data-toggle="dropdown"
                                       aria-haspopup="true" aria-expanded="false">Preset <span class="caret"></span>
                                </span>
                                <ul class="dropdown-menu">
                                    <li class="fake-link dropdown-item"><span id="${tool}_opt_mutazyme">Mutazyme II</span>
                                    </li>
                                    <li class="fake-link dropdown-item"><span id="${tool}_opt_manganese">Mn Taq</span>
                                    </li>
                                    <li class="fake-link dropdown-item"><span id="${tool}_opt_D473G">Pfu D215A D473G</span>
                                    </li>
                                    <li class="fake-link dropdown-item"><span id="${tool}_opt_analogues">dNTP oxodGTP</span>
                                    </li>
                                    <li class="fake-link dropdown-item"><span id="${tool}_opt_MP6">MP6</span>
                                    </li>
                                    <li class="fake-link dropdown-item"><span id="${tool}_opt_uniform">Uniform</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="order-1">
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
                                                <input class="mutation_identity" type="text" disabled id="A2A"
                                                       value="&#x2014;">
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
                                                <input class="mutation_identity" type="text" disabled id="T2T"
                                                       value="&#x2014;">
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
                                                <input class="mutation_identity" disabled id="G2G" type="text"
                                                       value="&#x2014;">
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
                                                <input class="mutation_identity" disabled id="C2C" type="text"
                                                       value="&#x2014;">
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br>
                    </div>
                    <br>
                </div>