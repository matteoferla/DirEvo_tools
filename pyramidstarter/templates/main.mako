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
<p>Choose your desired tool to improve cloning, mutagenesis, and library construction.</p>
<div class="card-columns">
    <% elements = (("main/mutantprimers","Primers — Mutant primers","Multiple mutagenic primer design for a desired input sequence."),
                  ("main/deepscan","Primers — Deepscan","Multiple mutagenic primer design to exhaustively scan an entire input sequence (<i>e.g.</i> for alanine scanning)."),
                  ("main/mutantcaller","epPCR — Mutantcaller","Analyse epPCR sequencing files to identify and list point mutations."),
                  ("main/mutanalyst","epPCR — Mutantanalyst","Determine the bias of the submitted sequences for a submitted epPCR library."),
                  ("main/pedel","epPCR — Pedel","Determine diversity of point mutations within an epPCR library."),
                  ("main/pedel","epPCR — PedelAA","Given a sequence, mutational spectrum and mutational load, it will say how redundant is the library from an amino acid point of view."),
                  ("main/probably","epPCR — Chances","Determine the rough probability of having a desired point mutation in a library."),
                  ("main/silico","epPCR — Generator","Create random sequences with mutations based on a mutational load and bias."),
                  ("main/glue","Glue — Glue","Determine how well a library of randomised sequences covers its potential sequence complexity."),
                  ("main/glue","Glue — GlueIT","Calculate the completeness of a library mutated at 1–6 codons."),
                  ("main/driver","Driver","Calculates the probability of cross-over events"),
                  ("main/QCC","QQC calculator","Determine the diversity of a library randomised at a single codon from a single sequencing file with the quick quality control method."),
                  ("main/landscape","Landscape","Determine the mutational landscape of a protein from a Rosetta pmut_scan output."),
                  ("main/codon_autopop-up","Codon helper","A tool to help pick the ideal degenerate codons for site-saturation mutagenesis and library construction."),
                  )
    %>
    % for link, enboldened, text in elements:
        <div class="card">
            <div onclick="location.href='${link}';" style="cursor: pointer;">
                <div class="card-header">${enboldened}</div>
                <div class="card-body">${text}</div>

            </div>
        </div>
    % endfor
</div>

<br>This is a revamp and expansion of the old server by Wayne Patrick and
Andrew Firth found <a href="http://guinevere.otago.ac.nz/aef/STATS/" target="_blank">Here</a>.