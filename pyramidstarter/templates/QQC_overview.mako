<p>Site saturation mutagenesis uses primers with a degenerate codon to scramble
    a single residue. Quick-quality control (QQC) is a way to determine extent
    of randomisation by sequencing the pool of plasmids, measuring the peaks
    and calculating the deviation from an ideal mix (<a href="http://www.nature.com/articles/srep10654"
                                                        target="_blank"><span data-toggle="tooltip" data-placement="top"
                                                                              title="Acevedo-Rocha, CG, Reetz, MT, Nov, Y., (2015). Economical analysis of saturation mutagenesis experiments. Sci. Rep. 5:10654">Acevedo-Rocha <i>et al.</i>, 2015 <i
            class="fas fa-external-link" aria-hidden="true"></i></span></a>).</p>
<p>This tool performs automatically the peak measurements, Q-value calculations
    and expected amino acid proportions. In the case of sequences mutated with
    multiple codons a rough estimate of the contributions of each is obtained
    by optimining the function:</p>
<div class="d-flex py-2">
    <div align="center" class="px-4">
        \(\min_{\boldsymbol{x} \in{\Bbb{N}}} \sum\limits_{i=1; j=1}^{4; 3} \left|{\sum\limits_{k=1}^{n} d_k x_{ijk} h_{ijk} - m_{ij}}\right|\)
    </div>
    <div>Where <i><b>x</b></i> is a scaling factor (4x3xN tensor) of the deviation
    from expected, <i><b>m</b></i>
    is the empirical proportions of bases (4x3
    matrix), <i><b>d</b></i> is the proportions of the primers (N dimension vector)
    and <i><b>h</b></i> is the ideal proportionl of bases in each primer (4x3xN
    tensor). </div>
</div>
<p>This approach therefore tries to balance the primers so to minimise
    the deviation from the ideal primer mix. The usage of the ideal primer
    mix is unfortunate, but is the only way to tackle the problem of deconvoluting
    the primers.</p>