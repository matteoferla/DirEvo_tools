$(function() {
    $('#DS_method').on('switchChange.bootstrapSwitch', function(event, state) {
        if (state == true) {
            $('#DS_overlap_group').show();
        } else {
            $('#DS_overlap_group').hide();
        }
    });

    $('#DS_demo').click(function() {
        $('#DS_startBase').val(105);
        $('#DS_stopBase').val(882);
        $('#DS_sequence').val('ATGCGGGGTTCTCATCATCATCATCATCATGGTATGGCTAGCATGACTGGTGGACAGCAAATGGGTCGGGATCTGTACGAGAACCTGTACTTCCAGGGCTCGAGCATGGTGAGCAAGGGCGAGGAGCTGTTCACCGGGGTGGTGCCCATCCTGGTCGAGCTGGACGGCGACGTAAACGGCCACAAGTTCAGCGTGCGCGGCGAGGGCGAGGGCGATGCCACCAACGGCAAGCTGACCCTGAAGTTCATCTGCACCACCGGCAAGCTGCCCGTGCCCTGGCCCACCCTCGTGACCACCCTGACCTACGGCGTGCAGTGCTTCAGCCGCTACCCCGACCACATGAAGCGCCACGACTTCTTCAAGTCCGCCATGCCCGAAGGCTACGTCCAGGAGCGCACCATCAGCTTCAAGGACGACGGCACCTACAAGACCCGCGCCGAGGTGAAGTTCGAGGGCGACACCCTGGTGAACCGCATCGAGCTGAAGGGCATCGACTTCAAGGAGGACGGCAACATCCTGGGGCACAAGCTGGAGTACAACTTCAACAGCCACAACGTCTATATCACCGCCGACAAGCAGAAGAACGGCATCAAGGCCAACTTCAAGATCCGCCACAACGTGGAGGACGGCAGCGTGCAGCTCGCCGACCACTACCAGCAGAACACCCCCATCGGCGACGGCCCCGTGCTGCTGCCCGACAACCACTACCTGAGCACCCAGTCCGTGCTGAGCAAAGACCCCAACGAGAAGCGCGATCACATGGTCCTGCTGGAGTTCGTGACCGCCGCCGGGATCACTCACGGCATGGACGAGCTGTACAAGTAAGAATTCGAAGCTTGGCTGTTTTGGCGGATGAGAGAAGATTTTCAGCCTGATACAGATTAAATCAGAACGCAGAAGCGGTCTGATAAAACAGAATTTGCCTGGCGGCAGTAGCGCGGTGGTCCCACCTGACCCCATGCCGAACTCAGAAGTGAAACGCCGTAGCG');
        $("#DS_result").removeClass('hidden');
        $("#DS_result").show();
        $("#DS_result").html("<br/><div class='bs-callout bs-callout-info'>The sequence loaded encodes superfolded GFP (in pBAD from <a target='_blank' href='https://www.addgene.org/54519/'>Addgene <i class='fa fa-external-link' aria-hidden='true'></i></a>).</div>");

    })

    $('#DS_clear').click(function() {
        $('#DS_startBase').val('');
        $('#DS_stopBase').val('');
        $('#DS_sequence').val('');
        $("#DS_result").addClass('hidden');
        $("#DS_download").addClass('hidden');
    })


    $('#DS_calculate').click(function() {
        //nah to .serialize() so I can do sanity tests.
        var data = {
            task: 'DS',
            startBase: $('#DS_startBase').val(),
            stopBase: $('#DS_stopBase').val(),
            sequence: $('#DS_sequence').val(),
            mutationCodon: $('#DS_mutationCodon').val(),
            targetTemp: $('#DS_targetTemp').val(),
            overlap: $('#DS_overlap').val(),
            primerRange: $('#DS_primerRange').val(),
            GCclamp: $('#DS_GCclamp').val(),
            TMBonus: [0, 2.8, 4.9, 11.6, 13.3][parseInt($('#DS_enzyme').val()) - 1],
            method: $('#DS_method').is(':checked')
        };
        //console.log(data);
        //throbber
        $("#DS_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
        $("#DS_result").removeClass('hidden');
        $("#DS_result").show(); //weird combo.
                //Ajax
        $.ajax({
            url: "ajax_deepscan",
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(data),
            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('primers', JSON.stringify(reply['data']));
                $("#DS_download").removeClass('hidden');
                $("#DS_download").show();
                $("#DS_result").html(reply['html']);
            },
            error: function() {
                $("#DS_result").html('<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Nothing back.</div>');
            }
        });
    });

    $('#DS_table').click(function() {
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

    $('#DS_json').click(function() {
        saveAs(new Blob([window.sessionStorage.getItem('primers')], {
            type: "text/plain;charset=utf-8"
        }), 'deepscan_primers.json');
    });


    $('#DS_IDT_bulk').click(function() {
        idt = JSON.parse(window.sessionStorage.getItem('primers')).map(function(obj) {
            return obj.AA + '_fw\t' + obj.fw_primer.replace(/ /g, '') + '\t25nm\tSTD\n' + obj.AA + '_rv\t' + obj.rv_primer.replace(/ /g, '') + '\t25nm\tSTD\n'
        }).join('');
        saveAs(new Blob([idt], {
            type: "text/plain;charset=utf-8"
        }), 'deepscan_primers_IDT.tsv');
    });
});