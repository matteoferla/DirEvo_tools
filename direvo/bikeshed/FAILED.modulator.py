from distutils.core import setup, Extension

# Ignore this experiment!

#['.DS_Store', 'complie.sh', 'driver', 'driver.batch', 'driver.batch.cxx', 'driver.cxx', 'driver_mc', 'driver_mc.cxx', 'glue', 'glue.mod.cxx', 'glue_mc', 'glue_mc.cxx', 'pedel', 'pedel.batch', 'pedel.batch.cxx', 'pedel.cxx', 'pedel_mc', 'pedel_mc.cxx', 'pedel_mc_run.sh', 'readme.md', 'stats.batch', 'FAILED_MOD_stats.batch.cxx']

setup (name = 'pedel',
       version = '1.0',
       description = 'This is the pedel package',
       ext_modules = [Extension('pedel',
                    sources = ['pedel.cxx'])])

