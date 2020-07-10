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
<h4>Atom names</h4>
<p>The names of the atoms can be specified. Using the atom order as they appear in the SMILES,
    you can supply either an array/list (with '-' or 'null' to mark atoms you do not which to specify, (<i>e.g.</i><code>['-', ' CX ', 'CY']</code>) or
    a object/hash/dictionary with keys the index and the value the name (<i>e.g.</i><code>{5: ' CX '}</code>)</p>
<p><i>Note.</i> This is ignored if you provided a PDB (third option).</p>
<h4>SMILES</h4>
<p>A SMILES is <a href="https://en.wikipedia.org/wiki/Simplified_molecular-input_line-entry_system" target="_blank">
    a string that represents a molecule <i class="fab fa-wikipedia-w"></i></a>. For example <code>CC</code> is propane.</p>
<h4>PDB</h4>
<p>A ligand in a PDB is often unprotonated and has no indication of what the format charges are,
nor are bonds necessarily correct —a double bond is a repeated CONECT entry, but aromatic bonds cannot be specified.
Hence why the third option has a SMILES input box. Okay, if this is omitted the ligand called by 3-name will be extracted
    and parameterised whereas in the second option sending over a pdb assumes there is only the ligand.
    Also, this piece of code has a weird behaviour with CHI entries so the resulting value is empty as a temp fix.
</p>
<h4>Testing</h4>
<p>As this homeserver is currently on a Rasperry Pi and hosts other apps so I don't wish to overburden it so the
    params is not tested. The module does it (<code>params.test()</code>).</p>
<h4>Rotamers</h4>
<p>The rotamer file needs to specified in the params if you want to use it via
    <code>PDB_ROTAMERS filename.pdb</code>.
</p>
<h4>Possible improvements</h4>
<p>This is a simple interface to the module. If there is interest (press feedback) I will add
    <ul>
    <li> a molecule drawerer here —I am thinking Ketcher</li>
    <li> constraints for covalents (module has it already)</li>
    <li> amino acid from side chain</li>
    <li> testing in pyrosetta of the ligand (module does it)</li>
</ul>
    </p>