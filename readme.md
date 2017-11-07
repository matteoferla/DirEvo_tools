
<a href="https://codeclimate.com/github/matteoferla/pedel2"><img src="https://codeclimate.com/github/matteoferla/pedel2/badges/gpa.svg" /></a>
<a href="https://codeclimate.com/github/matteoferla/pedel2/"><img src="https://codeclimate.com/github/matteoferla/pedel2/badges/issue_count.svg" /></a>

# Intro
Repo for the new site, currently called [pedel2](http://pedel2-git-matteo-ferla.a3c1.starter-us-west-1.openshiftapps.com/) —but may change name.
It is still WIP and I do not have enough Pods to keep a stable version for viewing, so if a current version is needed email me.
See also my [mutagenesis repository](https://github.com/matteoferla/mutagenesis).


# To Do list
## Main
What nav is needed?
* table?
* clicable map (image)?

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
* make it print a graph at different values.
* Glue-it. Not done yet.

## Pedel
* main works.
* pedel range of conditions not doen yet, but pedel_batch wrapper made.
* Pedel-AA not done yet

* pedel PCR not active
* calc for PCR in Pedel not done.
* Talk to Wayne about conceptual issues with PCR efficiency

## Mutant caller
* input penalty values for match
So this script would require the user to upload sequence trace file
And a reference sequence (mutated only)
returns mutations.    

NB. Benchling API: Benchling API reqires a key. This seems to be issued on request to devs. SO this is not an option.

## QQC
* wire reverse

## Mutanalyst
Mutanalyst is using JS still. Not Ajax.

## Driver
* driver output could be made into a nice table actual.

## other
* Scheme 19c and 20c in QQC are incomplete!!
* js of misc for codon has error due to staticmethod being called... changed the static methods fom QQC.
* GlueIT in pt needs js to change the number of codons.
* Glue needs a switch like Pedel
* URL query string needs to be integrated
* make size responsive.
* https. switch to gnunicorn from waitress?
* Make sure code supports badly formatted sequences. e.g. numbers and spaces and newlines.
* edit ajax views to specificy server side errors. Also edit js side to catch client side errors.

## Next Gen mutantcaller
Pipedream. fastq files are several GB big, thus they cannot be uploaded.
However, a small simple custom alignment algorithm running with GPU.JS could do it quite fast.
