$('#planner_results').hide();
applyLoad([[0, 15, 9, 2],[15, 0, 2, 9],[13, 7, 0, 2],[7, 13, 2, 0]]);
//PedelAA
function applyLoad(data) {
var bases=['A','T','G','C'];
    for (var fi=0; fi<4; fi++) { //from
        for (var ti=0; ti<4; ti++) { //to
            $("#{0}2{1}".format(bases[fi],bases[ti])).val(data[fi][ti]);
        }
    }
}
$("#planner_opt_mutazyme").click(function () {applyLoad([[0, 15, 9, 2],[15, 0, 2, 9],[13, 7, 0, 2],[7, 13, 2, 0]]);});
$("#planner_opt_manganese").click(function () {applyLoad([[0, 20, 14, 4],[20, 0, 4, 14],[7, 2, 0, 1],[2, 7, 1, 0]]);});
$("#planner_opt_MP6").click(function () {applyLoad([[0,3,,15,8],[3,0,8,16],[13,8,0,2],[7,17,0,0]]);});
$("#planner_opt_D473G").click(function () {applyLoad([[0,5,8,5],[14,0,0,5],[9,4,0,2],[3,6,3,0]]);});
$("#planner_opt_analogues").click(function () {applyLoad([[0,0,27,6],[0,0,2,54],[11,0,0,0],[0,6,0,0]]);});
$("#planner_opt_uniform").click(function () {applyLoad([[0,8.3,8.3,8.3],[8.3,0,8.3,8.3],[8.3,8.3,0,8.3],[8.3,8.3,8.3,0]]);});
$('#planner_sequence_retrieve').click(function () {
    $('#planner_sequence').val(window.sessionStorage.getItem('sequence'));
});
$('#planner_retrieve_spectrum').click(function () {
    applyLoad(JSON.parse(window.sessionStorage.getItem('spectrum')));
});




function planner_toggle(state) {
    if (state) {
    // verify
    $('.planner-verify').show();
    $('.planner-plan').hide();
    $('#planner_method').attr('state',"on"); //hack
    }
    else {
        // plan
        $('.planner-verify').hide();
        $('.planner-plan').show();
        $('#planner_method').attr('state',"off");

    }
}
planner_toggle($('#planner_method').checked);
$('#planner_method').on('switchChange.bootstrapSwitch', function(event, state) {planner_toggle(state)});


// copied from pedelAA
function replot(data) {
    var ver = 'pedelAA'; // hardcoded.
    var layout = {
                yaxis: {
                    title: 'Number of mutants in each bin',
                    type: 'lin',
                    autorange: true
                },
                xaxis: {
                    title: 'x, Exact number of mutations per sequence',
                    type: 'lin',
                    autorange: true
                },bargap:0,barmode: 'stack'
            };
    if ($("#"+ver+"_plot_log").is(":checked")) {
            layout['yaxis']['type'] = 'log';
        }
    var m = $('input[name=plotopt]:radio:checked').val();
    var x = data.map(function(x) {
                return x[0]});
    if (m == 0) {
        //Combined.
        if (ver == 'pedelAA') {
        locs=[5, 7];}
        else {
        locs=[4, 6];}
        var y1 = data.map(function(x) {
                return x[locs[0]]});
        var y2 = data.map(function(x) {
                return x[locs[1]]});
        Plotly.newPlot('plot_'+ver+'_stats', [{
            x: x,
            y: y1,
            name: 'Unique diversity (Cx)',
            type: 'bar'
        },{
            x: x,
            y: y2,
            name: 'Redundant diversity (Lx − Cx)',
            type: 'bar'
        },], layout);
    }
    else {
        // individual
        var y = data.map(function(x) {
                return x[m]});
        Plotly.newPlot('plot_'+ver+'_stats', [{
            x: x,
            y: y,
            type: 'bar'
        }], layout);
    }

}
// end of copy

function sanify_fasta(seq) {
    console.log(seq);
    // kill the >header if present.
    if (seq.includes('>')) {var parts= seq.split("\n"); seq=parts.join();}
    seq=seq.toUpperCase().replace('U','T').replace(/[^ATGC]/g, "");
    console.log(seq);
    return seq;
}

