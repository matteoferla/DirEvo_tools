<br/>
<div>
        <ul class="nav nav-tabs" role="tablist" id="tablist" >
    <!--main-->
    <li role="presentation" class="nav-item"><a href="#pedelAA_result_main" aria-controls="pedelAA_result_main" role="tab"
        data-toggle="tab" class="nav-link active">Main</a>
    </li>
    <!--sub-->
    <li role="presentation" class="nav-item"><a href="#pedelAA_result_sub" aria-controls="pedelAA_result_sub" role="tab"
        data-toggle="tab" class="nav-link">Subtable</a>
    </li>
    <!--graph-->
    <li role="presentation" class="nav-item"><a href="#pedelAA_result_graph" aria-controls="pedelAA_result_graph" role="tab"
        data-toggle="tab" class="nav-link">Sub-graph</a>
    </li>
    <!--matrix-->
    <li role="presentation" class="nav-item"><a href="#pedelAA_result_matrix" aria-controls="pedelAA_result_matrix"
        role="tab" data-toggle="tab" class="nav-link">Scaled matrix</a>
    </li>
</ul>
    </div>
<br/>

<div class="tab-content" >
    <!--main-->
    <div class="tab-pane fade show active" role='tabpanel' id="pedelAA_result_main">
         <h3>summary table</h3>
{summary_table}
         <h3>Detail</h3>
{middle}
        <br>Nucleotide tally: A={A}, T={T},G={G}, C={C}.</div>
    <!--sub-->
    <div class="tab-pane fade" role='tabpanel'  id="pedelAA_result_sub">
         <h3>Sub-library statistics</h3>
{sub_table}</div>
    <!--graph-->
    <div class="tab-pane fade" role='tabpanel' id="pedelAA_result_graph">
        <div class="form-check" id="plotoptdiv">
            <label class="form-check-inline">
                <input type="radio" name="plotopt" value="1">V<sub>x1</sub>
            </label>
            <label class="form-check-inline">
                <input type="radio" name="plotopt" value="2">V<sub>x2</sub>
            </label>
            <label class="form-check-inline">
                <input type="radio" name="plotopt" value="3">R<sub>x</sub>
            </label>
            <label class="form-check-inline">
                <input type="radio" name="plotopt" value="4">L<sub>x</sub>
            </label>
            <label class="form-check-inline">
                <input type="radio" name="plotopt" value="5">C<sub>x</sub>
            </label>
            <label class="form-check-inline">
                <input type="radio" name="plotopt" value="7">L<sub>x</sub> &#x2212; C<sub>x</sub>
            </label>
            <label class="form-check-inline">
                <input type="radio" name="plotopt" value="0" checked="checked">Combined</label>&#xA0;&#xA0;&#xA0;y axis:
            <input type="checkbox" class="switch"
            id="pedelAA_plot_log" data-off-text="lin" data-on-text="log" data-on-color="warning"
            data-off-color="success" size="small">
        </div>
        <div id="plot_pedelAA_stats"></div>
    </div>
    <!--matrix-->
    <div class="tab-pane fade" role='tabpanel' id="pedelAA_result_matrix">
         <h3>Normalized and scaled nucleotide matrix</h3>
{matrix}</div>
</div>