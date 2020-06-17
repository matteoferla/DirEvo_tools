import os

class Settings:
    #making into a singleton.
    path = 'direvo'
    status = 'none'
    frame = os.path.join('..', 'templates', 'frame.mako')