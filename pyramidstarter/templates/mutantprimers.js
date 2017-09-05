$(function() {
    $('#MP_startBase_group').hide();
    $('#MP_stopBase_group').hide();

        //var val = $('input[name=q12_3]:checked').val();
    $('input[type=radio][name=MP_opt]').change(function() {
        if (this.value == 'split') {
        state=true;
        } else {
        state=false;}
        $('#MP_upSequence_group').toggle(state);
        $('#MP_downSequence_group').toggle(state);
        $('#MP_startBase_group').toggle(!state);
        $('#MP_stopBase_group').toggle(!state);
    });

    $('#MP_method').on('switchChange.bootstrapSwitch', function(event, state) {
            $('#MP_overlap_group').toggle(state);
    });

    $('#MP_demo').click(function() {
        $('#MP_startBase').val(105);
        $('#MP_stopBase').val(882);
        $('#MP_sequence').val('ATGCGGGGTTCTCATCATCATCATCATCATGGTATGGCTAGCATGACTGGTGGACAGCAAATGGGTCGGGATCTGTACGAGAACCTGTACTTCCAGGGCTCGAGCATGGTGAGCAAGGGCGAGGAGCTGTTCACCGGGGTGGTGCCCATCCTGGTCGAGCTGGACGGCGACGTAAACGGCCACAAGTTCAGCGTGCGCGGCGAGGGCGAGGGCGATGCCACCAACGGCAAGCTGACCCTGAAGTTCATCTGCACCACCGGCAAGCTGCCCGTGCCCTGGCCCACCCTCGTGACCACCCTGACCTACGGCGTGCAGTGCTTCAGCCGCTACCCCGACCACATGAAGCGCCACGACTTCTTCAAGTCCGCCATGCCCGAAGGCTACGTCCAGGAGCGCACCATCAGCTTCAAGGACGACGGCACCTACAAGACCCGCGCCGAGGTGAAGTTCGAGGGCGACACCCTGGTGAACCGCATCGAGCTGAAGGGCATCGACTTCAAGGAGGACGGCAACATCCTGGGGCACAAGCTGGAGTACAACTTCAACAGCCACAACGTCTATATCACCGCCGACAAGCAGAAGAACGGCATCAAGGCCAACTTCAAGATCCGCCACAACGTGGAGGACGGCAGCGTGCAGCTCGCCGACCACTACCAGCAGAACACCCCCATCGGCGACGGCCCCGTGCTGCTGCCCGACAACCACTACCTGAGCACCCAGTCCGTGCTGAGCAAAGACCCCAACGAGAAGCGCGATCACATGGTCCTGCTGGAGTTCGTGACCGCCGCCGGGATCACTCACGGCATGGACGAGCTGTACAAGTAAGAATTCGAAGCTTGGCTGTTTTGGCGGATGAGAGAAGATTTTCAGCCTGATACAGATTAAATCAGAACGCAGAAGCGGTCTGATAAAACAGAATTTGCCTGGCGGCAGTAGCGCGGTGGTCCCACCTGACCCCATGCCGAACTCAGAAGTGAAACGCCGTAGCG');
        $("#MP_result").removeClass('hidden');
        $("#MP_result").show();
        $("#MP_result").html("<br/><div class='bs-callout bs-callout-info'>The sequence loaded encodes superfolded GFP (in pBAD from <a target='_blank' href='https://www.addgene.org/54519/'>Addgene <i class='fa fa-external-link' aria-hidden='true'></i></a>).</div>");

    })

    $('#MP_clear').click(function() {
        $('#MP_startBase').val('');
        $('#MP_stopBase').val('');
        $('#MP_sequence').val('');
        $("#MP_result").addClass('hidden');
        $("#MP_download").addClass('hidden');
    })


    $('#MP_calculate').click(function() {
        //nah to .serialize() so I can do sanity tests.
        var data = {
            task: 'DS',
            startBase: $('#MP_startBase').val(),
            stopBase: $('#MP_stopBase').val(),
            sequence: $('#MP_sequence').val(),
            mutationList: $('#MP_MP_mutationList').val(),
            targetTemp: $('#MP_targetTemp').val(),
            overlap: $('#MP_overlap').val(),
            primerRange: $('#MP_primerRange').val(),
            GCclamp: $('#MP_GCclamp').val(),
            TMBonus: [0, 2.8, 4.9, 11.6, 13.3][parseInt($('#MP_enzyme').val()) - 1],
            method: $('#MP_method').is(':checked')
        };

        if (! $('#MP_choose').is(':checked')){
            data.sequence=$('#MP_upSequence').val()+$('#MP_sequence').val()+$('#MP_downSequence').val();
            data.startBase=$('#MP_upSequence').val().length.toString();
            data.stopBase=($('#MP_upSequence').val().length+$('#MP_sequence').val().length).toString();
        }

        //console.log(data);
        //throbber
        $("#MP_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
        $("#MP_result").removeClass('hidden');
        $("#MP_result").show(); //weird combo.
                //Ajax
        $.ajax({
            url: "ajax_mutantprimers",
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(data),
            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('primers', JSON.stringify(reply['data']));
                $("#MP_download").removeClass('hidden');
                $("#MP_download").show();
                $("#MP_result").html(reply['html']);
            },
            error: function() {
                $("#MP_result").html('<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Nothing back.</div>');
            }
        });
    });

    $('#MP_table').click(function() {
        headers = 'base,AA,codon,fw_primer,rv_primer,len_homology,fw_len_anneal,rv_len_anneal,fw_len_primer,rv_len_primer,homology_start,homology_stop,homology_Tm,fw_anneal_Tm,rv_anneal_Tm'.split(",");;
        var csv = JSON.parse(window.sessionStorage.getItem('primers')).map(function(obj) {
            return headers.map(function(h) {
                return obj[h]
            }).join(', ')
        }).join('\n');
        saveAs(new Blob([headers.join(', ') + '\n', csv], {
            type: "text/plain;charset=utf-8"
        }), 'deepscan_primers.csv');
    });

    $('#MP_json').click(function() {
        saveAs(new Blob([window.sessionStorage.getItem('primers')], {
            type: "text/plain;charset=utf-8"
        }), 'deepscan_primers.json');
    });


    $('#MP_IDT_bulk').click(function() {
        idt = JSON.parse(window.sessionStorage.getItem('primers')).map(function(obj) {
            return obj.AA + '_fw\t' + obj.fw_primer.replace(/ /g, '') + '\t25nm\tSTD\n' + obj.AA + '_rv\t' + obj.rv_primer.replace(/ /g, '') + '\t25nm\tSTD\n'
        }).join('');
        saveAs(new Blob([idt], {
            type: "text/plain;charset=utf-8"
        }), 'deepscan_primers_IDT.tsv');
    });
});