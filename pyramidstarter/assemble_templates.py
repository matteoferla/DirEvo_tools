from string import Template
import re, os


barnames='m_home m_mutantcaller m_pedel m_driver m_deepscan m_mutantprimers m_glue m_QQC m_mutanalyst m_about m_misc'.split()
def set_bar(name, welcome=False):
    ddex={i:'' for i in barnames}
    ddex[name]='active'
    if welcome:
        ddex['welcome']=open('templates/welcome.pt', 'r').read()
    else:
        ddex['welcome'] = ''
    return ddex

def make_templates():
    """
    pretty sure I am reinventing the wheel here and Chameleon does it...
    Not sure why serverside it cannot find them...
    """
    temps=os.listdir('templates')
    frame = open('templates/frame.pt', 'r').read()
    for word in ['welcome','main','codon_modal']+barnames:
        frame = frame.replace('${' + word + '}', '$' + word).replace('${structure: ' + word + '}', '$' + word)
    open('templates/final_main.pt', 'w').write(
        Template(frame).safe_substitute(main=open('templates/main.pt', 'r').read(), code='',
                                        **set_bar('m_home',True))
    )
    frame=Template(frame).safe_substitute(codon_modal=open('templates/codon_modal.pt','r').read())
    for (name,welcomed) in (('deepscan',False),('about',False),('QQC',False),('mutanalyst',False),('mutantcaller',False),('misc',False),('pedel',False),('driver',False),('glue',False),('404',False),('log',False),('facs2excel',False),('mutantprimers',False)):
        if '{}.js'.format(name) in temps:
            code=open('templates/{}.js'.format(name)).read()
        else:
            code=' '
        open('templates/final_{}.pt'.format(name), 'w').write(
            Template(frame).safe_substitute(main=open('templates/{}.pt'.format(name), 'r').read(), code=code,
                                            **set_bar('m_'+name, welcomed))
        )

if __name__ == "__main__":
    make_templates()
