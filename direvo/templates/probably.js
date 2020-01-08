$(function() {

    function applyLoad(data) {
    var bases=['A','T','G','C'];
        for (var fi=0; fi<4; fi++) { //from
            for (var ti=0; ti<4; ti++) { //to
                $("#{0}2{1}".format(bases[fi],bases[ti])).val(data[fi][ti]);
            }
        }
    }
    $("#probably_opt_mutazyme").click(function () {applyLoad([[0, 15, 9, 2],[15, 0, 2, 9],[13, 7, 0, 2],[7, 13, 2, 0]]);});
    $("#probably_opt_manganese").click(function () {applyLoad([[0, 20, 14, 4],[20, 0, 4, 14],[7, 2, 0, 1],[2, 7, 1, 0]]);});
    $("#probably_opt_MP6").click(function () {applyLoad([[0,3,,15,8],[3,0,8,16],[13,8,0,2],[7,17,0,0]]);});
    $("#probably_opt_D473G").click(function () {applyLoad([[0,5,8,5],[14,0,0,5],[9,4,0,2],[3,6,3,0]]);});
    $("#probably_opt_analogues").click(function () {applyLoad([[0,0,27,6],[0,0,2,54],[11,0,0,0],[0,6,0,0]]);});
    $("#probably_opt_uniform").click(function () {applyLoad([[0,8.3,8.3,8.3],[8.3,0,8.3,8.3],[8.3,8.3,0,8.3],[8.3,8.3,8.3,0]]);});
    $('#probably_sequence_retrieve').click(function () {
        $('#probably_sequence').val(window.sessionStorage.getItem('sequence'));
    });
    $('#probably_retrieve_spectrum').click(function () {
        applyLoad(JSON.parse(window.sessionStorage.getItem('spectrum')));
    });
    $('#probably_calculate').click(function() {
    $("#probably_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
    $("#probably_result").removeClass('hidden');
    $("#probably_result").show(); //weird combo.
    window.sessionStorage.setItem('sequence', $('#probably_sequence').val());
        try {
        var data = {};
            probably_formids=['sequence','load', 'list', 'size','A2T', 'A2G', 'A2C', 'T2A', 'T2G', 'T2C', 'G2A', 'G2T', 'G2C', 'C2A', 'C2T', 'C2G'];
        for (i = 0; i < probably_formids.length; i++) {
            var v = $('#probably_' + probably_formids[i]).val();
            if (!v) {
                v = $('#probably_' + probably_formids[i]).attr("placeholder");
            }
            // fallback to no prefix...
            if (!v) {v = $('#'+probably_formids[i]).val();}
            data[probably_formids[i]] = v;
        }
        window.sessionStorage.setItem('spectrum',  JSON.stringify(data));
        $.ajax({
            url: '/ajax_probably',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(data),
            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('probably', JSON.stringify(reply['data']));
                $("#probably_result").html(reply['html']);
                },
            error: function(xhr) {
                $("#probably_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span>Oh Snap. Ajax error ({0})</h3><pre><code>{1}</pre><code></div>'.format(xhr.status,escapeHtml(xhr.responseText)));
            },
            cache: false,
            contentType: false,
            processData: false
        });
        }
        catch(err) {
        $("#probably_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span> Client side error (<i>i.e.</i> something is wrong on your side)</h3><pre><code>{0}</pre><code></div>'.format(err.message));
        }
        return false;
    });
});