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
        data.append("sigma",3); //to be encoded.
        $.ajax({
            url: '/ajax_MC',
            type: 'POST',
            data: data,

            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('MC', JSON.stringify(reply['data']));
                var data=reply['data'];
                $("#MC_download").removeClass('hidden');
                $("#MC_download").show(); //weird combo.
                $("#MC_result").html(reply['html']);
                //traces
                bases = ['A', 'T', 'G', 'C'];

                plot_mutants=function(variants,prefix) {
                    for (var mi = 0; mi < variants['raw'].length; mi++) {
                    // interate per mutation
                    var raw_trace = bases.map(function(base) {
                        return {
                            x: Array.apply(null, {
                                length: variants['raw'][mi][base].length
                            }).map(Number.call, Number),
                            y: variants['raw'][mi][base],
                            name: base,
                            type: 'scatter',
                            line: {
                                color: chromatomap[base]
                            }
                        };
                    });
                    // resi labels. oddly xref page causes issues.
                    residue_labels=[];
                    pos_labels=[];
                    intm=Math.max(...variants['raw'][mi]['A'],...variants['raw'][mi]['T'],...variants['raw'][mi]['G'],...variants['raw'][mi]['C']);
                    for (var ri=0; ri<variants['window_seq'][mi].length; ri++){
                        residue_labels.push({
                        x: ri*variants['raw'][mi]['A'].length/11 + variants['raw'][mi]['A'].length/22,
                        y: intm * 1.05,
                        xanchor: 'center',
                        yanchor: 'middle',
                        text: variants['window_seq'][mi][ri],
                        showarrow: false,
                        });
                        pos_labels.push({
                        x: ri*variants['raw'][mi]['A'].length/11 + variants['raw'][mi]['A'].length/22,
                        y: intm * 0.95,
                        xanchor: 'center',
                        yanchor: 'middle',
                        text: variants['window_subseq'][mi][ri],
                        showarrow: false,
                        font:{
                            size: 8,
                            color: 'gainsboro'
                          }
                        });
                    }
                    for (var di=0; di<variants['differing'][mi].length; di++) {
                        pos_labels[variants['differing'][mi][di]]['font']['color']='red';
                    }
                    Plotly.newPlot(prefix+mi.toString(), raw_trace, {
                    title: '{0} chromatogram data ({1} to {2})'.format(variants['mutants'][mi],variants['codons'][mi][0],variants['codons'][mi][1]),annotations: [...residue_labels,...pos_labels]});
                }//end of traces.
                };
                plot_mutants(data['mutants'],'MC_mutant_');
                var noise = ['main_peaks','minor_peaks'].map(function(k) {return {
                            x: Array.apply(null, {
                                length: data['noise'][k].length
                            }).map(Number.call, Number),
                            y: data['noise'][k],
                            name: k,
                            type: 'scatter',
                        };});
                Plotly.newPlot('MC_noise',noise,{title: 'Noise across read (SNR={0})'.format(Math.round(data['noise']['snr']))});



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