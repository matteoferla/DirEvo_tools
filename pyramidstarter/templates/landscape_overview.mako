<h3>Description</h3>
                By using the Rosetta application pmut_scan one can obtain a mutational
                landscape of the &#x2206;G for every possible mutation at each position.
                <br>In the case of enzymes, by repeating the same operation on the enzyme
                without substrate docked, with substrate docked, with transition state
                and with product one can find which residues are increase the reactivity.
                <br>This tool gets the output of different point-mutation scans, aligns them
                into a single table and plots them. A few cases will fail entirely, hence
                why the datasets are aligned by the tool.
                <br>As the energies are relative to wild type, it does not matter if in the
                unbound state the ligand is not in the system or that in the transition
                state has a strong constraint.
                <br>The quality of the results depends on the model, so it is important the
                unconstrained scores form a typical Gibbs free energy curve, with negative
                &#x2206;G<sub>rxn</sub> and positive &#x2206;G<sup>&#x2021;</sup>.
                <br>Due to the fact that preparing the models cannot be automated without
                affecting the results, these are not done here.
                <br>If unfamiliar with Rosetta, feel free to contact Matteo Ferla (author),
                who might be able to parameterise your ligands, prepare your models and
                run them for you.
                <br>
                <div class="alert alert-warning" role="alert"><b>[Citation needed]</b>Note that you have to cite the
                    relevant David
                    Baker paper in addition to us...
                </div>