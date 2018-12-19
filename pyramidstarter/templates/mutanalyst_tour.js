<%page args="page"/>

// Instance the tour
window.tutorial = new Tour({
  steps: [
  {
    element: "#mutanalyst_method",
    title: "Method",
    content: 'There are two possible starting points for mutanalysts. In this mode ("Mutations"), a sequence and the mutations sampled are submitted and the ${page.term_helper("load","mutational load")|n},'+
             '${page.term_helper("spectrum","mutational spectrum")|n} and the ${page.term_helper("bias","mutational bias indicators")|n} will be calculated.',
    placement: 'left',
      onShown: function (tour) {
        $('[data-toggle="tooltip"]').tooltip({container: '.popover'});
        $('#mutanalyst_method').bootstrapSwitch('state', true, true);
    }
  },
  {
    element: "#mutanalyst__sequence",
    title: "Sequence",
    content: 'The WT in frame nucleotide sequence that was mutated.',
    placement: 'top'
  },
  {
    element: "#library_size",
    title: "library size",
    content: 'The libary size is not required to estimate the load and spectrum of the mutations, but it is needed for amino acid composition calculations (PedelAA app), therefore if omitted the latter will be absent)',
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