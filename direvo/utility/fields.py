from .settings import Settings

class Fields:
    # I think I need some methods... so better do this than a default dictionary
    terms={
        'load':('Mutational load','Average number of mutations per variant in the library. This can be per gene or per kb.'),
        'spectrum': ('Mutational spectrum','The distribution of mutation types (e.g. A to C)'),
        'bias': ('Mutational bias','Various metrics to assess the divergence from the ideal situation where a nucleotide position has equiprobably change of mutating into any of the other three.'),
        'rate':('error rate per division','The average number of de novo mutations per kb that happen during one PCR duplication cycle'),
        'transversion':('Transversions','This is a mutation where a purine (adenine, guanine),  becomes a pyrimidine (thymine/uracil, cytosine) or vice versa.'),
        'transition':('Transitions','This is a mutation where the class of nucleobase (purine or pyrimidine) is unchanged.'),
        'doubling':('Doubling number','Number of duplications during PCR, which differs from PCR cycle number'),
        'missense':('Missense mutation','A mutation that results in an amino acid change. These are good mutations for directed evolution.'),
        'nonsense':('Nonsense mutation','A mutation that results in a premature stop. These are bad mutations for directed evolution.'),
        'synonymous':('Synonymous mutation','A mutation that alters the codon into another that codes the same amino acid. one third of changes in a equiprobable scenario are synonymous.'),
        'epPCR':('Error-prone PCR','A PCR reaction with a polymerase without proof-reading ability that may have lower fidelity due to amino acid changes (Mutazyme) or cofactor (manganese) or in the presence of wobbly dNTPs (oxodGTP and dPTP). This differs from PCR where the primers carry the variation (QuickChange-like).')
    }

    def term_helper(self, term, inner=None):
        if inner:
            return '<abbr data-toggle="tooltip" title="{t}">{i}</abbr>'.format(i=inner,t=self.terms[term][0]+': '+self.terms[term][1])
        else:
            return '<abbr data-toggle="tooltip" title="{t}">{i}</abbr>'.format(i=term, t=self.terms[term][0] + ': ' + self.terms[term][1])

    def __init__(self, **kwargs):
        #deal with status.
        self.status = Settings.status
        if 'status' in kwargs:
            self.status = kwargs['status']
        if Settings.status == 'normal' or Settings.status == 'none' or not Settings.status:
            self.status = None
        elif Settings.status == 'beta':
            self.status_class='info'
            self.status_msg='This is still in beta. This version may be unstable.'
        elif Settings.status == 'construction':
            self.status_class = 'warning'
            self.status_msg = 'Matteo is actively working with the server. It may go down at any time.'
        elif Settings.status == 'red':
            self.status_class = 'danger'
            self.status_msg = 'Somebody pressed the forbidden link.'
        elif Settings.status == 'xmas':
            self.status_class = 'info'
            self.status_msg = '<i class="fas fa-tree-christmas fa-spin"></i> Merry Christmas! (Aka testing the FA 5.6 upgrade, which is being buggy).'
        elif Settings.status == 'upgradetemp':
            self.status_class = 'warning'
            self.status_msg = '<i class="fas fa-bat fa-spin"></i> Matteo just upgraded both Bootstrap and Font Awesome, and did a major change to the Mako templating so bugginess is a given.'
        else: #'custom' there will be status_msg and class in kwargs
            self.status_class='danger'
            self.status_msg=Settings.status
        #write args
        self.requirements=[]
        for k in kwargs:
            setattr(self,k,kwargs[k])

    def __setattr__(self, key, value):
        self.__dict__[key] = value

    def __getattr__(self, item):
        if item in self.__dict__:
            return self.__dict__[item]
        else:
            return ''