function validator (list) {
        if (list.every(function (value) {return data[value] != ''})) {
            return true;
        }
        else {
            $(list.map(function (value) {return '#planner_'+value})).each(function (i,v) {
                    if ($(v).val()) {$(v).addClass('is-valid');}
                    else {
                        $(v).addClass('is-invalid');
                        $('#planner_results').append("<div class='alert alert-warning'>Incomplete input ("+v+")</div>");
                        console.log(v+' has no data.');
                    }
                });
            throw "Incomplete ";
        }

    }

$('#planner_demo').click(function () {
    $('.is-valid').removeClass('is-valid');
    $('.is-invalid').removeClass('is-invalid');
    data={'t_size':0.5,'p_size':5,'p_conc':50,'p_vol':1,'y_conc':1000,'y_vol':20,'r_vol':50,'loss':50,'m_rate':0.9,'m_load':5};
    for (var p in data) {
        $('#planner_'+p).val(data[p]);
    }
});

$('#planner_clear').click(function () {
    $('#planner_results').hide();
    $('.is-valid').removeClass('is-valid');
    $('.is-invalid').removeClass('is-invalid');
    data={'t_size':0.5,'p_size':5,'p_conc':50,'p_vol':1,'y_conc':1000,'y_vol':20,'r_vol':50,'loss':50,'m_rate':0.9,'m_load':5};
    for (var p in data) {
        $('#planner_'+p).val('');
    }
});

