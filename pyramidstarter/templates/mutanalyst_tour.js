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
    element: "#sequence",
    title: "Sequence",
    content: 'The WT in frame <i>nucleotide</i> sequence that was mutated.',
    placement: 'top'
  },
  {
    element: "#baseList",
    title: "Mutations found",
    content: 'List of the mutations found.<br/>Each line contains one or more mutations for each variant sampled.<br/>',
    placement: 'top'
  },
    {
    element: "#baseList",
    title: "Format",
    content: 'The &apos;lines&apos; are separated by a new-line (Enter on Win), carriage return (Enter on Mac), both (Enter on Linux) or semicolon (MatLab style).<br/>'+
        'The mutations on each line are separated by a space, tab or comma, but not non-breaking space, hyphens, dashes or dots.<br/>'+
        'The mutations can only be in the forms 123A&gt;C, or A123C (technically non-standard for nucleotides), where the number is actually irrelevant (and can be omitted).',
    placement: 'top'
  },
    {
    element: "#baseList",
    title: "Wildtypes",
    content: 'A wild type sequence must be indicated &mdash;it is not needed for the mutational spectrum, but it is for the load.<br/>'+
        'A wild type sequence is indicated with &apos;wt&apos; or &apos;WT&apos; or &apos;wild&apos;, but not as an identity 123A&gt;A as that will count as a mutation (roundtrip)',
    placement: 'top'
  },
      {
    element: "#baseList",
    title: "Frameshifts",
    content: 'Rarer events such as insertions, deletion, duplications, frameshifts and inversions, are not taken into account, but their frequency can be easily calculated using the &apos;values for further analysis&apos; below.',
    placement: 'top'
  },

  {
    element: "#library_size",
    title: "library size",
    content: 'The libary size is not required to estimate the load and spectrum of the mutations, but it is needed for amino acid composition calculations (PedelAA app), therefore if omitted the latter will be absent)',
    placement: 'top',
      onShown: function (tour) {
          $('#mutanalyst_freq_demo').trigger('click');
          $('#mutanalyst_freq_calculate').trigger('click');
      }
  },
  {
    element: "#freqMean",
    title: "Average number of mutations",
    content: '<p>The simplest and most commonly employed estimate of the frequency of mutations per sequence is the average of the point mutations per sequence (<i>m</i>), however due to the small sample size this may be off. Hence why the number to look at is the Poisson &lambda;</p>',
    placement: 'top'
  },
  {
    element: "#freqλ",
    title: "Estimated mean number of mutations",
    content: 'The distribution of number of mutations per sequence follows a Poisson distribution. By fitting to this single parameter curve one gets a better value.',
    placement: 'top'
  },
    {
    element: "#disChart",
    title: "Distribution",
    content: 'This distribution of mutations per sequence (load) show whether your distribution looks as expected.',
    placement: 'top'
  },
    {
    element: "#altH",
    title: "Tweak",
    content: 'Here you can alter the mutational spectrum you found &mdash;not normally neccessary, but you may have a specific reason to do so.',
    placement: 'top',
        onShown: function (tour) {
          $("#altH_showing_button_on").trigger('click');
        }
  },
  {
    element: "#mutBlabla",
    title: "Mutational spectrum",
    content: 'This table shows what kinds of mutations you have.',
    placement: 'top'
  },
  {
    element: "#Layer_1",
    title: "Mutational spectrum",
    content: 'This diagram shows the same data in graphical form. The thickness of the arrows represents the frequency of that mutation. Ideally, an equiprobable spectrum is desired and all the arrows would be equally thick.',
    placement: 'top'
  },
    {
    element: "#biasTable",
    title: "Mutational biases",
    content: 'Here are several indicators which show how biased the mutational spectrum is (<i>i.e.</i> how far from an equiprobable spectrum).',
    placement: 'top'
  },
    {
    element: "#pedelAA_result",
    title: "PedelAA",
    content: 'If library size is specified, the library redundancy is calculated with PedelAA',
    placement: 'top'
  }




  ],
    backdrop: true,
    orphan: true
});


// Initialize the tour
tutorial.init();

$('#tour').click(function () {
    tutorial.restart();
    // Start the tour
    //tutorial.start();
});