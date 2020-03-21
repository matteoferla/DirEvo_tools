import os

class Settings:
    #lazy singleton.
    path = 'direvo'
    status = 'none'
    frame = os.path.join('..', 'templates', 'frame.mako')