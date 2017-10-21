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
        $('#MC_sequence').val('GTGGAACAGGATGTGGTGTTTAGCAAAGTGAATGTGGCTGGCGAGGAAATTGCGGGAGCGAAAATTCAGTTGAAAGACGCGCAGGGCCAGGTGGTGCATAGCTGGACCAGCAAAGCGGGCCAAAGCGAAACCGTGAAGCTGAAAGCCGGCACCTATACCTTTCATGAGGCGAGCGCACCGACCGGCTATCTGGCGGTGACCGATATTACCTTTGAAGTGGATGTGCAGGGCAAAGTTACAGTGAAAGATgcgaatGGCAATGGTGTGAAAGCGGAG');
        $("#MC_direction").bootstrapSwitch('state',false);
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
        data.append("reverse", !$('#MC_direction').is(":checked"));
        $.ajax({
            url: '/ajax_MC',
            type: 'POST',
            data: data,

            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('MC', JSON.stringify(reply['data']));
                $("#MC_download").removeClass('hidden');
                $("#MC_download").show(); //weird combo.
                $("#MC_result").html(reply['html']);
                //traces
                bases = ['A', 'T', 'G', 'C'];
                for (var mi = 0; mi < reply['data']['raw'].length; mi++) {
                    // interate per mutation
                    var raw_trace = bases.map(function(base) {
                        return {
                            x: Array.apply(null, {
                                length: reply['data']['raw'][mi][base].length
                            }).map(Number.call, Number),
                            y: reply['data']['raw'][mi][base],
                            name: base,
                            type: 'scatter',
                            line: {
                                color: chromatomap[base]
                            }
                        };
                    });
                    // resi labels. oddly xref page causes issues.
                    residue_labels=[];
                    intm=Math.max(...reply['data']['raw'][mi]['A'],...reply['data']['raw'][mi]['T'],...reply['data']['raw'][mi]['G'],...reply['data']['raw'][mi]['C']);
                    for (var ri=0; ri<reply['data']['window_seq'][mi].length; ri++){
                        residue_labels.push({
                        x: ri*reply['data']['raw'][mi]['A'].length/11 + reply['data']['raw'][mi]['A'].length/22,
                        y: intm * 1.05,
                        xanchor: 'center',
                        yanchor: 'middle',
                        text: reply['data']['window_seq'][mi][ri],
                        showarrow: false,
                        });
                    }
                    for (var di=0; di<reply['data']['differing'][mi].length; di++) {
                        residue_labels[reply['data']['differing'][mi][di]].showarrow=true;
                    }
                    Plotly.newPlot('MC_mutant_'+mi.toString(), raw_trace, {
                    title: '{0} chromatogram data ({1} to {2})'.format(reply['data']['mutants'][mi],reply['data']['codons'][mi][0],reply['data']['codons'][mi][1]),annotations: residue_labels});
                }//end of traces.
                var noise = ['main_peaks','minor_peaks'].map(function(k) {return {
                            x: Array.apply(null, {
                                length: reply['data']['noise'][k].length
                            }).map(Number.call, Number),
                            y: reply['data']['noise'][k],
                            name: k,
                            type: 'scatter',
                        };});
                Plotly.newPlot('MC_noise',noise,{title: 'Noise across read (SNR={0})'.format(Math.round(reply['data']['noise']['snr']))});



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