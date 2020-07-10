from pyramid.view import view_config, view_defaults
import pyramid.httpexceptions as exc
import json, logging, re
from rdkit_to_params import Params
from rdkit import Chem
from rdkit.Chem import AllChem, Draw
from typing import List, Union

from ..utility import Fields, Settings

log = logging.getLogger('direvo')

@view_defaults(route_name='params')
class ParamViews:
    def __init__(self, request):
        self.request = request
        # cached.
        self._atomnames = None

    # ==== getters =====================================================================================================

    def get(self, key):
        if key in self.request.params:
            return self.request.params[key]
        else:
            raise exc.HTTPClientError(f'Query parameter {key} was not provided.')

    def get_bool(self, key) -> bool:
        if key not in self.request.params:
            return False
        elif self.request.params[key] in (True, 'true', 'True', 'yes',):
            return True
        else:
            return False

    @property
    def name(self) -> str:
        if 'name' in self.request.params:
            name = self.request.params['name']
            name = re.sub('\W', '', name)
            if len(name) != 3:
                raise exc.HTTPClientError(f'{self.request.params["name"]} ("{name}") is not three letters long.')
            else:
                return name
        else:
            return 'LIG'

    @property  # cached
    def atomnames(self) -> Union[List[str], None]:
        def clean(name):
            if name in ('null', 'None', '-'):
                return None
            else:
                return re.sub(r'[^\w ]','', name)
        if self._atomnames is not None:
            return self._atomnames
        if 'atomnames' in self.request.params and self.request.params['atomnames'] != '':
            self._atomnames = json.loads(self.request.params['atomnames'])
            if isinstance(self._atomnames, str) and ',' in self._atomnames:
                self._atomnames = self._atomnames.split(',')
            # remove empties
            if isinstance(self._atomnames, list):
                self._atomnames = [clean(an) for an in self._atomnames]
            elif isinstance(self.atomnames, dict):
                self._atomnames = {int(i): clean(an) for i, an in self._atomnames.items()}
            else:
                raise ValueError('atomnames in odd format')
            return self._atomnames
        else:
            return None

    @property
    def generic(self) -> bool:
        return self.get_bool('generic')

    # ==== views =======================================================================================================

    @view_config(renderer=Settings.frame)
    def main_view(self):
        return {'page': Fields(request=self.request,
                               body='params/main.mako',
                               code='params/main.js',
                               overview='params/overview.mako')}

    @view_config(route_name='ajax_params', renderer="json")
    def ajacean(self) -> dict:
        try:
            mode = self.request.matchdict['mode']
            if mode == 'smiles':
                return self.from_smiles()
            elif mode == 'mol':
                return self.from_mol()
            elif mode == 'smiles_pdb':
                return self.from_pdb()
            else:
                raise exc.HTTPClientError(f'Unknown mode `{mode}`')
        except exc.HTTPError as error:
            self.request.response.status_code = error.status_code
            return {'error': f'{error.__class__.__name__}: {error}'}
        except Exception as error:
            log.exception(f'{error.__class__.__name__}: {error}')
            return {'error': f'{error.__class__.__name__}: {error}'}

    # ==== operations ==================================================================================================

    def from_smiles(self) -> dict:
        smiles = self.get('smiles').strip()
        p = Params.from_smiles(smiles, self.name, generic=self.generic, atomnames=self.atomnames)
        return self.to_dict(p)

    def from_mol(self) -> dict:
        if self.get('extension') in ('mol', 'sdf', 'mdl'):
            mol = Chem.MolFromMolBlock(self.get('block'), sanitize=True, removeHs=False, strictParsing=True)
        elif self.get('extension') in ('mol2',):
            mol = Chem.MolFromMol2Block(self.get('block'), sanitize=True, removeHs=False)
        elif self.get('extension') in ('pdb',):
            mol = Chem.MolFromPDBBlock(self.get('block'), sanitize=True, removeHs=False, proximityBonding=False)
        else:
            raise exc.HTTPClientError(f"Format {self.get('extension')} not supported")
        if self.get_bool('protons') is True:
            mol = AllChem.AddHs(mol)
        p = Params.from_mol(mol, self.name, generic=self.generic, atomnames=self.atomnames)
        return self.to_dict(p)

    def from_pdb(self) -> dict:
        smiles = self.get('smiles').strip()
        block = self.get('block').strip()
        if smiles != '':
            p = Params.from_smiles_w_pdbblock(pdb_block=block,
                                         smiles=smiles,
                                         generic=self.generic,
                                         name=self.name,
                                         proximityBonding=False)
            return self.to_dict(p)
        else:
            protein = Chem.MolFromPDBBlock(block, removeHs=False, proximityBonding=False)
            mol = Chem.SplitMolByPDBResidues(protein, whiteList=[self.name])[self.name]
            AllChem.SanitizeMol(mol)
            mol = AllChem.AddHs(mol)
            p = Params.from_mol(mol, self.name, generic=self.generic, atomnames=self.atomnames)
            return self.to_dict(p)

    # ==== common ======================================================================================================

    def file_or_str_to_str(self, key) -> str:
        # current from_mol only accepts string.
        pass

    def to_dict(self, params):
        return {'name': params.NAME,
                 'smiles': Chem.MolToSmiles(params.mol),
                 'params': params.dumps(),
                 'svg': self.get_svg(params),
                 'rotamers': self.get_conformers(params),
                 'pdb': Chem.MolToPDBBlock(params.dummyless)}

    def get_conformers(self, params):
        mol = params.dummyless
        AllChem.EmbedMultipleConfs(mol)
        rotamerblock = ''
        for cid in range(mol.GetNumConformers()):
            rotamerblock += Chem.MolToPDBBlock(mol, confId=cid)
        return rotamerblock

    def get_svg(self, p):
        mol = Chem.Mol(p.mol)
        drawer = Draw.MolDraw2DSVG(400, 400)
        opts = drawer.drawOptions()
        opts.addStereoAnnotation = True
        opts.prepareMolsBeforeDrawing = False
        opts.dummiesAreAttachments = True
        opts.maxFontSize = 10
        for i, atom in enumerate(mol.GetAtoms()):
            opts.atomLabels[i] = f'{atom.GetSymbol()}:{atom.GetIdx()}.{atom.GetPDBResidueInfo().GetName().strip()}'
        AllChem.Compute2DCoords(mol)
        Chem.SanitizeMol(mol, catchErrors=True)
        Draw.PrepareAndDrawMolecule(drawer, mol)
        drawer.FinishDrawing()
        return drawer.GetDrawingText()



