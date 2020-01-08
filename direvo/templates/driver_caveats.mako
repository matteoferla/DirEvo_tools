<p>DRIVeR uses a generic Poisson model of crossover probabilities and positions.
    There are a few caveats that you should be aware of:</p>
<ul>
    <li>Remember to use GLUE, not DRIVeR, when all daughter sequences are equally
        likely (e.g. synthetic shuffling and SISDC).</li>
    <li>In the current implementation of DRIVeR, you can not have more than two
        different parent sequences.</li>
    <li>As with PEDEL, there is the potential for amplification bias (see PEDEL
        caveats)</li>
    <li>The two parent sequences are assumed to be highly homologous. For parent
        sequences that are homologous at the amino acid level but divergent at
        the nucleotide level, crossovers preferentially occur in regions with greater
        nucleotide sequence similarity. This bias is not reflected in the DRIVeR
        model which, nevertheless, provides a useful upper bound on library diversity.
        It has been suggested (Moore G.L., Maranas C.D., 2002, <i>Nuc. Acids. Res.</i>, <b>30</b>,
        2407) that one way to reduce this bias is to synthesize new parent sequences
        that maintain the amino acid sequences of the original parents, but have
        greater similarity at the level of nucleotides. In the case of shuffling
        two epPCR-generated clones, large-scale sequence dissimilarity will not
        be an issue.</li>
    <li>Any biases in library construction will decrease the actual number of
        distinct variants represented in the library. In such cases, DRIVeR provides
        the user with a useful upper bound on the diversity present in the library.</li>
</ul>
<p>Please refer to Patrick W. M., Firth A. E., Blackburn J.M., 2003, User-friendly
    algorithms for estimating completeness and diversity in randomized protein-encoding
    libraries, <i>Protein Eng.</i>, <b>16</b>, 451-457 for further discussion
    of DRIVeR.</p>
<p>A good review of the sources of bias in recombination and other directed
    evolution protocols can be found in Neylon C., 2004, Chemical and biochemical
    strategies for the randomization of protein encoding DNA sequences: library
    construction methods for directed evolution, <i>Nucleic Acids Res.</i>, <b>32</b>,
    1448-1459.</p>