<%page args="page"/>
// Instance the tour
window.tutorial = new Tour({
  framework: "bootstrap4",
  steps: [
  {
    element: ".card-header h1",
    title: "Aim",
    content: 'This app identify the point mutations in an ab1 file, including sites where there is a secondary peak above a given threshold. The reason being is that occassionally heteroduplex',
    placement: 'bottom',
      onShown: function (tour) {
        $('[data-toggle="tooltip"]').tooltip({container: '.popover'});
    }
  },
  {
    element: "#MC_sequence",
    title: "Sequnece",
    content: 'The inframe WT sequence that was mutated. If the sequencing is within larger coding region, only add that (and alter the output numbering according). Either cases are accepted. Tolerates spaces and most non-nucleobase letters.',
    placement: 'top'
  },
  {
    element: "#MC_upload_group",
    title: "AB1 trace",
    content: 'The trace file.',
    placement: 'top'
  },
  {
    element: "#MC_sigma",
    title: "Noise tollerance",
    content: 'Whereas anything called differently or as a degenerate base in the AB1 automatic calling is interpreted, secondary peaks are only considered if they are above a given background noise threshold, set via this value.',
    placement: 'top',
      onShown: function (tour) {
        $('#MC_demo').trigger('click');
        $('#MC_sigma').val(3);
        $('#MC_calculate').trigger('click');
      }
  },
      {
    element: "#MC_results",
    title: "Full or mixed?",
    content: 'The mutation can be a full peak or a minor peak that is stronger than background (cf. noise sigma setting)',
    placement: 'top'
  },
  {
    element: "#MC_pdb_code",
    title: "Structure",
    content: 'Additionally, where the mutations fall on can be mapped on the chain A of a protein.',
    placement: 'top'
  },
  {
    element: "#MC_viewer",
    title: "Structure (continued)",
    content: 'and inspected interactively.',
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