<%page args="page, collapse_section"/>
<div class="card bg-light card-body mb-3">
    <p>Pedel comes in two flavours.</p>
    <div class="input-group">
        <div class="input-group-prepend" data-toggle="tooltip"
                                    title="Pedel is basic and nucleotide only, Pedel-AA is more advanced and has amino acids"
                                    data-placement="top">
        <span class="input-group-text">Choose:</span>
        </div>
        <input type="checkbox" class="switch"
               id="pedel_method" data-on-text="Pedel&#x2011;AA" data-off-text="Pedel"
               data-off-color="warning" data-size="large">
    </div>
</div>
<!-- classic -->
<%include file="pedel-classic.mako" args="page=page, collapse_section=collapse_section"/>
<!-- AA -->
<%include file="pedelAA.mako" args="page=page, collapse_section=collapse_section"/>



