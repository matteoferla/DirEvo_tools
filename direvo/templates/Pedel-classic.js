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


$('#pedel_demo').click(function() {
    for (i = 0; i < formids.length; i++) {
        $('#pedel_' + formids[i]).val($('#pedel_' + formids[i]).attr("placeholder"));
    }
})

$('#pedel_clear').click(function() {
    for (i = 0; i < formids.length; i++) {
        $('#pedel_' + formids[i]).val('');
    }
    $("#pedel_result").hide();
});


$('#pedel_calculate').click(function() {
    $("#pedel_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
    $("#pedel_result").removeClass('hidden');
    $("#pedel_result").show(); //weird combo.
    var data = {};
    for (i = 0; i < formids.length; i++) {
        var v = $('#pedel_' + formids[i]).val();
        if (!v) {
            v = $('#pedel_' + formids[i]).attr("placeholder");
        }
        data[formids[i]] = v;
    }
    data['PCR_mode']=$("#pedel_PCR").bootstrapSwitch('state');
    $.ajax({
        url: '/ajax_pedel',
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(data),
        success: function(result) {
            reply = JSON.parse(result.message);
            window.sessionStorage.setItem('pedel', JSON.stringify(reply['data']));
            var table = '<br/><h3>Sublibrary composition:</h3><br/><table class="table-striped" width=100%>' +
                '<thead><tr><th><a href="#" data-toggle="tooltip" title="Exact number of mutations per sequence">x</th>' +
                '<th><a href="#" data-toggle="tooltip" title="Poisson probability of x mutations, given m">P<sub>x</sub></th>' +
                '<th><a href="#" data-toggle="tooltip" title="expected number of sequences in library with exactly x mutations">L<sub>x</sub></th>' +
                '<th><a href="#" data-toggle="tooltip" title="number of possible sequences with exactly x mutations">V<sub>x</sub></th>' +
                '<th><a href="#" data-toggle="tooltip" title="Expected number of distinct sequences in the sub-library comprising sequences with exactly x mutations">C<sub>x</sub></th>' +
                '<th><a href="#" data-toggle="tooltip" title="completeness of sub-library">C<sub>x</sub>/V<sub>x</sub></th>' +
                '<th><a href="#" data-toggle="tooltip" title="number of redundant sequences in sub-library">L<sub>x</sub> - C<sub>x</sub></th></tr></thead>' +
                '<tbody>';
            for (var i = 0; i < reply['data'].length; i++) {
                table += '<tr>'
                for (var j = 0; j < reply['data'][i].length; j++) {
                    table += '<td>' + reply['data'][i][j].toPrecision(2) + '</td>'
                }
                table += '</tr>'
            }
            table += '</tbody></table><br/>';
            plot = '<br/><br/><div class="radio" id="plotoptdiv"> Plot: &nbsp;&nbsp;' +
                '<label class="radio-inline"><input type="radio" name="plotopt" value=1 checked>P<sub>x</sub></label>' +
                '<label class="radio-inline"><input type="radio" name="plotopt" value=2>L<sub>x</sub></label>' +
                '<label class="radio-inline"><input type="radio" name="plotopt" value=3>V<sub>x</sub></label>' +
                '<label class="radio-inline"><input type="radio" name="plotopt" value=4>C<sub>x</sub></label>' +
                '<label class="radio-inline"><input type="radio" name="plotopt" value=5>C<sub>x</sub>/V<sub>x</sub></label>' +
                '<label class="radio-inline"><input type="radio" name="plotopt" value=6>L<sub>x</sub> - C<sub>x</sub></label>' +
                '<label class="radio-inline"><input type="radio" name="plotopt" value=0>Combined</label>' +
                '&nbsp;&nbsp;&nbsp;y axis: <input type="checkbox" class="switch" id="pedel_plot_log" data-off-text="lin" data-on-text="log" data-on-color="warning" data-off-color="success" size="small"><br/>' +
                '</div><br/><div id="plot_pedel_stats" style="min-height: 400px;"></div>';
            $("#pedel_result").html('<br/>' + reply['html'] + table + plot);
            $("#pedel_plot_log").bootstrapSwitch();
            replot(reply['data']);
            $('#plotoptdiv input').on('change', function() {
                replot(reply['data']);
            });
            $('#pedel_plot_log').on('switchChange.bootstrapSwitch', function(event, state) {
                replot(reply['data']);
            });
        },
        error: function() {
            $("#pedel_result").html('<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Nothing back.</div>');
        },
        cache: false,
        contentType: false,
        processData: false
    });
    return false;
});
$('#pedel_§cycles').hide();
$('#pedel_PCR').on('switchChange.bootstrapSwitch', function(event, state) {
    $('#pedel_§cycles').toggle(state);
});