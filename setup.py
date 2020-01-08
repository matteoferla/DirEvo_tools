__docs__ = """
.
"""

import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))


requires = open('requirements.txt')

tests_require = [
    'WebTest >= 1.3.1',  # py3 compat
    'pytest >= 3.7.4',
    'pytest-cov',
]

setup(
    name='direvo',
    version='0.0',
    description='DirEvo Tools webapp',
    long_description=__docs__,
    classifiers=[
        'Programming Language :: Python',
        'Framework :: Pyramid',
        'Topic :: Internet :: WWW/HTTP',
        'Topic :: Internet :: WWW/HTTP :: WSGI :: Application',
    ],
    author='Matteo Ferla',
    author_email='matteo.ferla@gmail.com',
    url='direvo.matteoferla.com',
    keywords='web mutagenesis',
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    extras_require={
        'testing': tests_require,
    },
    install_requires=requires,
    entry_points={
        'paste.app_factory': [
            'main = direvo:main',
        ],
        'console_scripts': [
        ],
    },
)