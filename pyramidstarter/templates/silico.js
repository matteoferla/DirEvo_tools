$(function () {
$('#silico_load_spectrum').on('change', function(event) {
    var files = event.target.files;
    var csv;
    var csv_loaded=false;
    var reader=new FileReader();
    reader.readAsText(files[0]);
    reader.onloadend = function() {
            csv=reader.result;
            csv_loaded=true;
            }
    function parse_csv() {
        if(csv_loaded == false) {
           window.setTimeout(parse_csv, 50);
        } else {
        // main....
        var lines=csv.split('\n');
        var rawload=[];
        for (var fi=1; fi <5; fi++) {
            rawload.push(lines[fi].split(',').slice(1).map(function (x) {return parseFloat(x)}));
        }
        console.log(rawload);
        var nor=normaliseLoad(rawload);
        console.log(nor);
        applyLoad(nor);
        }
    }
    raw=parse_csv();
    });
    function normaliseLoad(raw) {
        var total=raw.reduce(function (sum, value) {
          return sum + value.reduce(function (inner_sum, inner_value) { return inner_sum + inner_value;}, 0);
        }, 0);
        return raw.map(function (row) {return row.map(function (item) {return item/total*100})});
    }

    function applyLoad(data) {
    var bases=['A','T','G','C'];
        for (var fi=0; fi<4; fi++) { //from
            for (var ti=0; ti<4; ti++) { //to
                $("#{0}2{1}".format(bases[fi],bases[ti])).val(data[fi][ti]);
            }
        }
    }
    $("#silico_opt_mutazyme").click(function () {applyLoad([[0, 15, 9, 2],[15, 0, 2, 9],[13, 7, 0, 2],[7, 13, 2, 0]]);});
    $("#silico_opt_manganese").click(function () {applyLoad([[0, 20, 14, 4],[20, 0, 4, 14],[7, 2, 0, 1],[2, 7, 1, 0]]);});
    $("#silico_opt_MP6").click(function () {applyLoad([[0,3,,15,8],[3,0,8,16],[13,8,0,2],[7,17,0,0]]);});
    $("#silico_opt_D473G").click(function () {applyLoad([[0,5,8,5],[14,0,0,5],[9,4,0,2],[3,6,3,0]]);});
    $("#silico_opt_analogues").click(function () {applyLoad([[0,0,27,6],[0,0,2,54],[11,0,0,0],[0,6,0,0]]);});
    $("#silico_opt_uniform").click(function () {applyLoad([[0,8.3,8.3,8.3],[8.3,0,8.3,8.3],[8.3,8.3,0,8.3],[8.3,8.3,8.3,0]]);});
    $('#silico_calculate').click(function() {

    $("#silico_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
    $("#silico_result").removeClass('hidden');
    $("#silico_result").show(); //weird combo.
    window.sessionStorage.setItem('sequence', $('#silico_sequence').val());
        try {
        var data = {};
            silico_formids=['sequence','load','A2T', 'A2G', 'A2C', 'T2A', 'T2G', 'T2C', 'G2A', 'G2T', 'G2C', 'C2A', 'C2T', 'C2G'];
        for (i = 0; i < silico_formids.length; i++) {
            var v = $('#silico_' + silico_formids[i]).val();
            if (!v) {
                v = $('#silico_' + silico_formids[i]).attr("placeholder");
            }
            // fallback to no prefix...
            if (!v) {v = $('#'+silico_formids[i]).val();}
            data[silico_formids[i]] = v;
        }
        $.ajax({
            url: '/ajax_silico',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(data),
            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('silico', JSON.stringify(reply['data']));
                $("#silico_result").html(reply['html']);
                },
            error: function(xhr) {
                $("#silico_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span>Oh Snap. Ajax error ({0})</h3><pre><code>{1}</pre><code></div>'.format(xhr.status,escapeHtml(xhr.responseText)));
            },
            cache: false,
            contentType: false,
            processData: false
        });
        }
        catch(err) {
        $("#silico_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span> Client side error (<i>i.e.</i> something is wrong on your side)</h3><pre><code>{0}</pre><code></div>'.format(err.message));
        }
        return false;
    });
    $('#silico_sequence_retrieve').click(function () {
    $('#silico_sequence').val(window.sessionStorage.getItem('sequence'));
    });
});