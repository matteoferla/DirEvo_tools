import re
from rdkit_to_params import Params
from rdkit import Chem

def from_smiles(smiles, original_name, atomnames):
    name = re.sub('\W','', original_name)
    assert len(name) == 3, f'{original_name} ("{name}") is not three letters long.'
    p = Params.from_smiles(smiles, name, generic=False, atomnames=atomnames)
    return {'params': p.dumbs, 'pdb': Chem.MolToPDBBlock(p.dummyless())}

def from_mol(molblock):
    mol = Chem.MolFromMolBlock(molblock, sanitize=False, removeHs=False, strictParsing=False)
    p = Params(mol)
