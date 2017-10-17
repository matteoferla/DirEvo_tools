$(function() {
    var files;
    var chromatomap = {
        A: 'rgb(0.4660, 0.6740, 0.1880)',
        T: 'rgb(0.8500, 0.3250, 0.0980)',
        G: 'rgb(0.3250,0.3250,0.3250)',
        C: 'rgb(0,0.4470,0.7410)'
    };
    var chromatomap256 = {
        A: 'rgb(119, 173, 48)',
        T: 'rgb(218, 83, 25)',
        G: 'rgb(83, 83, 83)',
        C: 'rgb(0, 114, 190)'
    };
    var demo = false;
    $('#MC_upload').on('change', function(event) {
        files = event.target.files;
        demo = false;
        $('#MC_upload_group').removeClass('btn-warning');
        $('#MC_upload_group').addClass('btn-success');
    });

    $('#MC_demo').click(function() {
        demo = true;
        $('#MC_upload_group').removeClass('btn-warning');
        $('#MC_upload_group').addClass('btn-default');
        $('#MC_sequence').val('oh bugger. I have not loaded a demo file yet.');
    })

    $('#MC_clear').click(function() {
        demo = false;
        $('#MC_upload_group').removeClass('btn-success');
        $('#MC_upload_group').removeClass('btn-default');
        $('#MC_upload_group').addClass('btn-warning');
        $('#MC_sequence').val('');
        $("#MC_result").hide();
    })


    $('#MC_calculate').click(function() {
        $("#MC_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
        $("#MC_result").removeClass('hidden');
        $("#MC_result").show(); //weird combo.
        var data = new FormData();
        if (demo) {
            data.append("file", 'demo');
        } else {
            data.append("file", files[0]);
        }
        data.append("sequence", $('#MC_sequence').val());
        $.ajax({
            url: '../ajax_MC',
            type: 'POST',
            data: data,

            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('primers', JSON.stringify(reply['data']));
                $("#MC_download").removeClass('hidden');
                $("#MC_download").show(); //weird combo.
                $("#MC_result").html(reply['html']);
                //traces
                bases = ['A', 'T', 'G', 'C'];
                var raw_trace = bases.map(function(base) {
                    return {
                        x: Array.apply(null, {
                            length: reply['data']['raw'][base].length
                        }).map(Number.call, Number),
                        y: reply['data']['raw'][base],
                        name: base,
                        type: 'scatter',
                        line: {
                            color: chromatomap[base]
                        }
                    };
                });
                Plotly.newPlot('MC_raw_plot', raw_trace, {
                    title: 'Raw chromatogram data'
                });

                //piecharts
                cm2 = bases.map(function(base) {
                    return chromatomap256[base]
                });
                piedata = [{
                    values: bases.map(function(base) {
                        return reply['data']['nt'][0][base]
                    }),
                    labels: bases,
                    type: 'pie',
                    marker: {
                        colors: cm2
                    },
                    domain: {
                        x: [0, 0.30],
                        y: [0, 1]
                    }
                }, {
                    values: bases.map(function(base) {
                        return reply['data']['nt'][1][base]
                    }),
                    labels: bases,
                    type: 'pie',
                    marker: {
                        colors: cm2
                    },
                    domain: {
                        x: [0.35, 0.65],
                        y: [0, 1]
                    }
                }, {
                    values: bases.map(function(base) {
                        return reply['data']['nt'][2][base]
                    }),
                    labels: bases,
                    type: 'pie',
                    marker: {
                        colors: cm2
                    },
                    domain: {
                        x: [0.70, 1],
                        y: [0, 1]
                    }
                }]
                Plotly.newPlot('MC_pie', piedata, {
                    title: 'Frequency at each position (non-deconvoluted'
                });
                //AA
                AA = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y', '*'];
                var aadata = [{
                    x: AA,
                    y: AA.map(function(a) {
                        return reply['data']['AAscheme'][a]
                    }),
                    name: 'Expected',
                    type: 'bar'
                }, {
                    x: AA,
                    y: AA.map(function(a) {
                        return reply['data']['AAemp'][a]
                    }),
                    name: 'Observed',
                    type: 'bar'
                }];

                var layout = {
                    barmode: 'group',
                    title: 'Pedicted amino acid proportions (deconvoluted)'
                };

                Plotly.newPlot('MC_bar', aadata, layout);


            },
            error: function() {
                $("#MC_result").html('<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Nothing back.</div>');
            },
            cache: false,
            contentType: false,
            processData: false
        });
        return false;
    });
});