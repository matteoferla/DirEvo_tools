//<%page args="page"/>

// Instance the tour
window.tutorial = new Tour({
  framework: "bootstrap4",
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
      }, {
        element: "#mutTable_raw",
        title: "Mutational spectrum",
        content: 'Input your mutational spectrum. This can be determined automatically from your data using <a href="/main/mutanalyst">Mutanalyst</a>. ',
        onShown: function (tour) {
            $('#pedelAA_demo').trigger('click');
            $('#pedelAA_calculate').trigger('click');
        }
    }, {
        element: '#pedelAA_result',
        title: 'Summary',
        content: 'This tab contants all the summary details of your library',
        onShown: function (tour) {$('#tablist a[href="#pedelAA_result_main"]').tab('show');},
        placement: 'top'
        }, {
        element: '#pedelAA_result',
        title: 'Sub table composition',
        content: 'This tab shows the composition of your library',
        onShown: function (tour) {
            $('#tablist a[href="#pedelAA_result_sub"]').tab('show');
        },
        placement: 'top'
    }, {
        element: '#pedelAA_result',
        title: 'Sub table composition plotted',
        content: 'This tab shows the same data, but plotted on a graph',
        onShown: function (tour) {$('#tablist a[href="#pedelAA_result_graph"]').tab('show');},
        placement: 'top'

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