<div id="glue_intro">
            <h3>Description</h3>
            <p>Given a library of <i>L</i> sequences, where each sequence is chosen at
                random from a set of <i>V</i> equiprobable variants, we wish to calculate
                the expected number of distinct (i.e. unique) sequences represented in
                the library. Alternatively, given a set of <i>V</i> equiprobable variants,
                we wish to calculate the library size <i>L</i> necessary to obtain a given
                percentage completeness, or to have a given probability of being 100% complete.
                (Typically assuming <i>V</i> &gt;&gt; 1, e.g. V &gt; 10.)</p>
            <h3>Example (<a data-toggle="collapse" href="#glue_example"><i class="fas fa-caret-down"
                                                                           aria-hidden="true"></i> show</a>)

            </h3>
            <div class="collapse" id="glue_example">
                <p>For the default values on the web server, there are a total of one million
                    possible variants. This is roughly equivalent to an oligonucleotide directed
                    randomization experiment involving four NNS codons (which gives <i>V</i> =
                    32<sup>4</sup> = 1048576).</p>
                <p>In the first panel, the experimenter has constructed a library of three
                    million transformants and wishes to estimate how many of the one million
                    possible variants are represented in the library. The answer is ~95.02%
                    or 950200 variants.</p>
                <p>In the second panel, s/he knows that there are one million possible variants,
                    and wants to know how big her/his library should be in order to ensure
                    that ~95% of them (i.e. 950000 variants) are represented. The answer is
                    that a library of ~2.996 million transformants is required.</p>
                <p>In the ideal situation her/his library would contain all one million variants.
                    In the third panel s/he calculates the library size required in order to
                    be 95% sure of complete representation. The answer is ~16.79 million transformants.</p>
            </div>
        </div>

<h3>Description</h3>
        <p>Programme to find the expected amino acid completeness of a given library
            (not counting any variants with introduced stop codons) where the sequences
            in the library are chosen at random from a set of XYZ codon variants (where
            X,Y,Z are <a href="#" data-toggle="modal" data-target="#nucleotide_modal">standard

                nucleotide codes</a> chosen by the user, e.g. XYZ
            = NNS [N = A/C/G/T; S = C/G; 32 possible equiprobable codon variants; 20
            + 1 possible non-equiprobable amino acid/stop codon variants]). Up to six
            codons may be independently varied.
            <br>
            <br>To calculate the library size required in order to obtain a given completeness,
            or to have a given probability of being 100% complete, just try entering
            different library sizes and check the resulting library statistics until
            you home in on your required values.</p>