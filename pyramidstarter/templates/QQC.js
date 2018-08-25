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
    $('#QQC_upload').on('change', function(event) {
        files = event.target.files;
        demo = false;
        $('#QQC_upload_group').removeClass('btn-warning');
        $('#QQC_upload_group').addClass('btn-success');
    });

    $('#QQC_demo').click(function() {
        demo = true;
        $('#QQC_upload_group').removeClass('btn-warning');
        $('#QQC_upload_group').addClass('btn-default');
        $('#QQC_preceding').val('CGT GAT TTT');
        $('#QQC_mutation').val('1NDT 9VHG 1TGG');
    })

    $('#QQC_clear').click(function() {
        demo = false;
        $('#QQC_upload_group').removeClass('btn-success');
        $('#QQC_upload_group').removeClass('btn-default');
        $('#QQC_upload_group').addClass('btn-warning');
        $('#QQC_preceding').val('');
        $('#QQC_mutation').val('');
        $("#QQC_result").hide();
    })


    $('#QQC_calculate').click(function() {
        $("#QQC_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
        $("#QQC_result").removeClass('hidden');
        $("#QQC_result").show(); //weird combo.
        var data = new FormData();
        if (demo) {
            data.append("file", 'demo');
        } else {
            data.append("file", files[0]);
        }
        data.append("location", $('#QQC_preceding').val());
        data.append("scheme", $('#QQC_mutation').val());
        data.append("reverse",! $('#QQC_direction').is(":checked"));
        $.ajax({
            url: '../ajax_QQC',
            type: 'POST',
            data: data,

            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('primers', JSON.stringify(reply['data']));
                $("#QQC_download").removeClass('hidden');
                $("#QQC_download").show(); //weird combo.
                $("#QQC_result").html(reply['html']);
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
                Plotly.newPlot('QQC_raw_plot', raw_trace, {
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
                Plotly.newPlot('QQC_pie', piedata, {
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

                Plotly.newPlot('QQC_bar', aadata, layout);


            },
            error: function() {
                $("#QQC_result").html('<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Nothing back.</div>');
            },
            cache: false,
            contentType: false,
            processData: false
        });
        return false;
    });
});