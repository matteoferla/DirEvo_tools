<h3>Results</h3>
<b>Remember:</b> a decrease in Gibbs energy of the system is stabilising,
an increase is destabilising.
<br>
<br>
<div>
    <ul class="nav nav-tabs" id="myTabs" role="tablist">
        <li class="nav-item" role="presentation"><a class="nav-link active" data-toggle="tab" href="#land_results_table"
                                                    role="tab">Table</a>
        </li>
        <li class="nav-item" role="presentation"><a class="nav-link" data-toggle="tab" href="#land_results_graph"
                                                    role="tab">Heatmaps</a>
        </li>
        <li class="nav-item" role="presentation"><a class="nav-link" data-toggle="tab" href="#land_results_distro"
                                                    role="tab">Distribution</a>
        </li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane fade show active" id="land_results_table" role="tabpanel">{table}</div>
        <div class="tab-pane fade" id="land_results_graph" role="tabpanel">
            <h4>Heatmap</h4>
            REU greater or lower than &#xB1;20 have been made to twenty. Don&apos;t
            trust proline mutations.
            <div class="dropdown">
                <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown"
                        aria-haspopup="true" aria-expanded="true" id="land_heat_chosen_label">Dataset <span
                        class="caret"></span>
                </button>
                <ul class="dropdown-menu" aria-labelledby="land_heat_chosen_label" id="land_heat_options">{heat_opt}
                </ul>
            </div>
            <div id="land_heatmap"></div>
        </div>
        <div class="tab-pane fade in active" id="land_results_distro" role="tabpanel">
            <h4>Distribution of mutational effects</h4>
            <div class="dropdown">
                <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown"
                        aria-haspopup="true" aria-expanded="true" id="land_distro_chosen_label">Dataset <span
                        class="caret"></span>
                </button>
                <ul class="dropdown-menu" aria-labelledby="land_distro_chosen_label" id="land_distro_options">
                    {distro_opt}
                </ul>
            </div>
            <p>REU greater or lower than &#xB1;20 have been made to twenty. Note that an increase in &#x2206;Gibbs of 20 kcal/mol for a protein with
                a very high melting temperature (&gt;60&#xB0;C) might be okay at 37&#xB0;C.</p>
            <ul>
                <li>Number of strongly deleterious mutations (&#x2206;G &gt;20 REU): <span id="land_distro_dead"></span></li>
                <li>Number of deleterious mutations (20 REU &gt; &#x2206;G &gt;1 REU): <span id="land_distro_neg"></span></li>
                <li>Number of neutral mutations (-1 REU &lt; &#x2206;G &lt; 1 REU): <span id="land_distro_neutro"></span></li>
                <li>Number of positive mutations (&#x2206;G &lt; -1 REU): <span id="land_distro_pos"></span></li>
            </ul>
            <div id="land_distro"></div>
        </div>
    </div>
</div>