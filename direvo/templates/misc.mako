<div class="panel-group" id="accordion">
    <!--Menu-->
    <div class="card">
        <div class="card-header" data-toggle="collapse" data-parent="#accordion" data-target="#&#xA7;options" style="cursor:pointer;">
             <h1 class="card-title">Note</h1>
        </div>
        <div id="&#xA7;options" class="panel-collapse collapse show">
            <div class="card-body">Herein are some small scripts of no value written main for style experimenting.</div>
        </div>
    </div>
    <!--minipedel for PCR-->
    <div class="card">
        <div class="card-header" data-toggle="collapse" data-parent="#accordion" data-target="#&#xA7;estimate" style="cursor:pointer;">
             <h1 class="card-title">Pedel</h1>
            <h4 class="card-subtitle mb-2 text-muted">Mini-Pedel from PCR: failure</h4>
        </div>
        <div id="&#xA7;estimate" class="panel-collapse collapse">
            <div class="card-body">
                 <h2>Predicted diversity (PCR mini-Pedel)</h2>
                 <h3>Description</h3>
                <p>Normal pedel is server-side Python/C++, here it is JS. Strategising for
                    more responsive element...</p>
                <p>The PCR starting point is cool, but best just make a modal calculator.</p>
                <p>Roghly predict the mutation load from a PCR reaction based on the template
                    and yields or predict a target template concentration to aim for a given
                    mutation load.
                    <br>Do note that this is often off due to a variety of factors and should
                    not be a replacement for a test library, especially for manganese mutagenesis.
                    <br>If the PCR has not been done yet, expect around 1,000 ng yield for a 25
                    &#xB5;l PCR reaction &#x2014;the PCR yields with Mutazyme are generally
                    lower than with Phusion, so if you have a value with a different polymerase
                    underestimate from that.</p>
                 <h3>Input</h3>
                <!-- add switch?-->
                <div class="row">
                    <div class="col-xl-4">
                        <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" title="Mutation rate of the enzyme per kb per doubling, the value is between 0.9&#x2013;1.6 for mutazyme (our figure is 0.9). For manganese it completely depends on your concentration and enzyme."
                            data-placement="top">
                            <span class="input-group-text">Mutation rate</span></div>
                            <input type="number" min="0" class="form-control"
                            placeholder="0.9" id="estimate_rate"> <div class="input-group-append">
                                <span class="input-group-text">mut/kb/div</span></div>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group">
                            <div class="input-group-prepend" data-toggle="tooltip" title="Yield of DNA from the PCR reaction (after purification) in ng. So multiply the nanodrop&apos;s ng/&#xB5;l value by your volume in &#xB5;l."
                            data-placement="top">
                                <span class="input-group-text">PCR yield</span></div>
                            <input type="number" min="0" class="form-control"
                            placeholder="1000" id="estimate_yield"> <div class="input-group-append">
                            <span class="input-group-text">ng</span></div>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" title="Template of DNA in the PCR reaction. If using a plasmid this is the concentration of the actual insert not the whole plasmid. That is, get your ng/&#xB5;l concentration of plasmid divide it by the plasmid size and times it by the insert size and then multiply it by the volume added to your epPCR reaction"
                            data-placement="top">
                            <span class="input-group-text">PCR template</span></div>
                            <input type="number" min="0" class="form-control"
                                   placeholder="5" id="estimate_template">
                            <div class="input-group-append"><span class="input-group-text">ng</span></div>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" title="Size of amplicon in kb"
                            data-placement="top">
                            <span class="input-group-text">Size</span></div>
                            <input type="number" min="0" class="form-control"
                            placeholder="1.0" id="estimate_size"> <div class="input-group-append">
                                <span class="input-group-text">kb</span></div>
                        </div>
                        <br>
                    </div>
                </div>
                <!--row-->
                <div class="row">
                    <div class="col-xl-6 offset-lg-3">
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-warning" id="estimate_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
Clear</button>
                            <button type="button"
                            class="btn btn-info" id="estimate_demo"><i class="fas fa-gift" aria-hidden="true"></i>
