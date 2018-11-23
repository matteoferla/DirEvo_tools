<p>The 'Lx < 0.1 Vx_1' criterion for deciding when to use
    the 'Cx ~ Lx'
    approximation is sometimes inaccurate, and can be refined as
    follows.</p>
<p>First consider a single nucleotide substitution in a single codon. There
    are 9 possible mutated codons. An amino acid mutation that can only
    be coded by a single codon out of the 9 and that requires a
    transversion, has only a 1 in 15 probability (assuming a
    transition:transversion ratio of 3), since if p is the probability of
    a transversion, then 3p is the probability of a transition, and the
    total probability of the 9 mutated codons is 6(p) + 3(3p) = 15p.</p>
<p>For example, if the parent codon is GGG (Gly), then the 9
    single-nucleotide-substitution codons are</p>
<table class="table table-striped">
    <tr>
        <th>codon</th>
        <th>amino acid</th>
        <th>relative probability</th>
    </tr>
    <tr>
        <td>AGG</td>
        <td>Arg</td>
        <td>3p</td>
    </tr>
    <tr>
        <td>CGG</td>
        <td>Arg</td>
        <td>p</td>
    </tr>
    <tr>
        <td>TGG</td>
        <td>Trp</td>
        <td>p</td>
    </tr>
    <tr>
        <td>GAG</td>
        <td>Glu</td>
        <td>3p</td>
    </tr>
    <tr>
        <td>GCG</td>
        <td>Ala</td>
        <td>p</td>
    </tr>
    <tr>
        <td>GCG</td>
        <td>Ala</td>
        <td>p</td>
    </tr>
    <tr>
        <td>GTG</td>
        <td>Val</td>
        <td>p</td>
    </tr>
    <tr>
        <td>GGA</td>
        <td>Gly</td>
        <td>3p</td>
    </tr>
    <tr>
        <td>GGC</td>
        <td>Gly</td>
        <td>p</td>
    </tr>
    <tr>
        <td>GGT</td>
        <td>Gly</td>
        <td>p</td>
    </tr>
</table>
<br/>

<table table="table table-striped">
    <tr>
        <th>AA</th>
        <th>Probabilities given the <i>codon</i> mutates</th>
        <th>Probabilities given the <i>amino acid</i> mutates</th>
    </tr>
    <tr>
        <td>Gly</td>
        <td>5/15</td>
        <td>(wild-type)</td>
    </tr>
    <tr>
        <td>Arg</td>
        <td>4/15</td>
        <td>4/10</td>
    </tr>
    <tr>
        <td>Glu</td>
        <td>3/15</td>
        <td>3/10</td>
    </tr>
    <tr>
        <td>Trp</td>
        <td>1/15</td>
        <td>1/10</td>
    </tr>
    <tr>
        <td>Ala</td>
        <td>1/15</td>
        <td>1/10</td>
    </tr>
    <tr>
        <td>Val</td>
        <td>1/15</td>
        <td>1/10</td>
    </tr>
</table>

<p>The 'Lx < 0.1 Vx_1' criterion assumes that all of the
    single-nucleotide-substitution non-synonymous amino acid substitutions
    are equiprobable - i.e. 1 in 5 in the above example, but in general
    represented by the reciprocal of the 'A' factor described in
    the above section,
    where typically A ~ 5.8; whereas, in fact, the most common
    single-nucleotide-substitution amino acid substitution (GGG -> Arg) is
    4 x as likely as the rarest (GGG -> Trp or Ala or Val). In cases
    where some nucleotide substitutions (as defined by the 4 x 4
    nucleotide substitution matrix) are particularly rare, the probability
    difference between the rarest and the most common
    single-nucleotide-substitution amino acid substitutions at a given
    site can be much greater.</p>
<p>The 'Lx < 0.1 Vx_1' criterion for being in the 'Cx ~ Lx' region
    is
    basically to make sure that there are enough variants in Vx to
    'absorb' all Lx sub-library members so that (within a small error) at
    most one sub-library member is equal to any given variant in Vx. In
    practice, it doesn't matter what the probability of the rarest
    variants is. What matters for the 'Cx ~ Lx' approximation is that the
    mean frequency in Lx of the most common variant is < 0.1. In fact the
    mean frequency of the most common variant in Lx, which we denote by
    Rx, is easy to calculate for x = 0, 1, 2, ..., 20, ..., and is shown
    in the PEDEL-AA output table of sub-library statistics.</p>
<p>Using these Rx values, the 'Lx < 0.1 Vx_1' criterion would be replaced
    with the criterion 'Rx < 0.1'. In practice this means that if, in the
    table of sub-library statistics, there are Rx values > 0.1, for which
    the 'Cx ~ Lx' approximation has been used (i.e. x >= 3 and Lx < 0.1
    Vx_1), then the particular corresponding Cx values may be
    overestimates. A warning and html link are given in the table of
    sub-library statistics whenever this occurs.</p>