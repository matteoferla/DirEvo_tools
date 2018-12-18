<%page args="page"/>
// Instance the tour
window.tutorial = new Tour({
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
    content: 'The inframe sequence that was mutated. If the sequencing is within larger coding region, only add that (and alter the output numbering according). Either cases are accepted. Tolerates spaces and most non-nucleobase letters.',
    placement: 'top'
  },
  {
    element: "#MC_sigma",
    title: "Noise tollerance",
    content: 'Whereas anything called differently or as a degenerate base in the AB1 automatic calling is interpreted, secondary peaks are only considered if they are above a given background noise threshold, set via this value.',
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