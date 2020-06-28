<h3>Description</h3>
<p>To use a ligand or non-canonical amino acid in Rosetta, a params file needs to be provided,
    which defines the topology of the "residue" (the name in a PDB for a ligand, nucleotide, amino acid residue, ion or water).
</p>
<h4>Module</h4>
<p>This tool does not utilise the mol_to_params.py script included in Rosetta, but a module I wrote
    which parameterises ligands from <code>RDKit.Chem.Mol</code> objects (<i>cf.</i>
    <a href="https://github.com/matteoferla/rdkit_to_params" target="_blank">
                 Rdkit-to-params repo <i class="fab fa-github"></i></a>).
    It does a lot more things,
    like allow atom names in a pre-existing params file to be modified,
    rename atom names from a PDB file,
    rename atom names based upon a template molecule,
    testing (via Pyrosetta) of the file,
    etc.
</p>
<h4>Covalent</h4>
<p>To mark covalent attachments (<code>CONNECT</code>/<code>UPPER</code>/<code>LOWER</code> entries),
    this module uses a a dummy atom to mark a covalent connection, this is a
    <code>*</code> element in SMILES (called  in RDKit, atomic number of zero) or
    <code>R</code> element in a MDL file.
    <br/>NB. Make sure your PDB of your protein has a <code>LINK</code> line or it will be ignored!
    Specifying an amino acid requires two connections in the backbone, <i>i.e.</i> <code>*NC({sidechain})C(=O)*</code>.
    NB. the atom order in the params is not the atom order, so the backbone can be anywhere in the smiles
    (<i>e.g.</i> <code>*NC(C(=O)*){sidechain}</code> or <code>*NC{sidechain}(C(=O)*)CN*</code>).
</p>
<p4>SMILES</p4>
<p>A SMILES is <a href="https://en.wikipedia.org/wiki/Simplified_molecular-input_line-entry_system" target="_blank">
    a string that represents a molecule <i class="fab fa-wikipedia-w"></i></a>. For example <code>CC</code> is propane.</p>
<h4>Possible improvements</h4>
<p>This is a simple interface to the module. If there is interest I will add
    <ul>
    <li> a molecule drawerer here —I am thinking Ketcher</li>
    <li> a PDB route with or without SMILES (module has it already)</li>
    <li> atom name option (module has it already)</li>
    <li> conformers (module has it already)</li>
    <li> amino acid from side chain</li>
    <li> testing —this homeserver is currently on a Rasperry Pi and hosts other apps so I don't wish to overburden it.</li>
</ul>

    </p>