<%page args="page"/>
<p>PEDEL-AA is an extension to amino acid sequences of the original
    nucleotide version of PEDEL (see links to publications and
    <a href="/static/pedelAA_math_notes.pdf">mathematics notes</a> from the statistics
    <a href="/">home</a> page). Due to the more complex problem
    of estimating diversity and completeness at the amino acid level (as
    opposed to nucleotides and codons), there are some major differences
    in the algorithms and a few extra approximations. A brief description
    of the procedure follows.</p>
<p>First, to recapitulate the nucleotide version of PEDEL: As discussed
    in the <a href="/static/pedelAA_math_notes.pdf">mathematics notes</a>, for the nucleotide
    version, if the input library is conceptually divided into
    sub-libraries Lx (x=0,1,2,...) where the sub-library Lx comprises all
    variants in the library with exactly x nucleotide substitutions, then
    the PEDEL scenario divides into two regions:

<ol>

    <li> where Lx is large compared with Vx (the number of possible
        variants with exactly x substitutions) then Cx (the expected number
        of distinct sequences in Lx) is approximately equal to Vx, and
    </li>

    <li> where Lx is small compared with Vx, then Cx is approximately
        equal to Lx.
    </li>

</ol>
<p>
    In the transition region (where Lx ~ Vx) we can calculate Cx with
    the formula Cx ~ Vx(1-exp(-Lx/Vx)). This is based on the assumption
    that all variants in Vx are equiprobable, so the mean number of
    occurrences in the sub-library Lx of each variant in Vx is Lx/Vx and,
    assuming Poisson statistics, the probability that any given variant is
    present in the sub-library is 1-exp(-Lx/Vx), so the expected number of
    distinct variants present in the sub-library is Cx ~
    Vx(1-exp(-Lx/Vx)).</p>
<p>In the more complex scenario presented in PEDEL-AA, the assumption of
    equiprobable variants breaks down for two reasons: (i) we have
    introduced a full 4 x 4 nucleotide substitution matrix (in particular
    the transition:transversion ratio is not assumed to be unity), and
    (ii) even if nucleotide substitutions were equiprobable, the
    corresponding amino acid substitutions are not. However we may still
    borrow some concepts from the equiprobable nucleotide version of PEDEL
    - namely, (1) when Lx is small compared with Vx, then Cx is
    approximately equal to Lx, and (2) when Lx is large compared with Vx
    then Cx is approximately equal to Vx. However these concepts need
    some refining, as follows.</p>

