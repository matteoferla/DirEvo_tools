function factorial(x) {
   if(x==0) {
      return 1;
   }
   return x * factorial(x-1);
}


$(function() {
    $('#estimate_results').hide();
    $('#yield_calculate').click(function() {
        ($('#yield_reaction').val()) ? (reaction=$('#yield_reaction').val()) : (reaction=$('#yield_reaction').attr('placeholder'));
        ($('#yield_final_primer_conc').val()) ? (final_primer_conc=$('#yield_final_primer_conc').val()) : (final_primer_conc=$('#yield_final_primer_conc').attr('placeholder'));
        ($('#yield_size').val()) ? (size=$('#yield_size').val()) : (size=$('#yield_size').attr('placeholder'));
        ($('#yield_final_dNTP_conc').val()) ? (final_dNTP_conc=$('#yield_final_dNTP_conc').val()) : (final_dNTP_conc=$('#yield_final_dNTP_conc').attr('placeholder'));
        //Calc.
        max_by_primer=final_primer_conc*607*size*1e-6*reaction; // uM to ng/ul is e-6*e3 * MW
        max_by_dNTP=final_dNTP_conc*304*1e-6*reaction;
        if (max_by_primer>max_by_dNTP) {
            $('#yield_result').html('Theoretical maximum: '+Math.round(max_by_dNTP).toString()+' µg due to dNTP depletion (primer maximum: '+Math.round(max_by_primer).toString()+' µg)');
        }
        else {
            $('#yield_result').html('Theoretical maximum: '+Math.round(max_by_primer).toString()+' µg due to primer depletion (dNTP maximum: '+Math.round(max_by_dNTP).toString()+' µg)');
        }
    });
    $('#estimate_calculate').click(function() {
        //input
        ($('#estimate_rate').val()) ? (rate=$('#estimate_rate').val()) : (rate=$('#estimate_rate').attr('placeholder'));
        ($('#estimate_template').val()) ? (template=$('#estimate_template').val()) : (template=$('#estimate_template').attr('placeholder'));
        ($('#estimate_yield').val()) ? (yield=$('#estimate_yield').val()) : (yield=$('#estimate_yield').attr('placeholder'));
        ($('#estimate_size').val()) ? (size=$('#estimate_size').val()) : (size=$('#estimate_size').attr('placeholder'));
        //calculate
        var doublings=Math.log2(yield/template);
        var λ=doublings * rate * size;
        $('#estimate_doublings').html(doublings.toPrecision(1));
        $('#estimate_mloadkb').html((doublings * rate).toPrecision(1));
        $('#estimate_mload').html(λ.toPrecision(1));

        //plot
        var x = [];
        var y = [];
        for (var k = 0; k < (1+λ)*3; k ++) {
            x[k] = k;
            y[k] = Math.pow(λ, k)* Math.pow(Math.E, -λ)/factorial(k);
        }
        Plotly.newPlot('estimate_chart', [{x:x, y:y, type:'bar'}],{title:'Expected library mutational load (Poisson distribution)',xaxis: {title: 'number of mutations'},yaxis:{title:'fraction with given mutations'},bargap:0});
        $('#estimate_results').show();
    });
    $('#estimate_demo').click(function() {});
    $('#estimate_clear').click(function() {});

    function codonist() {
        $("#codon_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
        $("#codon_result").removeClass('hidden');
        $("#codon_result").show(); //weird combo.
        data=$('#codon_drop').val();
        if (data == 'other') {
            $("#codon_manual").removeClass('hidden');
            $("#codon_manual").show();
            data=$('#codon_mutation').val();
        }
        else {
            $("#codon_manual").addClass('hidden');
            $("#codon_manual").hide();
        }
        $.ajax({
            url: '../ajax_codon',
            type: 'POST',
            data: JSON.stringify(data),
            success: function(result) {
                reply = JSON.parse(result.message);
                window.sessionStorage.setItem('codon', JSON.stringify(reply['data']));
                $("#codon_result").html(reply['html']);
                //$("#QQC_download").removeClass('hidden');
                //$("#QQC_download").show(); //weird combo.
                //$("#QQC_result").html(reply['html']);
                AA = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y', '*'];
                Plotly.newPlot('codon_graph',[{
                    x: AA,
                    y: AA.map(function(a) {
                        return reply['data'][a]
                    }),
                    name: 'Number of codons',
                    type: 'bar'
                }], {
                    barmode: 'group',
                    title: 'Pedicted amino acid proportions'
                });
            },
            error: function() {
                $("#codon_result").html('<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Nothing back.</div>');
            },
            cache: false,
            contentType: false,
            processData: false
        });
    }
    $('#codon_drop').change(codonist);
    $('#codon_mutation').change(codonist);

});