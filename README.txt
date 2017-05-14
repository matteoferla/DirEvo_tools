Pyramidstarter README



There are many ways to get your pyramid project running on Openshift.  This is one example.  I use Waitress as the server.  The demo code currently is setup using wsgi simple server.  You can comment/uncomment out the code in app.py as you like and select what server you want to use.

Openshift uses two different entry points for starting your app.  These are 'app.py' and 'wsgi.py'.  Only use one.

Use 'app.py' to start your own server such as waitress, cherrypy, etc.

Use 'wsgi.py' to just use Openshift's Apache server.

Rename/delete these files accordingly to enable or disable depending on what you want to do.


Add the packages you want to be installed in the setup.py