<%page args="mutants"/>
<div class='row pt-1'>
    <div class='col-lg-12'>
        <p>There are ${len(mutants)} coding mutations: (${' '.join([x[1] for x in mutants])})</p>
    </div>
</div>
<h3>Full mutations</h3>
<div class='row'>
    %for i in range(len(mutants)):
        <div class='col-lg-6'>&nbsp;
            <div id='MC_mutant_${i}'>
            </div>
        </div>
    %endfor
</div>

<h3>Mixed-peak mutations</h3>

<div class="row">
    <p> Plot to verify that the noise across the sequencing run is low. A sustained increase in noise past a specific nucleotide likely indicates a frameshift.</p>
    <div class='col-lg-12'>&nbsp;
        <div id='MC_noise'></div>
    </div>

    %for i in range(len(heteromutants)):
        <div class='col-lg-6'>&nbsp;<div id='MC_heteromutant_${i}'></div></div>
    %endfor
</div>

<h3>Protein</h3>
<div id='MC_viewer'>&nbsp;</div>