$(function() {
    $("#driver_by_list").toggle(false);
    $('#driver_demo').click(function() {
    formids = ['library_size','length','mean','positions','sequenceA', 'sequenceB'];
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

    $('#driver_mode').on('switchChange.bootstrapSwitch', function(event, state) {
        $('#driver_by_seq').toggle(state);
        $('#driver_by_list').toggle(!state);
    });

    $('#driver_calculate').click(function() {

    $("#driver_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
    $("#driver_result").removeClass('hidden');
    $("#driver_result").show(); //weird combo.
        try {
        var data = {};
        for (i = 0; i < formids.length; i++) {
            var v = $('#driver_' + formids[i]).val();
            if (!v) {
                v = $('#driver_' + formids[i]).attr("placeholder");
            }
            data[formids[i]] = v;
        }
        data['xtrue']=$("#driver_xtrue").bootstrapSwitch('state');
        data['mode']=$("#driver_mode").bootstrapSwitch('state');
        $.ajax({
            url: '/ajax_driver',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(data),
            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('driver', JSON.stringify(reply['data']));
                $("#driver_result").html(reply['html']);
                if (!! $("#driver_mode").bootstrapSwitch('state')) {
                    $("driver_positions").val(reply['data']['positions']);
                }
                },
            error: function(xhr) {ajax_error(xhr,"#driver_result")},
            cache: false,
            contentType: false,
            processData: false
        });
        }
        catch(err) {client_error(err,"#driver_result")}
        return false;
    });
});