$('#planner_calculate').click(function () {
    $('#planner_results').show();
    $('#planner_results').html('');
    $('#planner_results').append('<h3>Results</h3>');
    $('.is-valid').removeClass('is-valid');
    $('.is-invalid').removeClass('is-valid');
    // parse data
    var data={};
    var template, product;
    $('input').each(function (i,v) {
        var name=$(v).attr('id');
        var m=name.match(/planner_(.*)/);
                if (m) {
                    data[m[1]] = parseFloat($(v).val());
                }
    });
    data['PCR_mode']='Poisson';
    data['sequence']=$('#planner_sequence').val();
    var bases=['A','T','G','C'];
    for (var fi=0; fi<4; fi++) { //from
        for (var ti=0; ti<4; ti++) { //to
            var name="{0}2{1}".format(bases[fi],bases[ti]);
            data[name]=$('#'+name).val();
        }
    }
    console.log(data)
    // validation...
    $('#planner_p_conc,#planner_t_size,#planner_p_size').each(function (i,v) {
                    if ($(v).val()) {$(v).addClass('is-valid'); $(v).removeClass('is-invalid');}
                    else {$(v).removeClass('is-valid'); $(v).addClass('is-invalid');}
                });

    // sanity sequence
    if (! data['t_ng']) {
            validator(['p_conc', 'p_vol', 'p_size']); //, 't_size'
            if (! data['sequence']) {
                data['sequence']=sanify_fasta(data['sequence']);
                data['t_size'] = data['sequence'].length;
            } else if (! data['t_size']) {
                // pass. It will fail the pedelAA.
            } else {validator(['sequence']);}
            if (data['p_size'] < data['t_size']) {
                $('#planner_results').append('<div class="alert alert-danger" role="alert">Your plasmid is smaller than your insert.</div>');
            }
            template = parseFloat(data['p_conc']) * parseFloat(data['p_vol']) * parseFloat(data['t_size']) / parseFloat(data['p_size']);
        }
            else {
           template=parseFloat(data['t_ng']);
        }

    // determine state of switch for method (non=standard code)
    if ($('#planner_method').attr('state') == 'on') {
        // verify method
        // parse template
        // parse yield
        if (! data['y_ng']) {
            validator(['y_conc', 'y_vol']);
            product = parseFloat(data['y_conc']) * parseFloat(data['y_vol']);
        }
            else {
           product = parseFloat(data['y_ng']);
        }
        // other
        validator(['r_vol', 'loss','m_rate']);
        // calc
        var cProd = product/(parseFloat(data['loss'])/100);
        data['duplications']=Math.log2(cProd/template);
        data['load']=data['duplications']*parseFloat(data['m_rate']);
        $('#planner_results').append(['<p>','<b>Template:</b>',template.toString(),'ng;',
                                            '<b>Yield:</b>',cProd.toString(),'ng;',
                                            '<b>Duplications:</b>',(Math.round(data['duplications']*10)/10).toString(),'times;',
                                            '<b>Mutational load:</b>',(Math.round(data['load']*10)/10).toString(),'mutations.',
            '</p>'].join(' '));
    }
    else {
        // plan method
        validator(['p_conc', 't_size', 'p_size','y_ng', 'm_load', 'loss','m_rate']);
        if (data['p_size'] < data['t_size']) {
            $('#planner_results').append('<div class="alert alert-danger" role="alert">Your plasmid is smaller than your insert.</div>');
        }
        data['load'] = parseFloat(data['m_load']);
        var product = data['y_ng']; //ug
        data['duplications'] = data['load'] / parseFloat(data['m_rate']);
        var template = product /Math.pow(2,data['duplications']);
        var plasmid = template / parseFloat(data['t_size']) * parseFloat(data['p_size']);
        var volume = plasmid/parseFloat(data['p_conc']);
        var library = parseInt(data['lib']);
        $('#planner_results').append(['<p>','<b>Plasmid:</b>',(Math.round(plasmid*10)/10).toString(),'ng;',
                                            '<b>Stock volume:</b>',(Math.round(volume*10)/10).toString(),'µL;',
                                            '<b>Template:</b>',(Math.round(template*10)/10).toString(),'ng;',
                                            '<b>Yield:</b> JS defined',product.toString(),'ng;',
                                            '<b>Library size:</b> JS defined',library.toString(),'ng;',
                                            '<b>Duplications:</b>',(Math.round(data['duplications']*10)/10).toString(),'times;',
                                            '<b>Mutational load:</b>',(Math.round(data['load']*10)/10).toString(),'mutations.',
            '</p>'].join(' '));
    }
    if (!! data['p_size'] && data['p_size'] >5) {$('#planner_results').append('<div class="alert alert-warning" role="alert">Cell transformation efficiency decreases if the plasmid is over 5 kb. Reduce the library size accordingly.</div>');}
    if (!! data['duplications'] && data['duplications'] >30) {$('#planner_results').append('<div class="alert alert-warning" role="alert">The number of duplications is close to the number of PCR cycles.</div>');}

    //pedelAA
    try {   $('#planner_results').append('<div id="pedelAA_result"></div>');
            data['nucnorm']=0;
            data['distr']='Poisson';
            $.ajax({
                url: '/ajax_pedelAA',
                type: 'POST',
                dataType: 'json',
                data: JSON.stringify(data),
                success: function(result) {
                    reply = JSON.parse(result.message);
                    window.sessionStorage.setItem('pedelAA', JSON.stringify(reply['data']));
                    // copy paste!   x	Vx_1	Vx_2	Rx	Lx	Cx
                    $("#pedelAA_result").html(reply['html']);
                    $("#pedelAA_plot_log").bootstrapSwitch();
                    replot(reply['data'], 'pedelAA');
                    $('#plotoptdiv input').on('change', function() {
                        replot(reply['data'], 'pedelAA');
                    });
                    $('#pedelAA_plot_log').on('switchChange.bootstrapSwitch', function(event, state) {
                        replot(reply['data'], 'pedelAA');
                    });
                },
                error: function(xhr) {
                    $("#pedelAA_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span>Oh Snap. Ajax error ({0})</h3><pre><code>{1}</pre><code></div>'.format(xhr.status, escapeHtml(xhr.responseText)));
                },
                cache: false,
                contentType: false,
                processData: false
            });
        } catch (err) {
            $("#pedelAA_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span> Client side error (<i>i.e.</i> something is wrong on your side)</h3><pre><code>{0}</pre><code></div>'.format(err.message));
        }
});

//input#planner_method.switch, input#planner_t_ng.form-control, input#planner_p_conc.form-control, input#planner_p_vol.form-control, input#planner_t_size.form-control, input#planner_p_size.form-control, input#planner_y_ng.form-control, input#planner_y_conc.form-control, input#planner_y_conc.form-control, input#planner_r_vol.form-control, input#planner_r_vol.form-control, input#planner_m_load.form-control, input#planner_m_rate.form-control, input#comment_name.form-control, prevObject: r.fn.init(1)]