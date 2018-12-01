<%page args="page"/>
<div class="card">
  <div class="card-body">
    <h1 class="card-title">Glossary</h1>
    <h3 class="card-subtitle mb-2 text-muted">Commonly used technical words within this site</h3>
    <div class="row">
            <ul class="list-group">
                % for enboldened, text in page.terms.values():
                    <il class="list-group-item"><b>${enboldened}</b> ${text|n}</il>
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
                <il clas="list-group-item">
                    <h3>What makes a good library?</h3>
                    <p>A good library for directed evolution is a diverse targetted one.<br/>
                        The target of the library can focus from a few residues to a whole region: the former is done with degenerate primers, while the latter is done by error-prone PCR. Although some combinations of the two are sometimes done.</p>
                    <p>In terms of degenerate primers (or more correctly primers with degenerate nucleotides, also called QuickChange primers after the original kit), the app <a href="main/glue">GlueIT</a> can help in determining which degenerate codons to use and how many to reasonably alter,
                        while the app <a href="main/mutantprimers">MutantPrimers</a> can help by designing the primers. Unfortunately, the annealing temperature of the PCR reaction plays a large part, so the app <a href="main/glue">QCCC</a> was made to dermine the extent of randomisation.</p>
                    <p>In terms of error-prone PCR, the starting template and nucleotide balance can be altered to achieve different ${page.term_helper('load','mutational loads')|n} and ${page.term_helper('bias','biases')|n}.<br/>
                        First, the amount of starting template controls the average mutational load of the library.
                        If this is low, there will be a large redundancy in the library, including a significant fraction of wild type sequences, but
                        if this too high, the library will be dominated by deleterious mutations masking beneficial ones.<br/>
                        Second, the PCR method employed has a profound effect.
                        Two thirds of nucleotide mutation are ${page.term_helper('missense','missense mutations')|n}.



                        The often cited target value is 5 nucleotide mutations per gene.</p>

                        A combination is sometimes done where degenerate primers are spiked into a epPCR reaction at a low concentration.
                    </p>
                </il>
                <il class="list-group-item">
                    <h3>What error-prone PCR method should I use?</h3>
                    <p>It depends on the desired mutational load, on the importance of mutational biases... and how much time you are willing to troubleshoot.</p>
                    <p>The simplest and cleanest method is using the error-prone enzyme Mutazyme (Promega GeneMorph kit; technically <i>Pfu</i> PolB-<i>Sso</i> 7d D215A D473A),
                        which has a low error rate (about 0.9/doubling/kb), but is less biases and is less likely to give a smear or no PCR products on an agarose gel (although it is nowhere as robust as say a normal Q5 reaction). </p>
                    <p>Another method is manganese mutagenesis, where up to 5 mM manganese are added to a Taq reaction, which results in a high error rate, but the product is highly biases towards adenine mutations,
                        so is often counterbalanced by using unequal NTPs.</p>
                    <p>A third method is using nucleotide analogues that increase mutations, such as 8-oxoGTP or dPTP (Jena Bioscience kit), which result in a very high mutational load.</p>
                    <p>Unfortunately, the latter two strongly affect PCR yields, which means that one cannot mix and match, say manganese with Mutazyme.
                        Similarly, with mutation shuffling methods there is a sensitive PCR step, but neither DNA shuffling or StEP work with epPCR to a usable/satisfactory degree.</p>
                    <p>A recent development is getting a synthetic library which scan all mutations or similar. These completely</p>
                </il>
                <il class="list-group-item">
                    <h3>What about Sun&apos;s PCR distribution?</h3> Due to the fact that the PCR efficiency is not a
                    straightforward parameter
                    to obtain and can be strongly misleading it was not ported to this project to avoid beguiling the user with false data.
                    For more see: <a href="http://blog.matteoferla.com/2018/08/pcr-distribution.html">Matteo&apos;s
                    blogpost on PCR distribution <i class="fas fa-external-link" aria-hidden="true"></i></a>
                </il>
                <il class="list-group-item">
                    <h3>Is ${page.term_helper('bias','mutational bias')|n} a big deal?</h3> Unfortunately, yes.
                    Some methods of introducing random mutations favour certain mutations so much
                    that certain desired amino acid changes, such as a glutamaine to glutamate, becomes very unlikely.
                    For more see: <a href="https://blog.matteoferla.com/2018/01/gc-transversions-aka-english-scrabble.html">Matteo&apos;s
                    blogpost on mutational biases <i class="fas fa-external-link" aria-hidden="true"></i></a>
                </il>
            </ul>
        </div>
  </div>
</div>


