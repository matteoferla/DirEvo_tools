
 <h3>Description</h3>
<p>Deepscan generates a list of partially overlapping QuikChange-based primers
    aimed at constructing mutability landscapes using PCR. It iterates across
    a DNA sequence, codon by codon and generates a primer pair that employs
    the partially overlapping primer pair strategy (<a href="http://nar.oxfordjournals.org/content/43/2/e12.long"
    target="_blank"><span data-toggle="tooltip" data-placement="top" title="Xia, Y., et al., (2015) New insights into the QuikChange process guide the use of

    Phusion DNA polymerase for site-directed mutagenesis. Nucleic Acids Res

43(2):e12">Xia <i>et al.</i>, 2015 <i class="fas fa-external-link" aria-hidden="true"></i></span></a>).
    Namely, the primers in a pair will have an user-defined overlap length
    ( <i>e.g.</i> 22 bp) centred around the codon to mutate and will have a 3&#x2019;
    overhand long enough to allow the region beyond the mutagenized codon to
    anneal with the template above a given melting temperature, while taking
    into account terminal GC clamp. The traditional Quikchange protocol (Agilent)
    works poorly for codon mutants.
    <br>The serverside calculations use a Python 3 script obtainable from: <a target="_blank"
    href="https://github.com/matteoferla/mutational_scanning">

        mutational scanning <i class="fas fa-github" aria-hidden="true"></i></a>).</p>