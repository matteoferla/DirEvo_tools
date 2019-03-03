## Intro
Repo for the new site, currently called [pedel2](pi.matteoferla.com) —but will change name when inspired.
I assume that it will be hosted as pedel.enzymes.org.nz or similar in the future.
See also my [mutagenesis repository](https://github.com/matteoferla/mutagenesis).
It is currently hosted on a Raspberry pi in my flat, hence the subdomain "pi".

## Running locally
Do note that waitress cannot serve https natively. The apache server handles that.       
Consequenly, if you want to run locally change the first line in `templates/frame.mako` to
`<%page args="request, page, scheme='http', port=8080"/>` and run in the root of the folder `python3 appy.py`

## Future improvements
See `todo.md`. 