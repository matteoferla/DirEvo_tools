
<a href="https://codeclimate.com/github/matteoferla/pedel2"><img src="https://codeclimate.com/github/matteoferla/pedel2/badges/gpa.svg" /></a>
<a href="https://codeclimate.com/github/matteoferla/pedel2/"><img src="https://codeclimate.com/github/matteoferla/pedel2/badges/issue_count.svg" /></a>

# Intro
Repo for the new site, currently called [pedel2](pi.matteoferla.com) —but may change name.
See also my [mutagenesis repository](https://github.com/matteoferla/mutagenesis).
It is currently hosted on a Raspberry pi in my flat.

# To Do list

Sorted by urgency:

* *Glue-it*. Not done yet.
* *pedel* DNA/AA PCR not active
* *Glue* works, but make it print a graph at different values.
* *main* needs fixing. See below.
* *mutationprimer*. temporary name. Most functions are copypaste jobs of deepscan.
* *mutationprimer*. make more elegant the determination of server or localhost.
* *mutationprimer* code currently written until making a function in mutant_wrapper...
* *mutationprimer* why is Y66 actually Y67? Does GFP not start from ATG??
* *mutationprimer* IDT does not accept lowercase degenrte nts.
* *mutatcaller* does not check for terminal indels if set to local. Currently set to global.
* *mutatcaller* silent mutations! Also ratio of these!
* *Pedel*  range of conditions not doen yet, but pedel_batch wrapper made.
* *Pedel-AA* graphs
* *QQC* wire reverse
* *Mutanalyst* is using old JS still. Not Ajax and python.
* *driver* output could be made into a nice table actually.
* calc for PCR in Pedel not done.
* *mutatcaller* input penalty values for match. what the hell does this mean?
returns mutations.    
* Scheme 19c and 20c in QQC are incomplete!!
* js of misc for codon has error due to staticmethod being called... changed the static methods fom QQC.
* GlueIT in pt needs js to change the number of codons.
* Glue needs a switch like Pedel
* URL query string needs to be integrated
* make size responsive.
* https. switch to gnunicorn from waitress or let Apache server handle it.
* Make sure code supports badly formatted sequences. e.g. numbers and spaces and newlines.
* edit ajax views to specificy server side errors. Also edit js side to catch client side errors.
* Talk to Wayne about conceptual issues with PCR efficiency
* Lastly, ask Wayne where the server physically lives.

# Bullcrap area

## Next Gen mutantcaller
Pipedream. fastq files are several GB big, thus they cannot be uploaded.
However, a small simple custom alignment algorithm running with GPU.JS could do it quite fast.

NB. Benchling API: Benchling API reqires a key. This seems to be issued on request to devs. SO this is not an option.

## Main
What nav is needed?
* table?
* clicable map (image)?