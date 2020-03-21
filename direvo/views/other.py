############### Other #####################
from pyramid.response import FileResponse
from pyramid.view import view_config
import os
from ..utility import Settings


@view_config(route_name='status', renderer='string')
def pinger(request):
    return 'OK'


@view_config(route_name='robots')
def robots(request):
    txt = os.path.join(Settings.path, "static", "robots.txt")
    return FileResponse(txt, request=request)


@view_config(route_name="favicon")
def favicon_view(request):
    icon = os.path.join(Settings.path, "static", "favicon.ico")
    return FileResponse(icon, request=request)
