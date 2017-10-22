$(function() {
    formids = ['library_size','length','mean'];
    $('#driver_demo').click(function() {
        for (i = 0; i < formids.length; i++) {
            $('#driver_' + formids[i]).val($('#driver_' + formids[i]).attr("placeholder"));
        }
    });

    $('#driver_clear').click(function() {
        for (i = 0; i < formids.length; i++) {
            $('#driver_' + formids[i]).val('');
        }
        $("#driver_result").hide();
    });

    $('#driver_calculate').click(function() {

    $("#driver_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
    $("#driver_result").removeClass('hidden');
    $("#driver_result").show(); //weird combo.
        try {
        var data = {};
        $.ajax({
            url: '/ajax_driver',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(data),
            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('driver', JSON.stringify(reply['data']));
                },
            error: function(xhr) {
                $("#driver_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span>Oh Snap. Ajax error ({0})</h3><pre><code>{1}</pre><code></div>'.format(xhr.status,escapeHtml(xhr.responseText)));
            },
            cache: false,
            contentType: false,
            processData: false
        });
        }
        catch(err) {
        $("#driver_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span> Client side error (<i>i.e.</i> something is wrong on your side)</h3><pre><code>{0}</pre><code></div>'.format(err.message));
        }
        return false;
    });
});