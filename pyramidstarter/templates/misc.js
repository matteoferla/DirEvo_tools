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