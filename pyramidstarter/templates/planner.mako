<%page args="page, collapse_section"/>
<div class="card">
    <div class="card-header">
         <h1 class="card-title">Planner</h1>
        <h4 class="card-subtitle mb-2 text-muted">Plan your experiment</h4>
    </div>
    <div class="card-body">
        <div id="planner_intro">
             <h3>Description</h3>
            <p>Plan your experiment to get a given amount of mutations or predict what you may get from your PCR yield.</p>
        </div>
        <div id="planner_input">
             <h3>Input</h3>
            <!-- plan or verify?-->
            <div class="input-group m-3">
                <div class="input-group-prepend" data-toggle="tooltip"
                                            title="Planning or verifying yeilds?"
                                            data-placement="top">
                <span class="input-group-text">Choose:</span>
                </div>
                <input type="checkbox" class="switch"
                       id="planner_method" data-on-text="Verify" data-off-text="Plan"
                       data-off-color="warning" data-size="large" data-toggle="switch">
            </div>
            <!-- template-->
            <h5>Template</h5>
            <p>Herein, by "template" the span amplified is intendended, while by "plasmid" the full DNA element containing the template (be it aDNA, cDNA, plasmid or gDNA).<br/>
                <span class="planner-verify">There are two ways to input the data. Please fill one of either of the following rows.</span></p>
            <ul class="list-group mb-3">
                      <!-- final conc -->
                      <li class="list-group-item planner-verify">
                          <div class="row">
                      <div class="col-6 p-1">
                          <div class="input-group" data-toggle="tooltip"
                                                            title="The amount of template added"
                                                            data-placement="top">
                                <div class="input-group-prepend">
                                <span class="input-group-text">Template amount</span>
                                </div>
                                <input type="number" min="0" class="form-control"
                                       id="planner_t_ng">
                              <div class="input-group-append">
                                <span class="input-group-text">ng</span>
                                </div>
                            </div>
                      </div>

                  </div> <!--/row-->
                      </li>
                      <!-- amount. and vol. -->
                      <li class="list-group-item">
                          <div class="row">
                          <div class="col-6  p-1">
                              <div class="input-group" data-toggle="tooltip"
                                                                title="plasmid concentration (stock, not final)"
                                                                data-placement="top">
                                    <div class="input-group-prepend">
                                    <span class="input-group-text">Plasmid conc.</span>
                                    </div>
                                    <input type="number" min="0" class="form-control"
                                           id="planner_p_conc">
                                  <div class="input-group-append">
                                    <span class="input-group-text">ng/µL</span>
                                    </div>
                                </div>
                          </div>

                          <div class="col-6  p-1 planner-verify">
                              <div class="input-group" data-toggle="tooltip"
                                                                title="Volume of the stock added to the reaction mix"
                                                                data-placement="top">
                                    <div class="input-group-prepend">
                                    <span class="input-group-text">Volume</span>
                                    </div>
                                    <input type="number" min="0" class="form-control"
                                           id="planner_p_vol">
                                  <div class="input-group-append">
                                    <span class="input-group-text">µL</span>
                                    </div>
                                </div>
                          </div>
                          <div class="col-6 p-1">
                              <div class="input-group" data-toggle="tooltip"
                                                                title="Size of template in kb"
                                                                data-placement="top">
                                    <div class="input-group-prepend">
                                    <span class="input-group-text">Template size</span>
                                    </div>
                                    <input type="number" min="0" class="form-control"
                                           id="planner_t_size">
                                  <div class="input-group-append">
                                    <span class="input-group-text">kb</span>
                                    </div>
                                </div>
                          </div>
                          <div class="col-6 p-1">
                              <div class="input-group" data-toggle="tooltip"
                                                                title="Size of the plasmid in kb"
                                                                data-placement="top">
                                    <div class="input-group-prepend">
                                    <span class="input-group-text">Plasmid size</span>
                                    </div>
                                    <input type="number" min="0" class="form-control"
                                           id="planner_p_size">
                                  <div class="input-group-append">
                                    <span class="input-group-text">kb</span>
                                    </div>
                                </div>
                          </div>

                  </div> <!--/row-->
                      </li>
                  </ul>
            <!-- yield (p=plasmid, y=product)-->
            <div class="planner-verify">
                <h5>Yield</h5>
            <p>Data from PCR product quantification. Fill one of either row.</p>
                  <ul class="list-group mb-3">
                      <!-- final conc -->
                      <li class="list-group-item">
                          <div class="row">
                      <div class="col-6 p-1">
                          <div class="input-group" data-toggle="tooltip"
                                                            title="Amount obtained after PCR purification"
                                                            data-placement="top">
                                <div class="input-group-prepend">
                                <span class="input-group-text">Product amount</span>
                                </div>
                                <input type="number" min="0" class="form-control"
                                       id="planner_y_ng">
                              <div class="input-group-append">
                                <span class="input-group-text">ng</span>
                                </div>
                            </div>
                      </div>
                  </div> <!--/row-->
                      </li>
                      <li class="list-group-item">
                          <div class="row">
                      <div class="col-6 p-1">
                          <div class="input-group" data-toggle="tooltip"
                                                            title="Concentration obtained after PCR purification"
                                                            data-placement="top">
                                <div class="input-group-prepend">
                                <span class="input-group-text">Product conc.</span>
                                </div>
                                <input type="number" min="0" class="form-control"
                                       id="planner_y_conc">
                              <div class="input-group-append">
                                <span class="input-group-text">ng/µL</span>
                                </div>
                            </div>
                      </div>
                      <div class="col-6 p-1">
                          <div class="input-group" data-toggle="tooltip"
                                                            title="Volume of elution obtained after PCR purification"
                                                            data-placement="top">
                                <div class="input-group-prepend">
                                <span class="input-group-text">Product volume</span>
                                </div>
                                <input type="number" min="0" class="form-control"
                                       id="planner_y_vol">
                              <div class="input-group-append">
                                <span class="input-group-text">µL</span>
                                </div>
                            </div>
                      </div>
                  </div> <!--/row-->
                      </li>
                  </ul>
            </div>

            <h5>Other</h5>
            <div class="row mx-2 my-2">
                      <div class="col-6 p-1">
                          <div class="input-group" data-toggle="tooltip"
                                                            title="PCR Reaction volume (required to determine how well did the PCR work)."
                                                            data-placement="top">
                                <div class="input-group-prepend">
                                <span class="input-group-text">Rxn volume</span>
                                </div>
                                <input type="number" min="0" class="form-control"
                                       id="planner_r_vol">
                              <div class="input-group-append">
                                <span class="input-group-text">µL</span>
                                </div>
                            </div>
                      </div>
                      <div class="col-6 p-1 planner-verify">
                          <div class="input-group" data-toggle="tooltip"
                                                            title="Purification loss. A rough estimate: 50% for gel extraction, 80% for Qiaquick. Alter the number by ear if you suspect loss due to spills etc."
                                                            data-placement="top">
                                <div class="input-group-prepend">
                                <span class="input-group-text">Purification loss</span>
                                </div>
                                <input type="number" min="0" class="form-control"
                                       id="planner_loss" value="50">
                              <div class="input-group-append">
                                <span class="input-group-text">%</span>
                                </div>
                            </div>
                      </div>
                      <div class="col-6 p-1 planner-plan">
                          <div class="input-group" data-toggle="tooltip"
                                                            title="Desired number of nucleotide mutations per kb"
                                                            data-placement="top">
                                <div class="input-group-prepend">
                                <span class="input-group-text">Mutational load</span>
                                </div>
                                <input type="number" min="0" class="form-control"
                                       id="planner_m_load" value="5">
                              <div class="input-group-append">
                                <span class="input-group-text">mut/kb</span>
                                </div>
                            </div>
                      </div>
                      <div class="col-6 p-1">
                          <div class="input-group" data-toggle="tooltip"
                                                            title="Number of mutations per kb per duplication. Method specific: for mutazyme use 0.9, for manganese you need to calculate based on previous experiments, but roughly use 1-5 depending on mM Mn2+ concentration (it is not really linear, see FAQ how to calculate)."
                                                            data-placement="top">
                                <div class="input-group-prepend">
                                <span class="input-group-text">Error rate</span>
                                </div>
                                <input type="number" min="0" class="form-control"
                                       id="planner_m_rate" value="0.9">
                              <div class="input-group-append">
                                <span class="input-group-text">/kb/dup.</span>
                                </div>
                            </div>
                      </div>
            </div>
        </div>
        <%include file="calculate_btns.mako" args="tool='planner'"/>
        <div id="planner_results">
        </div>
    </div>
</div>