<%page args="page"/>
<div class="card">
  <div class="card-body">
    <h1 class="card-title">Glossary</h1>
    <h3 class="card-subtitle mb-2 text-muted">Commonly used technical words within this site</h3>
    <div class="row">
            <ul class="list-group">
                % for enboldened, text in page.terms.values():
                    <li class="list-group-item"><b>${enboldened}</b> ${text|n}</li>
                % endfor
            </ul>
        </div>
  </div>
</div>
<div class="card">
  <div class="card-body">
    <h1 class="card-title">FAQ</h1>
    <h3 class="card-subtitle mb-2 text-muted">Answers to question you might have.</h3>
    <p class="card-text">If still troubled why not leave a comment? <button class="btn btn-info" onclick="$('#comment_modal').modal('show');" style="cursor:pointer">Leave comment</button></p>
    <div class="row">
            <ul class="list-group">
                <li class="list-group-item" id="library">
                    <h3>What makes a good library?</h3>
                    <p>A good library for directed evolution is a diverse targetted one.<br/>
                        The target of the library can focus from a few residues to a whole region: the former is done with degenerate primers, while the latter is done by error-prone PCR. Although some combinations of the two are sometimes done.</p>
                    <p>In terms of degenerate primers (or more correctly primers with degenerate nucleotides, also called QuickChange primers after the original kit), the app <a href="/main/glue">GlueIT</a> can help in determining which degenerate codons to use and how many to reasonably alter,
                        while the app <a href="/main/mutantprimers">MutantPrimers</a> can help by designing the primers. Unfortunately, the annealing temperature of the PCR reaction plays a large part, so the app <a href="/main/glue">QCCC</a> was made to dermine the extent of randomisation.</p>
                    <p>In terms of error-prone PCR, the starting template and nucleotide balance can be altered to achieve different ${page.term_helper('load','mutational loads')|n} and ${page.term_helper('bias','biases')|n}.<br/>
                        First, the amount of starting template controls the average mutational load of the library.
                        If this is low, there will be a large redundancy in the library, including a significant fraction of wild type sequences, but
                        if this too high, the library will be dominated by deleterious mutations masking beneficial ones.<br/>
                        Second, the PCR method employed has a profound effect on the resulting ${page.term_helper('spectrum','mutational spectrum')|n}, which the more biases it is the less diversity is present.
                    </p>
                </li>
                <li class="list-group-item" id="target">
                    <h3>How many mutations should I have?</h3>
                    <p>Ideally, high enough that you have little redundancy, while low enough that you have most single amino acid variants accessible via a single mutation, which is somewhere around 5 mutations per kb (see <a href="/main/pedel">PedelAA</a> for your specific case).</p>
                    <p>The thing to remember is that the number of mutations per sequence follows a Poisson <i>distribution</i>: if you had an <i>average</i> mutational load of 1.0, 36% of your library will have zero mutations and 36% with a single nucleotide mutations as opposed to all sequences with a single mutation.
                        Also, two thirds of nucleotide mutation are ${page.term_helper('missense','missense mutations')|n}, so a load of 1 mutation per kb is just a bit less than half wild type at the amino acid level.</p>
                    <p>There are several papers that explore the fraction of mutations that are beneficial, neutral or deleterious.
                        It depends on the protein and whether one is looking at it from structural (&Delta;&Delta;G) or a catalytic (&Delta;&Delta;G&Dagger;) point of view. But roughly, 1-10% are beneficial, 10-20% are deleterious and the rest neutral (to see an example or calculate on your own protein see <a href="/main/landscape">landscape app</a>).
                        Therefore for a protein, for every 1.3 mutations that the load increases, the fraction of non-dead protein decreases by 20% (or whatever the value is), so at an average 5 nucleotides mutations 57% of the library is dead (0.8^(5*0.7)). But the rest are neutral, or neutral with beneficial mutations!</p>
                </li>
                <li class="list-group-item" id="epPCR">
                    <h3>What error-prone PCR method should I use?</h3>
                    <p>It depends on the desired mutational load, on the importance of mutational biases... and how much time you are willing to troubleshoot.</p>
                    <p>The simplest and cleanest method is using the error-prone enzyme Mutazyme (Promega GeneMorph kit; technically <i>Pfu</i> PolB-<i>Sso</i> 7d D215A D473A),
                        which has a low error rate (about 0.9/doubling/kb), but is less biases and is less likely to give a smear or no PCR products on an agarose gel (although it is nowhere as robust as say a normal Q5 reaction). </p>
                    <p>Another method is manganese mutagenesis, where up to 5 mM manganese are added to a Taq reaction, which results in a high error rate, but the product is highly biases towards adenine mutations,
                        so is often counterbalanced by using unequal NTPs.</p>
                    <p>A third method is using nucleotide analogues that increase mutations, such as 8-oxoGTP or dPTP (Jena Bioscience kit), which result in a very high mutational load.</p>
                    <p>Unfortunately, the latter two strongly affect PCR yields, which means that one cannot mix and match, say manganese with Mutazyme.
                        Similarly, with mutation shuffling methods there is a sensitive PCR step, but neither DNA shuffling or StEP work with epPCR to a usable/satisfactory degree.</p>
                    <p>A recent development is getting a synthetic library which scan all mutations or similar. These completely circumvent the above issues, but are expensive and require a great deal of study into the detail of the final product to make sure that the limitations don't interfere. For example, in the case of a scanning library, where each variant will have only a single mutation, will not be able to find epistatic cases etc.).</p>
                </li>
                <li class="list-group-item" id="nothing">
                    <h3>I got no mutations...</h3>
                    <p>If you believe it is something wrong with our code, please <a href="http://www.matteoferla.com/email.html">contact us</a>. Here are some pointers:</p>
                    <ul>
                        <li>If the sequences were weird, you have some contaminant during your cloning steps.</li>
                        <li>Was the PCR yield low? a 50 µl reaction should give a yield between 0.5–2,000 ng  (e.g. 20 µl of 20-100 ng/µl).</li>
                        <li>Check the manual or protocol for the method</li>
                        <li>When the manganese stock was made, were the crystals a cool pink? Silly as it sounds, getting manganese and magnesium mixed up is a common mistake.</li>
                        <li>etc.</li>
                    </ul>
                </li>
                <li class="list-group-item" id="Sun">
                    <h3>What about Sun&apos;s PCR distribution?</h3> Due to the fact that the PCR efficiency is not a
                    straightforward parameter
                    to obtain and can be strongly misleading it was not ported to this project to avoid beguiling the user with false data.
                    For more see: <a href="http://blog.matteoferla.com/2018/08/pcr-distribution.html">Matteo&apos;s
                    blogpost on PCR distribution <i class="fas fa-external-link" aria-hidden="true"></i></a>
                </li>
                <li class="list-group-item" id="bias">
                    <h3>Is ${page.term_helper('bias','mutational bias')|n} a big deal?</h3>
                    <p>Unfortunately, yes: it both has a strong effect on diversity and is a strong phenomenon.</p>
                    If the mutational spectrum greatly differs from an equiprobably scenario, the diversity is greatly reduced.
                    Some methods of introducing random mutations favour certain mutations so much
                    that certain desired amino acid changes, such as a glutamaine to glutamate, becomes very unlikely.

                    For more see: <a href="https://blog.matteoferla.com/2018/01/gc-transversions-aka-english-scrabble.html">Matteo&apos;s
                    blogpost on mutational biases <i class="fas fa-external-link" aria-hidden="true"></i></a>
                </li>
            </ul>
        </div>
  </div>
</div>


