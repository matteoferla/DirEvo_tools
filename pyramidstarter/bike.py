import os, random, re, sys

if sys.platform == 'darwin':
    suffix = '.mac'
elif sys.platform == 'linux':
    suffix = '.linux'
else:
    raise Exception("Unknown operating system, {}. This program does not run on Atari, Windows or Solaris or other junk".format(os.name))

PATH = "/opt/app-root/src/pyramidstarter/bikeshed"
if not os.path.isdir(PATH):
    PATH = "pyramidstarter/bikeshed"


def pedel(library_size, sequence_length, mean_number_of_mutations_per_sequence):
    # Usage './pedel.mac library_size sequence_length mean_number_of_mutations_per_sequence'.
    return wrap('pedel', '=', library_size, sequence_length, mean_number_of_mutations_per_sequence)


def pedel_stats(library_size, sequence_length, mean_number_of_mutations_per_sequence):
    '''
    Caculates sublibrary composition.
    :param library_size:
    :param sequence_length:
    :param mean_number_of_mutations_per_sequence:
    :return:
    '''
    # Usage './stats.batch.mac library_size sequence_length mean_number_of_mutations_per_sequence outfile'.
    '''
    x = exact number of mutations per sequence.
    Px = Poisson probability of x mutations, given m.
    Lx = expected number of sequences in library with exactly x mutations.
    Vx = number of possible sequences with exactly x mutations.
    Cx = expected number of distinct sequences in the sub-library comprising sequences with exactly x mutations.
    Cx/Vx = completeness of sub-library.
    Lx - Cx = number of redundant sequences in sub-library.
    :param library_size:
    :param sequence_length:
    :param mean_number_of_mutations_per_sequence:
    :return:
    '''
    return wrap('stats.batch.mod', 'table', library_size, sequence_length, mean_number_of_mutations_per_sequence)


def pedel_batch(library_size, sequence_length, mean_number_of_mutations_per_sequence, nsteps):
    """
    Unlike the orginal, no first digit. Give tuple or list of the max min of the variable to change.
        Usage './pedel.batch.mac 1 L N lambda_0 lambda_1 nsteps outfile',
       or './pedel.batch.mac 2 lambda N L_0 L_1 nsteps outfile',
       or './pedel.batch.mac 3 L lambda N_0 N_1 nsteps outfile',
    where
      L = library size,
      N = sequence length,
      lambda = mean number of point mutations per sequence,
    and _0 _1 give a range covered with nsteps steps.

    :return:
    """
    if isinstance(mean_number_of_mutations_per_sequence, (list, tuple)):
        stats = wrap('pedel.batch', 'HTML', 1, library_size, sequence_length, mean_number_of_mutations_per_sequence[0],
                     mean_number_of_mutations_per_sequence[1], nsteps, os.path.join(PATH,'outfile'))
    elif isinstance(library_size, (list, tuple)):
        stats = wrap('pedel.batch', 'HTML', 2, mean_number_of_mutations_per_sequence, sequence_length, library_size[0],
                     library_size[1], nsteps, os.path.join(PATH,'outfile'))
    elif isinstance(sequence_length, (list, tuple)):
        stats = wrap('pedel.batch', 'HTML', 3, library_size, mean_number_of_mutations_per_sequence, sequence_length[0],
                     sequence_length[1], nsteps, os.path.join(PATH,'outfile'))
    else:
        raise TypeError
    return stats  # library_size sequence_length mean_number_of_mutations_per_sequence

def glue(nvariants, library_size=None,completeness=None,prob_complete=None):
    """
    glue.mod gives an output similar to pedel.
    Usage
    './glue.mac 1 nvariants library_size',
    or './glue.mac 2 nvariants completeness',
    or './glue.mac 3 nvariants prob_100%_complete'.
    :param nvariants:
    :param library_size:
    :param completeness:
    :param prob_complete:
    :return:
    """
    if library_size and not completeness and not prob_complete:
        return wrap('glue.mod','=','1',nvariants,library_size)
    elif not library_size and completeness and not prob_complete:
        return wrap('glue.mod','=','2',nvariants,completeness)
    elif not library_size and not completeness and prob_complete:
        return wrap('glue.mod','=','3',nvariants,prob_complete)

def driver(library_size, sequence_length, mean_number_of_crossovers_per_sequence, list_of_variable_positions_file, outfile, xtrue):
    """
    Usage './driver.mac library_size sequence_length mean_number_of_crossovers_per_sequence list_of_variable_positions_file outfile xtrue'.
    I really really need to change the inputs.
    Total number of possible sequences = 512.<br>
    Expected number of distinct sequences = 67.96.<br>
    Mean number of actual crossovers per sequence = 2.<br>
    Mean number of observable crossovers per sequence = 0.8022.<br>
    :return:
    """
    return wrap('driver',' ',library_size, sequence_length, mean_number_of_crossovers_per_sequence, list_of_variable_positions_file, outfile, xtrue)

def glueit(library_size,codonfile):
    cmd= " csh {aff}/glueIT.csh {lib:f} {cf}".format(aff=PATH,lib=library_size,cf=codonfile)
    return str(os.popen(cmd).read())

def pedelAA(filename):
    html=wrap('pedel-AAc',' ',filename)
    print(html)
    data={'html': html}
    # base freq
    rex=re.search('There are (\d+) T\'s, (\d+) C\'s, (\d+) A\'s and (\d+) G\'s in the input sequence.', html)
    rex.group(1)
    for i,k in enumerate(('T','C','A','G')):
        data[k]=rex.group(i+1)
    # summary table
    data['summary_table']='<table class="table table-striped">'+re.search('\<table.*?\>(.*?)\<\/table',html,re.DOTALL).group(1)+'</table>'
    # indel
    data['middle']=re.search('table><br>(.*?)<br><b>Links to further information', html,re.DOTALL).group(1)
    with open(filename[:-6]+'table.html','r') as f:
        data['sub_table']='<table>{}</table'.format(re.search('<table.*?>(.*?)</table',f.read(),re.DOTALL).group(1))
    return data

def wrap(fun, separator, *args):
    """
    Okay. I really ought to have altred the C code for distutils, but this nasty hack is fine for now.
    :param fun:
    :param args:
    :return:
    """
    cmd = os.path.join(PATH,fun + suffix)  + ' ' + ' '.join(args)
    print('from bike.wrap: ', cmd)
    if separator == ' ':
        return str(os.popen(cmd).read())
    if separator == '=':
        preply = {}
    elif separator == 'HTML' or separator == 'table':
        preply = []
    for r in str(os.popen(cmd).read()).split('.<br>\n'):   #str is redundant but for some reason pycharm pre-warns against it.
        if r and separator == '=':
            r2 = r.split(' = ')
            key = r2[0].replace(' ', '_').lower()
            if r2[1].find('.') != -1 or r2[1].find('e') != -1:
                preply[key] = float(r2[1])
            else:
                preply[key] = int(r2[1])
        elif r and separator == 'HTML': #single loop.
            preply = [[float(y) for y in x.split('</td><td>')] for x in
                      re.sub('\<th>*?\/th\>', '', re.sub('\<table.*?\>', '', r)).replace('<tr align="right"><td>',
                                                                                         '').replace('</td></tr>',
                                                                                                     '').replace(
                          '</table><br>', '').split('\n') if x]
        elif r and separator == 'table':
            preply =[[float(y) for y in x.split()] for x in r.split('\n')]
    return preply
