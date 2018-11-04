<!--
<a href="https://codeclimate.com/github/matteoferla/pedel2"><img src="https://codeclimate.com/github/matteoferla/pedel2/badges/gpa.svg" /></a>
<a href="https://codeclimate.com/github/matteoferla/pedel2/"><img src="https://codeclimate.com/github/matteoferla/pedel2/badges/issue_count.svg" /></a>
-->
# Intro
Repo for the new site, currently called [pedel2](pi.matteoferla.com) —but will change name when inspired.
I assume that it will be hosted as pedel.enzymes.org.nz or similar in the future.
See also my [mutagenesis repository](https://github.com/matteoferla/mutagenesis).
It is currently hosted on a Raspberry pi in my flat, hence the subdomain "pi".

# To Do list

Sorted by urgency:

* *Theme* Get a word from Wayne and Matilda about the theme
* *Pedel-AA* a-elements linkage is broken in certain bits. :angry:
* *Pedel*  range of conditions not done yet, but pedel_batch wrapper made. —original functionality
* *Pedel-AA* graphs —original functionality
* *PedelAA* links to modals in sub table. &mdash; I thought this was done. :confused:
* *QQC* wire reverse
* *Glue* works, but make it print a graph at different values. —extra functionality
* *driver* output could be made into a nice table actually. —extra functionality
* *mutationprimer* why is Y66 actually Y67? Does GFP not start from ATG??
* *mutationprimer* IDT does not accept lowercase degenrte nts.
* *mutatcaller* does not check for terminal indels if set to local. Currently set to global.
* *mutatcaller* silent mutations! Also ratio of these!
* *mutatcaller* input penalty values for match returns mutations. what the hell does this mean?
* Scheme 19c and 20c in QQC are incomplete!!
* js of misc for codon has error due to staticmethod being called... changed the static methods fom QQC.
* GlueIT in pt needs js to change the number of codons.
* Glue needs a switch like Pedel —or does Pedel need two pages?
* URL query string needs to be integrated
* make size responsive. —why would anyone use their mobile?
* Make sure code supports badly formatted sequences. e.g. numbers and spaces and newlines.
* Also edit js side to catch client side errors. —Some do already...
* Rosetta landscape. Add distribution of mutations and norm thinggy like my matlab script has.
* *Mutanalyst* is using old JS still. Not Ajax and python. —Is this actually urgent??
* *mutationprimer*. temporary name. Most functions are copypaste jobs of deepscan. —So?
* *mutationprimer* code currently written until making a function in mutant_wrapper... —what does this mean?

# Bullcrap area

## Seen.js
* How can I use Seen.js for a landscape? And when is a 3d rotatable terrain better than a 2D plot? Aka. is it a load of pointless glitz?

## Next Gen mutantcaller
Pipedream. fastq files are several GB big, thus they cannot be uploaded.
However, a small simple custom alignment algorithm running with GPU.JS could do it quite fast.

## Benchling integration
NB. Benchling API: Benchling API reqires a key. This seems to be issued on request to devs. SO this is not an option.