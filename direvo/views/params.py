from .. import parameterise
from pyramid.view import view_config
import json

@view_config(route_name='params', renderer='json')
def ajacean_params(request):
    mode = request.matchdict['mode'].lower()
    try:
        # optionals.
        if 'name' in request.params:
            name = request.params['name']
        else:
            name = 'LIG'
        if 'atomnames' in request.params:
            atomnames = json.loads(request.params['atomnames'])
        else:
            atomnames = None
        # cases
        if mode == 'smiles':
            assert 'smiles' in request.params, 'missing smiles'
            return parameterise.from_smiles(request.params['smiles'], atomnames)
        else:
            raise ValueError(f'Unknown mode {mode}')
    except Exception as err:
        return {'error': str(err)}