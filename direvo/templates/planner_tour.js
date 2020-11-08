<%page args="page"/>
// Instance the tour
window.tutorial = new Tour({
  framework: "bootstrap4",
  steps: [
  {
    element: ".card-header h1",
    title: "Aim",
    content: 'Plan your experiment to get a given amount of mutations before doing an ${page.term_helper('epPCR')|n} or predict what you may get from your PCR yield.',
    placement: 'bottom',
      onShown: function (tour) {
        $('[data-toggle="tooltip"]').tooltip({container: '.popover'});
    }
  },
  {
    element: "#planner_method",
    title: "Mode",
    content: 'The app has two modes. In the planner mode, you have yet to do the epPCR and would like to know how much template to add in order to achieve a given ${page.term_helper('load')|n} (say 5 mutations on average).',
    placement: 'top',
    onShown: function (tour) {
        $('#planner_method').bootstrapSwitch('state', false, false);
        $('[data-toggle="tooltip"]').tooltip({container: '.popover'});
        planner_toggle(false);
    }
  },
  {
    element: "#planner_p_conc",
    title: "Plasmid concentration",
    content: 'In order to advice how much to add, the plasmid concentration (stock) is required, along with the size in kb of the plasmid.',
    placement: 'top'
  },
  {
    element: "#planner_p_size",
    title: "Plasmid size",
    content: 'For traditional library construction, do note that it is important to keep your plasmid size low, say under 5 kb, or your transformation efficiency will suffer, resulting in smaller libraries. If you are electroporating the epPCR amplicon for &lambda;Red recombineering with counterselecting with CRISPR, this does not apply.',
    placement: 'top'
  },
  {
    element: "#planner_t_size",
    title: "Template",
    content: 'Herein, by "template" the span amplified is intendended, while by "plasmid" the full DNA element containing the template (be it aDNA, cDNA, plasmid or gDNA).',
    placement: 'top'
  },
  {
    element: "#planner_sequence",
    title: "Template sequence",
    content: 'The template sequence is required for PedelAA calculations. If omitted please add template size instead. These will result in only concentrations calculations.',
    placement: 'top'
  },
  {
    element: "#planner_y_conc",
    title: "Guestimate your yield",
    content: 'In order to calculate how much DNA to add as the template it is necessary to guess how much DNA you will get out. Please be aware that yields are lower for epPCR reactions than Q5 or KOD, therefore be conservative. <i>e.g.</i> 20 µl at 100 ng/µl or even lower.',
    placement: 'left'
  },
  {
    element: "#planner_m_load",
    title: "Desired mutational load",
    content: "This is how many mutations you would like to have on average at the DNA level. Start with five and inspect your sublibrary composition in your results. Ideally you want to minimise redundancy (shown next with Demo values). See <a href='/main/glossary#target'>FAQ</a> for more discussion about what is a good number of mutations to aim for.",
    placement: 'top',
    onShown: function (tour) {
        $('#planner_demo').trigger('click');
        $('#planner_calculate').trigger('click');
    }
  },
  {
    element: "#planner_results",
    title: 'Diversity and redundancy',
    content: 'In blue are the unique variants, while in orange the redundancy. Some redundancy is unavoidable. Tweak the numbers and see how it changes.',
    placement: 'top',
    onShown: function (tour) {
        $('.nav-tabs li:nth-child(3) a').tab('show');
    }
  },
  {
    element: "#planner_m_rate",
    title: 'Error rate',
    content: 'Number of mutations per kb per duplication. Method specific: for mutazyme use 0.9, for manganese you need to calculate based on previous experiments, but roughly use 1-5 depending on mM Mn2+ concentration (it is not really linear, see FAQ how to calculate).',
    onShown: function (tour) {
        $('#planner_clear').trigger('click');
    }
  },
  {
    element: "#planner_size",
    title: 'Libary size',
    content: 'Expected library size. For a plasmid under 5 kb and a library made by restriction or user cloning with some a dozen electroporations expect 1,000,000 variants, but if your plasmid is bigger, you are using chemically competent cells, or are using Gibson cloning, lower the value accordingly. If you are using &lambda;Red/CRISPR go roughly for cells electroporated &times; copy number/(10 &times; aDNA size/100 bp).'
  },
  {
    element: ".order-2",
    title: 'Mutational spectrum',
    content: 'The expected distribution of mutation types (e.g. A to C): choose from one of the presets or add your own prediction. Different epPCR result in different mutational spectra, see <a href="/main/glossary#epPCR">what epPCR methods to use</a> for more.'
  },
  {
    element: "#planner_method",
    title: "Verification Mode",
    content: 'The second mode of the app is verifcation. In this mode, you have done the epPCR and would like to know how many mutations you can expect when you get your sequencing back.',
    placement: 'top',
    onShown: function (tour) {
        $('#planner_method').bootstrapSwitch('state', true, true);
        planner_toggle(true);
    }
  },
  {
    element: "#planner_t_ng",
    title: 'Alternative input options',
    content: 'This mode has two different alternative ways to input the template and yield data.'
  },
  {
    element: "#planner_loss",
    title: 'Alternative input options',
    content: 'This mode has the extra input to correct for product loss upon purification. A rough estimate: 50% for gel extraction, 80% for Qiaquick. Alter the number by ear if you suspect loss due to spills etc. This value is unrelated to the amount of off-target aplicon (e.g. primer dimer) you reckon you got.'
  },
  {
    element: "#planner_calculate",
    title: 'More',
    content: 'For more information, visit the FAQ about <a href="/main/glossary#library">what makes a good library</a>, <a href="/main/glossary#epPCR">what epPCR methods to use</a> and <a href="/main/glossary#target">what is a good desired mutational load</a>.'
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