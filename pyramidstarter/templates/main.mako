<div class="page-header">
    <h1>Introduction</h1>
</div>

<h2>Aim</h2>
<p>Engineering better proteins is a multifaceted task. Here you will find
    an assortment of tools that will help you find a better variant at every
    step of the way.</p>
<p>There are many technical terms in protein design and engineering, so if
    you are struggling with terminology do check out <a href="main/glossary">the glossary and FAQ page</a>.</p>
<p></p>
<h1>Applications</h1>
<div class="list-group"><a href="main/mutantprimers" class="list-group-item list-group-item-action"><b>Primers &#x2014; Mutant primers:</b><br>Given
    a sequence and list of desired mutations it will return primers to make each of those mutations.</a>
    <a
            href="main/deepscan" class="list-group-item list-group-item-action"><b>Primers &#x2014; Deepscan:</b>
        <br>Given a sequence and a codon, say GCT for alanine scanning, it will return
        a list of all primers needed to scan the sequence with that mutation</a>
    <a
            href="main/mutantcaller" class="list-group-item list-group-item-action"><b>epPCR&#xA0;&#x2014; Mutantcaller:</b>
        <br>Given a sequence and an ab1 trace it will return all mutations present
        and also list heterozygous sites (say you have a mixed population or you
        pooled two or three variants to cut down on sequencing)</a> <a href="main/mutanalyst"
                                                                       class="list-group-item list-group-item-action"><b>epPCR&#xA0;&#x2014;
        Mutantanalyst:</b><br> Given a sequence and a list of sampled variants, it will say how biased the library
        is.</a>
    <a
            href="main/pedel" class="list-group-item list-group-item-action"><b>epPCR&#xA0;&#x2014; Pedel:</b>
        <br>Given a sequence, mutational spectrum and mutational load, it will say
        how redundant is the library.</a> <a href="main/pedel" class="list-group-item list-group-item-action"><b>epPCR&#xA0;&#x2014;
        PedelAA:</b><br> Given a sequence, mutational spectrum and mutational load, it will say how redundant is the
        library from an amino acid point of view.</a>
    <a
            href="main/probably" class="list-group-item list-group-item-action"><b>epPCR&#xA0;&#x2014; Chances:</b>
        <br>Given a sequence and a desired mutation, it will say what are the chances
        that mutation ought to have been seen.</a> <a href="main/silico" class="list-group-item list-group-item-action"><b>epPCR&#xA0;&#x2014;
        Generator:</b><br> Given a sequence and mutational bias data, it generate mutations.</a>
    <a
            href="main/glue" class="list-group-item list-group-item-action"><b>Glue&#xA0;&#x2014; Glue:</b>
        <br>Calculates how complete a library is from a coupon collectors problem
        standpoint.</a> <a href="main/glue" class="list-group-item list-group-item-action"><b>Glue&#xA0;&#x2014; GlueIT:</b><br> Calculates the
        completeness of a library mutated at 1&#x2013;6 codons.</a>
    <a
            href="main/driver" class="list-group-item list-group-item-action"><b>Driver:</b>
        <br>Calculates the probability of cross-over events</a> <a href="main/QCC"
                                                                   class="list-group-item list-group-item-action"><b>QQC (Quick quality
        control) calculator:</b><br> Given an ab1 file of a sequence pool mutated at a codon, it gives the distribution
        of nucleotides and codons.</a>
    <a
            href="main/landscape" class="list-group-item list-group-item-action"><b>Landscape:</b>
        <br>Given a series of Rosetta pmut_scan outputs it shows the mutational landscape
        of that protein</a>
    <a href="main/codon_autopop-up" class="list-group-item list-group-item-action"><b>Codon helper</b><br> A tool to help you pick
        the best degenerate codons. Also found in any page that requires codons as a sequence.</a>
</div>
<br>This is a revamp and expansion of the old server by Wayne Patrick and
Andrew Firth found <a href="http://guinevere.otago.ac.nz/aef/STATS/" target="_blank">Here</a>.