$(function() {
    var files;
    $('#facs_upload').on('change', function(event) {
        files = event.target.files;
        demo = false;
        $('#facs_upload_group').removeClass('btn-warning');
        $('#facs_upload_group').addClass('btn-success');
    });

    $('#facs_demo').click(function() {
        alert('xxxx');
    })

    $('#QQC_clear').click(function() {
        demo = false;
        $('#facs_upload_group').removeClass('btn-success');
        $('#facs_upload_group').removeClass('btn-default');
        $('#facs_upload_group').addClass('btn-warning');
    })

$('#DS_IDT_bulk').click(function() {
        idt = JSON.parse(window.sessionStorage.getItem('primers')).map(function(obj) {
            return obj.AA + '_fw\t' + obj.fw_primer.replace(/ /g, '') + '\t25nm\tSTD\n' + obj.AA + '_rv\t' + obj.rv_primer.replace(/ /g, '') + '\t25nm\tSTD\n'
        }).join('');

    });



    $('#facs_calculate').click(function() {
        $("#facs_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
        $("#facs_result").removeClass('hidden');
        $("#facs_result").show(); //weird combo.
        var data = new FormData();
        data.append("file", files[0]);
        $.ajax({
            url: 'ajax_facs',
            type: 'POST',
            data: data,
            success: function(result) {
                reply = result.message //JSON.parse(result.message);
                saveAs(new Blob([result.csv], {
                type: "text/plain;charset=utf-8"
            }), $("#facs_outfile").val());
            $("#facs_result").html('<div class="alert alert-success" role="alert">Done</div>');
                },
            error: function() {
                $("#facs_result").html('<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Nothing back.</div>');
            },
            cache: false,
            contentType: false,
            processData: false
        });
        return false;
    });
});