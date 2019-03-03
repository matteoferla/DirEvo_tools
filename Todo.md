# Summary

| program | Tour | Fx |
| ------- | -------| --- |
| MutantCaller | results is poor | Some fx tweaks |
| Mutanalyst | &#10003; | &#10003; |
| Pedel classic | &#10005; | Minor |
| Pedel AA | Incomplete | More... |
| Driver | &#10003; | table? |
| Glue | &#10005; | extra? |
| GlueIT | &#10005; | extra? |
| QQC | | reverse strand |
| Deepscan | &#10005; | &#10003; |
| Mutantprimer | &#10005; | &#10003; |
| Landscape | &#10005; | &#10003; |
| Silico | &#10005; | Demo |
| Probably  | &#10005; | &#10003; |

# To Do list

Sorted by urgency:

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