Demo</button>
                            <button type="button"
                            class="btn btn-success" id="estimate_calculate"><i class="fas fa-exchange" aria-hidden="true"></i> Calculate</button>
                        </div>
                    </div>
                    <br>
                </div>
                <div id="estimate_results">The number of doublings is <span id="estimate_doublings">xx</span>.
                    <br>The expected mutational load is <span id="estimate_mloadkb">xx</span> per
                    kb.
                    <br>The expected mutational load is <span id="estimate_mload">xx</span> per
                    amplicon.
                    <br>
                    <div id="estimate_chart"></div>
                </div>
            </div>
        </div>
    </div>
    <!--PCR -->
    <div class="card">
        <div class="card-header" data-toggle="collapse" data-parent="#accordion" data-target="#&#xA7;yield" style="cursor:pointer;">
             <h1 class="card-title">PCR maths</h1>
        </div>
        <div id="&#xA7;yield" class="panel-collapse collapse">
            <div class="card-body">
                 <h2>Theoretical maximum PCR yield</h2>
                 <h3>Description</h3>
                <div class="bs-callout bs-callout-info">This is just an easy demo. It works, but it&apos;s kind of pointless as
                    your yield will be around 50 ng per &#xB5;l rxn and nowhere close to the
                    theoretical maximum. It was made simply as a demo self standing block.</div>
                <p>To predict how many doubling one could get it is often handy to know the
                    theoretical maximum aDNA yield from a PCR. As is clear from a QPCR curve,
                    a PCR does not run forever and stops after some cycles, either the primers
                    or dNTPs are finished.
                    <br>This is a rough guess for various reasons.
                    <ul>
                        <li>This theoretical maximum is not attainable due to minor products or PCR
                            poisoning by various compounds (<i>e.g.</i> dUTP, dITP, dNDPs, magnesium
                            pyrophosphate crystals <i>etc.</i>)</li>
                        <li>It could even be higher due to pippetting inaccuracies, spectral contaminants
                            (<i>e.g.</i>
isopropanol from QG buffer).</li>
                        <li>Not all bases are used equally...</li>
                    </ul>
                    <br>N.B. A 20 nt primer final concentration of 2.50 ng/&#xB5;l (an oddity
                    of the Genemorph II kit) is 0.38 &#xB5;M.</p>
                 <h3>Input</h3>
                <div class="row">
                    <div class="col-xl-4">
                        <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" title="The reaction volume"
                            data-placement="top">
                            <span class="input-group-text">Reaction</span></div>
                            <input type="number" min="0" class="form-control"
                            placeholder="25" id="yield_reaction"> <div class="input-group-append">
                                <span class="input-group-text">&#xB5;L</span></div>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group">
                            <div class="input-group-prepend" data-toggle="tooltip" title="The size of the amplicon in bases. Preferably minus the length the primers, but really it does not matter, so within 100 bp will be all good."
                            data-placement="top">
                                <span class="input-group-text">Amplicon size</span>
                            </div>
                            <input type="text" class="form-control"
                            placeholder="1000" id="yield_size">
                            <div class="input-group-append"><span class="input-group-text">bp</span></div>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" title="Method used: full overlap (traditional) of primers or staggered overlap"
                            data-placement="top">
                            <span class="input-group-text">Concentration</span></div>
                            <input type="checkbox" class="switch"
                            id="yield_calc_method" checked data-off-text="Calc." data-on-text="Final"
                            data-switch-value="large" data-off-color="warning"> <span class="input-group-addon">&#xB5;M</span>
                        </div>
                        <br>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xl-4">
                        <div class="input-group">
                            <div class="input-group-prepend" data-toggle="tooltip" title="The primer volume"
                            data-placement="top">
                                <span class="input-group-text">Final conc. primers</span></div>
                            <input type="number" min="0"
                            step="1" class="form-control" placeholder="0.5" id="yield_final_primer_conc">
                            <div class="input-group-append"><span class="input-group-text">&#xB5;M</span></div>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group"> <div class="input-group-prepend" data-toggle="tooltip" title="The primer volume"
                                                       data-placement="top"><span class="input-group-text">Conc. primers</span></div>
                            <input type="number" min="0" step="1"
                            class="form-control" placeholder="10" id="yield_primer_conc">
                            <div class="input-group-append"><span class="input-group-text">&#xB5;M</span></div>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group">
                            <div class="input-group-prepend" data-toggle="tooltip" title="The primer volume"
                            data-placement="top">
                                <span class="input-group-text">Vol. primers</span></div>
                            <input type="number" min="0" step="1"
                            class="form-control" placeholder="1.25" id="yield_primer_vol">
                            <div class="input-group-append">
                                <span class="input-group-text">&#xB5;L</span></div>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group"> <span class="input-group-addon" data-toggle="tooltip" title="The dNTP final concentration (all four together)"
                            data-placement="top">final &#xB5;M dNTP</span>
                            <input type="number" min="0"
                            step="1" class="form-control" placeholder="800" id="yield_final_dNTP_conc">
                            <div class="input-group-append"><span class="input-group-text">&#xB5;M</span></div>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group">
                            <div class="input-group-prepend" data-toggle="tooltip" title="The dNTP concentration (all four together)"
                                 data-placement="top"><span class="input-group-text">&#xB5;M dNTP</span></div>
                            <input type="number" min="0" step="1"
                            class="form-control" placeholder="40" id="yield_dNTP_conc">
                            <div class="input-group-append"><span class="input-group-text">&#xB5;M</span></div>
                        </div>
                        <br>
                    </div>
                    <div class="col-xl-4">
                        <div class="input-group">
                            <div class="input-group-prepend" data-toggle="tooltip" title="The dNTP volume added"
                            data-placement="top">
                                <span class="input-group-text">&#xB5;l dNTP</span></div>
                            <input type="number" min="0" step="1"
                            class="form-control" placeholder="0.5" id="yield_dNTP_vol"> <div class="input-group-append">
                            <span class="input-group-text">&#xB5;L</span></div>
                        </div>
                        <br>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xl-6 offset-lg-3">
                        <div class="btn-group" role="group" aria-label="...">
                            <button type="button" class="btn btn-warning" id="yield_clear"><i class="fas fa-eraser" aria-hidden="true"></i>
Clear</button>
                            <button type="button"
                            class="btn btn-info" id="yield_demo"><i class="fas fa-gift" aria-hidden="true"></i>
Demo</button>
                            <button type="button"
                            class="btn btn-success" id="yield_calculate"><i class="fas fa-exchange" aria-hidden="true"></i>
Calculate</button>
                        </div>
                    </div>
                    <br>
                </div>
                <div class="row">
                    <div class="card bg-light card-body mb-3">
                        <div id="yield_result"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>