<p><a href="https://www.ncbi.nlm.nih.gov/pubmed/11564557" target="_blank">&gt;Raillard et al (2001,

    <i>Chem.

        Biol.</i>, <b>8</b>, 891-898) <i class="fas fa-external-link" aria-hidden="true"></i></a>
used
    DNA shuffling to recombine two bacterial triazine hydrolase genes (<i>atzA</i> and <i>triA</i>,
    GenBank accession numbers U55933 and AF312304, respectively). The <i>N</i> =
    1425 nt genes differ at nine nucleotide positions: 250, 274, 375, 650,
    655, 757, 763, 982 and 991. They screened a library of <i>L</i> = 1600 shuffled
    variants. They state that &apos;every variant sequenced had undergone at
    least one and as many as four recombination events&apos;. Thus we estimate
    that the mean number of observable crossovers per daughter sequence is
    around <i>m</i>
= 2. The underlying true number of crossovers per daughter
    sequence is unknown (click <a data-toggle="collapse" href="#driver_discussion">here</a> for
    discussion).</p>
<div class="collapse well" id="driver_discussion">
    <p>Note that, experimentally, crossovers are only observable if they occur
        in a region that will produce a distinct daughter sequence. One crossover
        between a consecutive pair of variable positions will produce the same
        daughter sequence as 3, 5, 7, ... crossovers. Similarly 2, 4, 6, ... crossovers
        produce the same daughter sequence as no crossovers at all. In addition,
        any crossovers occurring between one end of the sequence and the first
        variable position are also unable to be detected by analysis of the daughter
        sequence.</p>
    <p>Typically you will find the mean number of observable crossovers by sequence
        analysis of a sample of daughter sequences. Nonetheless, the underlying
        true number of crossovers is also an important statistic to know - especially
        when you want to try and vary the crossover rate by making adjustments
        to your recombination protocol.</p>
    <p>In DRIVeR, you can choose to enter either the mean number of observable
        crossovers or the true mean number of all crossovers. Either way, DRIVeR
        will also calculate and tell you the other statistic.</p>
    <p>Note also the following:
        <br>The maximum observable crossover rate is (M-1)/2, where M is the number
        of variable positions. If the true crossover rate is very high, then the
        variable positions will be essentially randomly assigned in each daughter
        sequence, and all possible daughters will be essentially equally likely
        (in fact you can use GLUE instead of DRIVeR).</p>
    <p>Since we assume that crossovers cannot occur immediately following a variable
        position (due to the nature of the reassembly reaction), if two variable
        positions are adjacent in the parent sequences, then they will remain linked
        in all daughter sequences and the number of possible daughter sequences
        and maximum observable crossover rate will be reduced accordingly.</p>
</div>
<p>Enter <i>L</i> = 1600, <i>N</i> = 1425, <i>m</i> = 2, and the variable nucleotide
    positions &apos;250 274 375 650 655 757 763 982 991&apos; into the DRIVeR
    form, and click the &apos;observable crossovers&apos; check-box. Select
    the &apos;Calculate for the above parameters&apos; option and click &apos;Calculate&apos;.
    You should get the answer that the expected number of distinct sequences
    in the library is ~164, out of a total of 512 possible daughter sequences,
    and that the true number of crossovers per daughter sequence is ~10 (<i>i.e.</i> about
    one crossover per 140 nt on average). Following the link to &apos;More
    statistics&apos; displays the probabilities of a crossover between each
    pair of consecutive variable positions.</p>
<p>Alternatively, you could have chosen the &apos;Calculate and plot for
    a range of values&apos; option on the base DRIVeR server page. This time
    you get back three plots plus a link to the &apos;Statistics&apos; used
    to draw the plots (useful if you want to find more accurate values than
    you can read off the plots).</p>
<p>The plots can be useful for determining what library size or crossover
    rate you should aim for in order to sample a given fraction of the potential
    diversity. In the above example, if you wanted to sample all, or nearly
    all, of the 512 possible daughter sequences, then you could use the third
    plot (expected number of distinct sequences versus crossover rate and library
    size). In order to sample all 512 possible daughter sequences, you could
    either try to increase the crossover rate <i>m</i> or increase the library
    size <i>L</i>. However, the plot shows that for <i>L</i> = 1600, <i>m</i>
would
    have to be unrealistically large (crossovers every 5 nt, or more) in order
    to sample all 512 possible daughter sequences. With a five-fold increase
    in crossover rate (crossovers every 30 nt or so), there should be around
    ~320 distinct daughter sequences. Alternatively, maintaining the current
    crossover rate, and increasing the library size to 25600, should also result
    in ~320 distinct daughter sequences.</p>