//<%page args="page"/>

// Instance the tour
window.tutorial = new Tour({
    steps: [{
        element: ".card-header h1",
        title: "Method",
        content: 'Given a sequence, mutational spectrum and mutational load, it will say how redundant is the library from an amino acid point of view.',
        placement: 'bottom'
      },{
        element: "#pedelAA_sequence",
        title: "DNA sequence",
        content: 'In frame sequence that was mutagenised. Note that all symbols that aren&apos;t uppecase ATUGC, will be discarded along with a Fasta header (<i>e.g.</i> &apos;&gt;T. maritima Cystathionine &#x3B2;-lyase&apos;), therefore for masked sequences use lowercase.'
      },{
        element: "#pedelAA_size",
        title: "Library size",
        content: 'Like elsewhere, library size is the number of variants counted or estimated after the library construction transformation. This is not the population size of the culture or calculated from a <a href="/main/glossary#retransformation">retransformation</a>.'
      },{
        element: "#mutTable_raw",
        title: "Mutational spectrum",
        content: 'Input your mutational spectrum. This can be determined automatically from your data using <a href="/main/mutanalyst">Mutanalyst</a>. '
      },{
        element: "#",
        title: "",
        content: ''
      },{
        element: "#",
        title: "",
        content: ''
      }
    ],
    backdrop: true
});

// Initialize the tour
tutorial.init();

$('#tour').click(function () {
    tutorial.restart();
    // Start the tour
    //tutorial.start();
});