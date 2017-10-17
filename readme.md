# Intro
Please see my mutagenesis repository. 

# To Do list
## mutationprimer
* temporary name. Most functions are copypaste jobs of deepscan.
* make more elegant the determination of server or localhost.
* code currently written until making a function in mutant_wrapper...
* why is Y66 actually Y67? Does GFP not start from ATG??
* IDT does not accept lowercase degenrte nts.

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
SO this script would require the user to upload sequence trace file
And a reference sequence (mutated only)
returns mutations. Quality score?
Benchling API: Benchling API reqires a key. This seems to be issued on request to devs. SO this is not an option.

## Mutanalyst
Mutanalyst is using JS still. Not Ajax.

## other
* Scheme 19c and 20c in QQC are incomplete!!
* js of misc for codon has error due to staticmethod being called... changed the static methods fom QQC.
* GlueIT in pt needs js to change the number of codons.
* Glue needs a switch like Pedel
* URL query string needs to be integrated
* make size responsive.
* https damn it



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

