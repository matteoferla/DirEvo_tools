
<a href="https://codeclimate.com/github/matteoferla/pedel2"><img src="https://codeclimate.com/github/matteoferla/pedel2/badges/gpa.svg" /></a>
<a href="https://codeclimate.com/github/matteoferla/pedel2/"><img src="https://codeclimate.com/github/matteoferla/pedel2/badges/issue_count.svg" /></a>

# Intro
Repo for the new site, currently called [pedel2](pi.matteoferla.com) —but may change name.
See also my [mutagenesis repository](https://github.com/matteoferla/mutagenesis).
It is currently hosted on a Raspberry pi in my flat.

# To Do list

Sorted by urgency:

* *pedel* DNA/AA PCR not active
* *main* needs fixing. See below.
* *mutationprimer*. temporary name. Most functions are copypaste jobs of deepscan.
* *mutationprimer*. make more elegant the determination of server or localhost.
* *mutationprimer* code currently written until making a function in mutant_wrapper...
* *mutationprimer* why is Y66 actually Y67? Does GFP not start from ATG??
* *mutationprimer* IDT does not accept lowercase degenrte nts.
* *mutatcaller* does not check for terminal indels if set to local. Currently set to global.
* *mutatcaller* silent mutations! Also ratio of these!
* *Glue* works, but make it print a graph at different values.
* *Pedel*  range of conditions not done yet, but pedel_batch wrapper made.
* *PedelAA* links to modals in sub table.
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
* Also edit js side to catch client side errors.

# Bullcrap area

## Next Gen mutantcaller
Pipedream. fastq files are several GB big, thus they cannot be uploaded.
However, a small simple custom alignment algorithm running with GPU.JS could do it quite fast.

NB. Benchling API: Benchling API reqires a key. This seems to be issued on request to devs. SO this is not an option.

## Main
What nav is needed?
* table?
* clicable map (image)?

## These are my notes on the pi config.
First I installed raspian and added empty file called ssh on microSD card     
Sort out the login and apt-get     

    arp -a
    ssh pi@192.168.1.229
    passwd
    sudo apt-get update
    sudo apt-get upgrade

Install berryconda

    wget https://github.com/jjhelmus/berryconda/releases/download/v2.0.0/Berryconda3-2.0.0-Linux-armv7l.sh
    chmod +x Berryconda3-2.0.0-Linux-armv7l.sh
    ./Berryconda3-2.0.0-Linux-armv7l.sh
    # yes to echo 'export PATH=/home/pi/berryconda3/bin:$PATH' >> /home/pi/.bashrc
    source /home/pi/.bashrc
    rm Berryconda3-2.0.0-Linux-armv7l.sh

And install the requirements that fail with conda install ...

    pip install -r  ~/Coding/pedel2/requirements.txt
   
Make a SAMBA drive —nothing to do with server.

    sudo apt-get install samba samba-common-bin
    sudo nano /etc/samba/smb.conf
    sudo smbpasswd -a pi
    sudo /etc/init.d/samba restart

Make a /Coding/pedel2 folder and turn off Apache

    git clone https://github.com/matteoferla/pedel2.git
    sudo apt-get install libapache2-mod-wsgi-py3
    sudo a2enmod wsgi
    sudo nano /etc/apache2/sites-available/000-default.conf
    # changed a few things...
    sudo apache2ctl configtest
    sudo systemctl restart apache2