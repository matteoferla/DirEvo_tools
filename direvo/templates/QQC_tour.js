//<%page args="page"/>
// Instance the tour
window.tutorial = new Tour({
  framework: "bootstrap4",
  steps: [
  {
    element: ".card-header h1",
    title: "Aim",
    content: 'This tool allows you determine the distribution of mutations in a randomised codon from a sequenced pooled sample. ' +
        'For more see <a href="#overview_modal" data-toggle="modal" data-target="#overview_modal">background</a>',
    placement: 'bottom'
  },
  {
    element: "#QQC_upload_group",
    title: "Upload",
    content: 'Upload sequencing file (.ab1)'
  },
  {
    element: "#QQC_preceding",
    title: "Upstream",
    content: 'The program needs to know where the mutation is. Therefore please add the sequence preceeding the codon in the same frame and direction as the mutation. ' +
        'It is very important that you specify correctly the reading direction. The ratios would be the same but the predicted amino acid out would be scrambled.'
  },
  {
    element: "#QQC_mutation",
    title: "Codon",
    content: 'The codon that was mutated. If multiple codons were mutated, do one at the time. Each is independent' +
        'If the codon was mutated with a single primer with degenerate bases simply write the three letters. ' +
        'If multiple primers in ratio prefix the codons with the fractional amount and separate them with a space.'
  },
  {
    element: "#QQC_direction",
    title: "Direction",
    content: 'This is direction relative to sequencing. Forward primer > forward. Reverse primer > reverse.'
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