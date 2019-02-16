$('#pedel_note').modal('hide');

formids = ['size', 'len', 'mutload', 'distribution', 'cycles', 'efficiency'];

function replot(data, ver='pedel') {
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

$('#pedelAA_§cycles').hide();
$('#pedelAA_PCR').on('switchChange.bootstrapSwitch', function(event, state) {
    $('#pedelAA_§cycles').toggle(state);
});
//PedelAA
function applyLoad(data) {
var bases=['A','T','G','C'];
    for (var fi=0; fi<4; fi++) { //from
        for (var ti=0; ti<4; ti++) { //to
            $("#{0}2{1}".format(bases[fi],bases[ti])).val(data[fi][ti]);
        }
    }
}
$("#pedelAA_opt_mutazyme").click(function () {applyLoad([[0, 15, 9, 2],[15, 0, 2, 9],[13, 7, 0, 2],[7, 13, 2, 0]]);});
$("#pedelAA_opt_manganese").click(function () {applyLoad([[0, 20, 14, 4],[20, 0, 4, 14],[7, 2, 0, 1],[2, 7, 1, 0]]);});
$("#pedelAA_opt_MP6").click(function () {applyLoad([[0,3,,15,8],[3,0,8,16],[13,8,0,2],[7,17,0,0]]);});
$("#pedelAA_opt_D473G").click(function () {applyLoad([[0,5,8,5],[14,0,0,5],[9,4,0,2],[3,6,3,0]]);});
$("#pedelAA_opt_analogues").click(function () {applyLoad([[0,0,27,6],[0,0,2,54],[11,0,0,0],[0,6,0,0]]);});
$("#pedelAA_opt_uniform").click(function () {applyLoad([[0,8.3,8.3,8.3],[8.3,0,8.3,8.3],[8.3,8.3,0,8.3],[8.3,8.3,8.3,0]]);});
$('#pedelAA_sequence_retrieve').click(function () {
    $('#pedelAA_sequence').val(window.sessionStorage.getItem('sequence'));
});
$('#pedelAA_retrieve_spectrum').click(function () {
    applyLoad(JSON.parse(window.sessionStorage.getItem('spectrum')));
});

$('#pedelAA_demo').click(function () {
    //Mutazyme?
    applyLoad([[0, 15, 9, 2],[15, 0, 2, 9],[13, 7, 0, 2],[7, 13, 2, 0]]);
    $('#pedelAA_load').val(4.5);
});

$('#pedelAA_calculate').click(function() {
    $("#pedelAA_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
    $("#pedelAA_result").removeClass('hidden');
    $("#pedelAA_result").show(); //weird combo.
    window.sessionStorage.setItem('sequence', $('#pedelAA_sequence').val());
        try {
        var data = {};
            pedelAA_formids=['sequence','load','size','A2T', 'A2G', 'A2C', 'T2A', 'T2G', 'T2C', 'G2A', 'G2T', 'G2C', 'C2A', 'C2T', 'C2G'];
        for (i = 0; i < pedelAA_formids.length; i++) {
            var v = $('#pedelAA_' + pedelAA_formids[i]).val();
            if (!v) {
                v = $('#pedelAA_' + pedelAA_formids[i]).attr("placeholder");
            }
            // fallback to no prefix...
            if (!v) {v = $('#'+pedelAA_formids[i]).val();}
            data[pedelAA_formids[i]] = v;
        }
        data['nucnorm']=$("#pedelAA_normal").bootstrapSwitch('state');
        data['distr']=$("#pedelAA_PCR").bootstrapSwitch('state');
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
            replot(reply['data'],'pedelAA');
            $('#plotoptdiv input').on('change', function() {
                replot(reply['data'],'pedelAA');
            });
            $('#pedelAA_plot_log').on('switchChange.bootstrapSwitch', function(event, state) {
                replot(reply['data'],'pedelAA');
            });
                },
            error: function(xhr) {
                $("#pedelAA_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span>Oh Snap. Ajax error ({0})</h3><pre><code>{1}</pre><code></div>'.format(xhr.status,escapeHtml(xhr.responseText)));
            },
            cache: false,
            contentType: false,
            processData: false
        });
        }
        catch(err) {
        $("#pedelAA_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span> Client side error (<i>i.e.</i> something is wrong on your side)</h3><pre><code>{0}</pre><code></div>'.format(err.message));
        }
        return false;
});

$('#overview').after($('#note_btn'));


$('#pedel_Cx_note').modal('hide');

// To do make modal appear
/*
$(".pedelAA_note_Exact").bind( "click", function() {});
$(".pedelAA_note_Rx_warning").bind( "click", function() {});
$(".pedelAA_note_Cx_~_Lx").bind( "click", function() {});

//pedel_Cx_note
*/