<ol>

    <li> Instead of x counting the number of nucleotide substitutions, we
        now let x count the number of amino acid substitutions
        (i.e. non-synonymous, non-stop codon, substitutions). Note that the
        substitution rate on the PEDEL-AA input form is the mean number
        of <i>nucleotide</i> substitutions, <i>nsubst</i>, per variant but,
        using this, the programme calculates the expected mean number of
        nonsynonymous amino acid substitutions per variant. The probability
        distribution, P(x_nt), of the number of nucleotide substitutions,
        x_nt, per variant may be assumed to follow
        the <a href=pedelpcrdist.html>PCR distribution</a> (with
        mean <i>nsubst</i>, and the extra parameters <i>ncycles</i>
        and <i>eff</i>, respectively the number of PCR cycles and the PCR
        <a href=/cgi-bin/aef/PCReff.pl>efficiency</a>). Separate statistics
        are also calculated assuming that the number of nucleotide
        substitutions per variant follows a Poisson distribution (with the
        single parameter <i>nsubst</i>), and these results may be used if the
        PCR <i>ncycles</i> and <i>eff</i> parameters are unknown.
    </li>
    <p>
        The probabilities of variants being truncated (i.e. containing
        introduced stop codons) are then subtracted from the P(x_nt)
        distributions. Clearly this is an increasing function of x_nt and, by
        x_nt = 100, typically less than 0.6% of variants are stop-codon free.
        Note that the P(x_nt) will no longer sum up to unity; instead (after
        discarding indel-containing variants) they sum up
        to <i>L_eff</i> / <i>L_tot</i>, where <i>L_eff</i> is the 'effective'
        library size (i.e. the number of variants with no indels or stop
        codons) and <i>L_tot</i> is the total library size (albeit again
        excluding variants with indels).</p>
    <p>
        Next, the Poisson and PCR P(x_nt) distributions are redistributed into
        amino acid P(x_aa) distributions. First the mean number, <i>frac</i>,
        of nonsynonymous amino acid substitutions per nucleotide substitution
        (given that the nucleotide substitution doesn't produce a stop codon)
        is calculated. Typically <i>frac</i> ~ 2/3. For each x_nt, the
        number of nonsynonymous amino acid substitutions resulting from
        exactly x_nt nucleotide substitutions is assumed to follow a binomial
        distribution, B(x_nt,<i>frac</i>) (i.e. x_nt 'trials'; probability of
        'success' per 'trial' = <i>frac</i>). Summing up the binomial
        distributions, each weighted by P(x_nt), for x_nt = 0,1,2,...,100
        gives the amino acid Poisson and PCR P(x_aa) distributions. Of
        course, Sum_{x_nt} P(x_nt) = Sum_{x_aa} P(x_aa) = <i>L_eff</i>
        / <i>L_tot</i>. The Poisson and PCR amino acid sub-library sizes, Lx,
        are given by P(x_aa) x <i>L_tot</i>.</p>
    <p>
        All these estimates rely on the mean number of nucleotide
        substitutions per variant, <i>nsubst</i>, being relatively small
        compared with the number of codons in the sequence, so that multiple
        substitutions in the same codon are not very common. In practice, we
        limit <i>nsubst</i> <= 0.1 x input sequence length (in
        nucleotides). In fact, for the Poisson case, we can calculate L0, L1
        and L2 exactly (a sum over all possible variants with exactly 0, 1 or
        2 amino acid substitutions, multiplied by their probabilities given by
        the input nucleotide substitution matrix and <i>nsubst</i>, multiplied
        by <i>L_tot</i>). These calculations agree very well with the 'sum of
        binomial distributions' method. For example, for the library
        presented in Volles & Lansbury (2005), we have
    <pre>
'exact'       'binomial sum'
L0     3.763e+05         3.861e+05
L1     8.174e+05         8.205e+05
L2     8.795e+05         8.717e+05
</pre>
    </li>

    <li> Two estimates of Vx are calculated. The first, Vx_1, is an
        estimate of the number of 'common' variants with exactly x amino acid
        substitutions - namely those variants where each substituted amino
        acid is accessible by just a single nucleotide substitution in the
        respective codon. The second, Vx_2, is the total number of possible
        amino acid variants with exactly x amino acid substitutions. Although
        most variants in a sub-library will be of type Vx_1, variants of type
        Vx_2 may contribute significantly to the total number of distinct
        variants Cx when the sub-library size Lx is large compared with the
        number of variants Vx_1. When the sub-library size Lx is small
        compared with the number of variants Vx_1, nearly every variant in Lx
        is distinct (i.e. Cx ~ Lx) and it doesn't matter whether these
        variants are of type Vx_1 or Vx_2.
    </li>

    <ul>

        <li>Vx_2 is given by C(N,x) 19^x, where C(N,x) is the combinatorial
            function, i.e. C(N,x) = N!/[x!(N-x)!], and N is the length of
            the input sequence in codons. (Cf equation (5) of the
            <a href="/static/pedelAA_math_notes.pdf">mathematical notes</a> for the nucleotide
            version of PEDEL.)
        </li>

        <li>We estimate Vx_1 with the formula C(N,x) A^x, where A is the
            mean number of non-synonymous amino acid substitutions
            accessible by a single nucleotide substitution, for the input
            sequence (the value of A is given on the results page).
        </li>

    </ul>

    Calculation of A: For each codon, i, in the parent sequence, the
    number of non-synonymous, non-stop codon, amino acid substitutions Ai,
    i=1,...,N (N = parent sequence length in codons) accessible by a
    single nucleotide substitution is calculated. Such substitutions are
    accessible with similar probability (albeit varying by a factor of ~3
    for a typical transition:transversion ratio) and much higher
    probability than amino acid substitutions only accessible via 2 or 3
    nucleotide substitutions in the same codon (except in the case of a
    short parent sequence and/or high mutation rate). The Ai are averaged
    (geometric mean) over the sequence to give the parameter A = (A1 x A2
    x ... x An)^(1/N). A is typically around 5.8.</li>

    <li> When Lx << Vx then Cx ~ Lx. For equiprobable variants this
        approximation is good to 5% for Lx < 0.1 Vx (see the mathematical
        <a href=/static/notes.pdf>notes</a> on the nucleotide version of PEDEL).
        For PEDEL-AA, we use this approximation when Lx < 0.1 Vx_1 (the number
        of 'easy-to-reach' variants) or more rigorously, and optionally, when
        Rx < 0.1, where Rx is the mean frequency of the most common variant in
        the sub-library Lx (see <a data-toggle="modal" data-target="#pedelAA_exact_modal">note on Rx
            statistic</a> for details). Lx < 0.1 Vx_1 is usually true for x
        >= 3 and almost always true for x >= 4. For example for N >= 40
        codons, V3_1 >= ~5.8^3 x C(40,3) = 1.9 x 10^6 and V4_1 >= ~5.8^4 x
        C(40,4) = 1.0 x 10^8, while for N >= 100 codons, V3_1 >= ~5.8^3 x
        C(100,3) = 3.1 x 10^7 and V4_1 >= ~5.8^4 x C(100,4) = 4.4 x 10^9; and
        remember these Vx_1 sizes only need to be compared with the relevant
        sub-library size L3 or L4, not the whole library size. In the Cx ~ Lx
        region, whether a particular variant is of type Vx_1 or type Vx_2 is
        irrelevant - either way it will (almost) always be a distinct variant
        in the library.
    </li>

    <li> For x = 0, 1 and 2, we calculate the expected number of distinct
        variants, Cx, precisely. This calculation includes variants with
        multiple nucleotide substitutions in the same codon (i.e. both Vx_1
        and Vx_2).

        The total number of each of the 64 codon types in the input sequence
        is calculated. The 64 x 20 matrix of probabilities for each codon
        type mutating to each amino acid type is calculated using the input
        nucleotide substitution matrix and the input substitution rate.

        For x = 0, 1 and 2 there are, respectively Vx_2 = 1, 19N and
        361N(N-1)/2 total possible variants (i.e. N!/[x!(N-x)!] 19^x, where N
        is the length of the input sequence in codons). The probability of
        the input sequence mutating to each of these possible variants is
        calculated and renormalized by the respective probability sum P0, P1
        or P2 (where Px = Sum_{v_i in Vx_2} P(v_i)) to give the normalized
        probabilities Pn(v_i) of the different variants within the respective
        sub-libraries Lx, rather than within the whole library. The
        probability of a particular variant v_i being present in the relevant
        sub-library Lx is given by 1 - exp(-Pn(v_i) x Lx). These
        probabilities are quickly summed over all possible variants using the
        codon counts. Computationally, this is very fast for x = 0, 1 and 2,
        but can take a few minutes for x = 3; hence the 'exact' calculation is
        not used on the webserver for x >= 3. The sizes of the sub-libraries
        Lx are determined separately for the Poisson and PCR distributions as
        described above, thus resulting in separate Cx estimates for the
        different distributions.
    </li>

    <li> Ideally, for x >= 3, we will enter the Cx ~ Lx region. In this
        case all the individual Cx estimates, and the estimated total number
        of distinct variants in the library C = C0 + C1 + C2 + ..., will be
        fairly good. A warning is printed in the 'notes' column of the output
        table of sub-library statistics if there are any x >= 3 values for
        which the Cx ~ Lx approximation may not apply, in which case Cx is
        estimated with the formula Cx ~ Vx_1(1-exp(-Lx/Vx_1)) (i.e. ignoring,
        in these particular sub-libraries, any variants of type Vx_2). This
        formula is not very accurate and may result in an overestimate
        (because the Vx_1 are not equiprobable - the higher probability amino
        acid substitutions [e.g. those accessible by transitions, or via more
        than one possible nucleotide substitution] will be over-represented at
        the expense of other amino acid substitutions) or an underestimate
        (since the Vx_2 variants are ignored). These effects can be quite a
        large (e.g. if some Vx_1 substitutions are 3 times more likely than
        others, and the Lx ~ Vx_1 turnover occurs at x ~ 3, then the most
        common three-amino acid substitutions will be 3^3 = 27 times more
        likely than the rarest three-amino acid substitutions).
    </li>

</ol>
<p>
    <b>Note that the introduced stop codon and indel statistics and graphs
        are exact calculations (based on the input substitution, indel and
        nucleotide matrix parameters) and do not use any of the above
        approximations (except Poisson statistics). The above approximations
        are only used for the library completeness statistics.</b></p>
<h4>Comparison with Volles & Lansbury (2005) Monte Carlo
    simulation.</h4>
<table class="table table-striped">
    <tr>
        <th>Property</th>
        <th align="center">Volles & Lansbury</th>
        <th colspan="2" align="center">Firth & Patrick</th>
    </tr>
    <tr>
        <td align="center">-</td>
        <td align="center">-</td>
        <td align="center">Poisson</td>
        <td align="center">PCR</td>
    </tr>
    <tr>
        <td align="left">Truncations (%)</td>
        <td align="center">15</td>
        <td align="center" colspan="2">15.6</td>
    </tr>
    <tr>
        <td align="left"># Full-length clones</td>
        <td align="center">3.1 x 10^6</td>
        <td align="center" colspan="2">3.18 x 10^6</td>
    </tr>
    <tr>
        <td align="left">Protein mutation freq. per aa</td>
        <td align="center">0.016</td>
        <td align="center" colspan="2">0.0160</td>
    </tr>
    <tr>
        <td align="left">Mean # mutations per protein</td>
        <td align="center">2.1</td>
        <td align="center" colspan="2">2.12</td>
    </tr>
    <tr>
        <td align="left">Unmutated sequences (%)*</td>
        <td align="center">14</td>
        <td align="center">10.1</td>
        <td align="center">14.0</td>
    </tr>
    <tr>
        <td align="left"><b># of unique proteins</b></td>
        <td align="center"><b>1.3 x 10^6</b></td>
        <td align="center"><b>1.32 x 10^6</b></td>
        <td align="center"><b>1.29 x 10^6</b></td>
    </tr>
    <tr>
        <td align="left"># of unique point mutations</td>
        <td align="center">1990</td>
        <td align="center" colspan="2">1989</td>
    </tr>
    <tr>
        <td align="left"># of unique single point mutations</td>
        <td align="center">1566</td>
        <td align="center">1618</td>
        <td align="center">1618</td>
    </tr>
</table>
<br>

* Relative to the total library size (i.e. including truncated variants).


<h4>References</h4>

<li>Volles M.J., Lansbury P.T. Jr. (2005). A computer program for the
    estimation of protein and nucleic acid sequence diversity in random
    point mutagenesis libraries, <i>Nucleic Acids Res.</i>
    <b>33</b>, 3667-3677.
</li>