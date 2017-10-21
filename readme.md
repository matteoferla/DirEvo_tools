
<a href="https://codeclimate.com/github/matteoferla/pedel2"><img src="https://codeclimate.com/github/matteoferla/pedel2/badges/gpa.svg" /></a>
<a href="https://codeclimate.com/github/matteoferla/pedel2/"><img src="https://codeclimate.com/github/matteoferla/pedel2/badges/issue_count.svg" /></a>

# Intro
Please see my mutagenesis repository.

# Where was I?
* in QQC.py MC module.

# To Do list
## Main
What nav is needed?
* table
* clicable map (image)

## mutationprimer
* temporary name. Most functions are copypaste jobs of deepscan.
* make more elegant the determination of server or localhost.
* code currently written until making a function in mutant_wrapper...
* why is Y66 actually Y67? Does GFP not start from ATG??
* IDT does not accept lowercase degenrte nts.
* does not check for terminal indels if set to local. Currently set to global.
* silent mutations! Also ratio of these!

## Glue
* Glue works.
* Glue-it. Not done yet.

## Pedel
* main works.
* pedel PCR not active
* pedel range of conditions not doen yet, but pedel_batch wrapper made.
* Pedel-AA not done yet
* calc for PCR in Pedel-AA not done.
* Talk to Wayne about conceptual issues with PCR efficiency

## Mutant caller
* wired but not written
* input penalty values for match
* add reverser
* there is a conceptual error in that the peak highlighted is the middle one (it could be any other in the codon)


So this script would require the user to upload sequence trace file
And a reference sequence (mutated only)
returns mutations. Quality score?     

NB. Benchling API: Benchling API reqires a key. This seems to be issued on request to devs. SO this is not an option.

## QQC
* wire reverse

## Mutanalyst
Mutanalyst is using JS still. Not Ajax.

## other
* Scheme 19c and 20c in QQC are incomplete!!
* js of misc for codon has error due to staticmethod being called... changed the static methods fom QQC.
* GlueIT in pt needs js to change the number of codons.
* Glue needs a switch like Pedel
* URL query string needs to be integrated
* make size responsive.
* https. switch to gnunicorn from waitress?
* add color choice to request.session? Actually just make it a JS thing.
* Make sure code supports badly formatted sequences. e.g. numbers and spaces and newlines.
* edit ajax views to specificy server side errors. Also edit js side to catch client side errors.


## GlueIT hackshop
I have no idea how GlueIT or PedelAA work, so I need to reverse engineer them first.
There are three:

    Usage './glue1AAc library_size c1 c2 c3 c4 c5 c6 ncodons'.

It calculates any codon. 'Single codon variant'

    Usage './glueITc datafile'.

This must be the main one.
But there is also

    Usage './glueNNS library_size'.

It calculates NNS.

The C++ code of GlueIT declares the following:

    double L, nvar, xtot;
      int ncodons, c[maxcodons][6], j0, j1, j2, j3, j4, j5, i, j;
      double total_aa[maxcodons], total_cod[maxcodons];
      double xtotal_aa, xtotal_cod, pcomplete;

The main ones:
* `ncodons` int
* `L` double
* `c[ncodons][j]` 6x6 matrix of int!

The file is read as following:

    datafile >> L; double
    for (i = 0; i < ncodons; ++i) {
    datafile >> total_cod[i]; 6 double
    total_aa[i] = 0;
    for (j = 0; j < 6; ++j) {
      datafile >> c[i][j]; 6x6 matrix int
      total_aa[i] += float(c[i][j]);
    }
    }

There are 15 deg codon options per codon base. What is the second 6 per base?
Is it 6 because of the max codon number? What are the integers? If so why is it not declared c[maxcodons][maxcodons]
If there are less than 6 codons it fills the rest like (eg. AAA) [1,0,0,0,0,0] 1 codon variant.
Are these simply booleans?
* A = 1
* S = 2
* B = 3
* N = 4
You cannot get 6 variants...
expected number of variants is a result of

    float(c[0][j0]*c[1][j1]*c[2][j2]*c[3][j3]*c[4][j4]*c[5][j5])

This indicates that it is relative to maxcodons.

