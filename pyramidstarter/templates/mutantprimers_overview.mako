<h3>Description</h3>
        <p>This tool designs site-directed mutagenesis primer pairs in bulk based on specified amino acid mutations required. This includes options for degerate codons (see <a href="#codon_scheme_descriptor">below</a>).</p>
        <p>The primer pairs can be made to be fully overlapping like traditional QuikChange primers or a partially overlapping primer pair strategy (<a href="http://nar.oxfordjournals.org/content/43/2/e12.long"
                    target="_blank"><span data-toggle="tooltip" data-placement="top" title="Xia, Y., et al., (2015) New insights into the QuikChange process guide the use of

                    Phusion DNA polymerase for site-directed mutagenesis. Nucleic Acids Res

43(2):e12">Xia <i>et al.</i>, 2015 <i class="fas fa-external-link" aria-hidden="true"></i></span></a>).</p>
                    <p>As the traditional Quikchange protocol (Agilent)
                    works poorly for codon mutants, a better option is to have the primers with an user-defined overlap length
                    ( <i>e.g.</i> 22 bp) centred around the codon to mutate and will have a 3&#x2019;
                    overhand long enough to allow the region beyond the mutagenized codon to
                    anneal with the template above a given melting temperature, while taking
                    into account terminal GC clamp.</p>
        <p>If the overlap is in the 20–30 bases range, the primers can be also be used for Gibson assembly.</p>