// THIS HAS JUST BEEN COPY PASTED. FIX IT.

$(function() {
    $('#nucleotide_modal').modal('hide');

    formids = ['nvariants', 'library_size', 'completeness', 'prob_complete'];
    $('#glue_demo').click(function() {
        for (i = 0; i < formids.length; i++) {
            $('#glue_' + formids[i]).val($('#glue_' + formids[i]).attr("placeholder"));
        }
    })

    $('#glue_clear').click(function() {
        for (i = 0; i < formids.length; i++) {
            $('#glue_' + formids[i]).val('');
        }
        $("#glue_result").hide();
    });

    $("#glue_library_size_on").click(function () {
        crappy_toggle('library_size');
    });

    $("#glue_completeness_on").click(function () {
        crappy_toggle('completeness');
    });

    $("#glue_prob_complete_on").click(function () {
        crappy_toggle('prob_complete');
    });

    function crappy_toggle(id) {
        sf=['library_size', 'completeness', 'prob_complete'];
        for (i=0; i<3; i++) {
            if (sf[i] == id) { //turn on
                $("#glue_"+id+"_on").removeClass("btn-default");
                $("#glue_"+id+"_on").addClass("btn-success");
                $("#glue_"+id).prop('disabled', false);
                $("#glue_"+id).css("background-color","white");

            }
            else {
                $("#glue_"+sf[i]+"_on").addClass("btn-default");
                $("#glue_"+sf[i]+"_on").removeClass("btn-success");
                $("#glue_"+sf[i]).prop('disabled', true);
                $("#glue_"+sf[i]).css("background-color","Silver");
            }
        }
        glue_calculate();
    }
    crappy_toggle('library_size');

    function glue_calculate() {
        $("#glue_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
        $("#glue_result").removeClass('hidden');
        $("#glue_result").show(); //weird combo.
        var data = {};
        for (i = 0; i < formids.length; i++) {
            var v = $('#glue_' + formids[i]).val();
            if (!v) {
                v = $('#glue_' + formids[i]).attr("placeholder");
            }
            data[formids[i]] = v;
        }
        // determine whcih button is in use.
        data['mode'] = $("#glue_form").find(".btn-success").attr("id").replace("glue_","").replace("_on","");

        $.ajax({
            url: '/ajax_glue',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(data),
            success: function(result) {
                reply = JSON.parse(result.message);
                //reply=result.message; //SO told me so. Why does it work fro pedel.
                window.sessionStorage.setItem('glue', JSON.stringify(reply['data']));
                //TODO clean up this copy paste!!!
                if (data['mode'] == 'library_size') {
                $("#glue_completeness").val(reply['data']['completeness']);
                $("#glue_completeness").css('font-weight','bold');
                $("#glue_completeness").css("background-color","PaleGreen");
                }
                else if (data['mode'] == 'completeness') {
                $("#glue_library_size").val(reply['data']['required_library_size']);
                $("#glue_library_size").css('font-weight','bold');
                $("#glue_library_size").css("background-color","PaleGreen");
                }
                else if (data['mode'] == 'prob_complete') {
                $("#glue_library_size").val(reply['data']['required_library_size']);
                $("#glue_library_size").css('font-weight','bold');
                $("#glue_library_size").css("background-color","PaleGreen");
                }
                $("#glue_result").html(reply['html']);
            },
            error: function() {
                $("#glue_result").html('<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Nothing back.</div>');
            },
            cache: false,
            contentType: false,
            processData: false
        });
        return false;
    }

    //##########################################################
    for (i=2; i<7; i++){
    $('#glueIT_overcodon'+ i.toString()).hide();
    }

    $('#glueIT_num_codons').change(function () {
    var codons=parseInt($('#glueIT_num_codons').val());
    for (i=1; i<codons+1; i++){
        $('#glueIT_overcodon'+ i.toString()).show();
    }
    for (i=codons+1; i<7; i++){
    $('#glueIT_overcodon'+ i.toString()).hide();
    }
    });

    var formidsIT=['library_size','num_codons','codon1','codon2','codon3','codon4','codon5','codon6'];

    function glueIT_calculate() {
        $("#glueIT_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
        $("#glueIT_result").removeClass('hidden');
        $("#glueIT_result").show(); //weird combo.
        var data = {};
        for (i = 0; i < formidsIT.length; i++) {
            var v = $('#glueIT_' + formidsIT[i]).val();
            if (!v) {
                v = $('#glueIT_' + formidsIT[i]).attr("placeholder");
            }
            data[formidsIT[i]] = v;
        }
        $.ajax({
            url: '/ajax_glueIT',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(data),
            success: function(result) {
                reply = JSON.parse(result.message);
                //reply=result.message; //SO told me so. Why does it work fro pedel.
                window.sessionStorage.setItem('glueIT', JSON.stringify(reply['data']));
                $("#glueIT_result").html(reply['html']);
            },
            error: function() {
                $("#glueIT_result").html('<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Nothing back.</div>');
            },
            cache: false,
            contentType: false,
            processData: false
        });
        return false;
    }

    $('#glueIT_clear').click(function() {
        for (i = 0; i < formidsIT.length; i++) {
            $('#glue_' + formidsIT[i]).val('');
        }
        $("#glueIT_result").hide();
    });

    $('#glueIT_calculate').click(glueIT_calculate);
    $('#glue_calculate').click(glue_calculate);
});