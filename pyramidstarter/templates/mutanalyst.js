$(document).ready(function() {

    $("#mutanalyst_seq§").show();
    $("#mutanalyst_freq§").hide();
    $("#altH_showing_button").hide();
    $("#altH_showing_button_off").hide();
    $("#mutanalyst_freq_alt_in§").hide();
    $("#mutanalyst_corrected§").hide();
    $("#mutanalyst_bias§").hide();
    $("#mutanalyst_more§").hide();

    $("#altH_showing_button_on").click(function () {$("#alt§").show(); $("#altH_showing_button_on").hide(); $("#altH_showing_button_off").show();
        });
    $("#altH_showing_button_off").click(function () {$("#alt§").hide(); $("#altH_showing_button_off").hide(); $("#altH_showing_button_on").show();
    });

    $('#mutanalyst_method').on('switchChange.bootstrapSwitch', function(event, state) {
        $('#mutanalyst_seq§').toggle(state);
        $('#mutanalyst_freq_alt_in§').toggle(!state);
    });

    var mutball = mutagen();
    var queries = window.location.search.substring(1).split("&");
    for (var i = 0; i < queries.length; i++) {
        var pair = queries[i].split("=");
        if (!!pair[1]) {
            eval("mutball." + pair[0] + "='" + pair[1].replace("%20", " ").replace("%0A", "\\n") + "'");
        }
    }
    commit(mutball);
    //google.load('visualization', '1', {packages: ['corechart'],callback: function() {}}); //callback is stop it writing, but append

    $('#sequence_retrieve').click(function() {
        $('#sequence').val(window.sessionStorage.getItem('sequence'));
    });
});

//**************************************************
//**************************************************
//Button wrappers.
//They don't touch any Doc elements. Only the mutball does via it's read() and commit() methods. This was done for portability. However, the attributes are document ids too. If one were to change them the read and commit methods need changing.
function Btn_blank(n) {
    //most of these don't work most likely...
    commit();
    $("#seqT1").hide();
    $("#seqT2").show();
    $("#mutanalyst_freq§").hide();
    $("#mutanalyst_freq_alt_in§").hide();
    $('#mutanalyst_corrected§').hide();
    $("#freqT1").hide();
    $("#freqT2").show();
    $("#mutanalyst_bias§").hide();
    $("#next§").hide();
    if (n == 1) {
        $("#mutanalyst_seq§").show();
    } else if (n == 2) {
        $("#freq§").show();
    }
    //return false;
}

function Btn_demo() {
    var mutball = mutagen();
    mutball.sequence = "ATGAACACAGACGACATTCTGTTTTCTTACGGAGAAGAAGACATTCCTTTGAAGGCGCTGTCGTTTCCCATCTTCGAAACGACGAATTTCTACTTCGACAGTTTCGACGAGATGTCGAAAGCCCTCAGAAACGGAGACTACGAATTCGTTTACAAAAGAGGAAGTAATCCCACAACGAGACTGGTGGAGAAGAAACTCGCAGCGCTTGAAGAGTGTGAAGATGCCCGCCTCGTTGCCTCTGGAATGAGCGCCATTTCGCTTTCCATCCTTCATTTCCTCAGCTCGGGAGACCACGTCGTGTGTGTGGACGAGGCTTACTCCTGGGCGAAAAAGTTCTTCAACTACCTTTCAAAGAAGTTCGATATAGAAGTCAGCTACGTTCCTCCCGACGCGGAAAGAATAGTCGAAGCCATCACGAAGAAGACGAAGCTCATCTACCTCGAAAGTCCCACGAGTATGAGAATGAAAGTGATCGATATAAGAAAGGTCACAGAAGCGGCAGGAGAACTCAAGATAAAAACCGTCATAGACAACACCTGGGCGTCGCCGATCTTTCAAAAACCAAAGCTTCTGGGAGTGGATGTGGTGGTCCACTCTGCGACGAAGTACATCTCAGGACACGGAGACGTGATGGCAGGAGTGATCGCAGGAGACGTCGAAGATATGAAGAACATCTTCGTGGATGAATACAAAAACATCGGACCGGTTCTCTCGCCCATAGAAGCCTGGCTCATCTTGAGAGGTCTTAGAACGCTGGAACTCCGTATGAAAAAGCACTACGAAAACGCTCTTGTGGTGTCTGACTTCCTCATGGATCACCCGAAGGTCCTCGAGGTGAACTACCCGATGAATCCAAGATCACCGCAGTACGAACTCGCTTCCTCTCAGATGAGCGGTGGCTCAGGACTGATGAGCTTCAGGCTGAAAACGGACAGCGCAGAGAAAGTCAAAGAGTTCGTCGAAAGTCTGAGGGTTTTCAGGATGGCTGTGAGCTGGGGAAGTCACGAGAACCTTGTTGTTCCAAGGGTGGCTTATGGAGACTGCCCGAAAAAAGACGTGAACCTGATAAGAATCCATGTGGGTCTCGGAGATCCAGAAAAGCTCGTGGAAGATCTGGATCAGGCACTCAAAAAGATTTAA";
    mutball.baseList = "G286A T306C A687T T880C\nWT\nWT\nC372T A923G\nG832A\nA650C\nA720C\nC449A A556G A814G A853G C826T C1059T\nG793A\nA1048G\nG726T\nG982C\nC53T G678T T798A\nA224T A447G A586T C964T\nA185T\nT860A\nA979T A1005T\nC453T\nWT";
    calc(mutball, 0);
    //return false;
}

function calc(mutball, n) {
    $('#mutanalyst_corrected§').show();
    if (!n) {
        mutball = calcFreq(mutball);
        $("#mutanalyst_freq_alt_in§").show();
        $("#altH").html("(Optionally) editing the");
        $("#alt§").hide();
        $("#altH_showing_button_on").show();
        commit(mutball); //Not redundant due to the div show and hide.
        //if (google.visualization.arrayToDataTable) {
        //displot(mutball);} else {
        //google.setOnLoadCallback(function (){displot(mutball)})}
        displot(mutball);
    }
    mutball = calcBias(mutball);
    commit(mutball);
    svg();

    /*
    if (google.visualization.arrayToDataTable) {
    plot(mutball);} else {
    google.setOnLoadCallback(function (){plot(mutball)})}
    }
    */
    plot(mutball);
    //new bit...
    if (!n) {
        $("#pedelAA_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
        $("#mutanalyst_more§").removeClass('hidden');
        $("#mutanalyst_more§").show(); //weird combo.
        window.sessionStorage.setItem('sequence', $('#pedelAA_sequence').val());
        try {
            var data = {};
            pedelAA_formids = ['sequence', 'freqMean', 'library_size', 'A2T', 'A2G', 'A2C', 'T2A', 'T2G', 'T2C', 'G2A', 'G2T', 'G2C', 'C2A', 'C2T', 'C2G'];
            for (i = 0; i < pedelAA_formids.length; i++) {
                var v = $('#' + pedelAA_formids[i]).val();
                if (!v) {
                    v = $('#' + pedelAA_formids[i]).attr("placeholder");
                }
                data[pedelAA_formids[i]] = v;
            }
            data['load']=data['freqMean'];
            data['size']=data['library_size']; //id already in use..
            data['nucnorm']=0;
            data['distr']='Poisson';
            $.ajax({
                url: '/ajax_pedelAA',
                type: 'POST',
                dataType: 'json',
                data: JSON.stringify(data),
                success: function(result) {
                    reply = JSON.parse(result.message);
                    window.sessionStorage.setItem('pedelAA', JSON.stringify(reply['data']));
                    // copy paste!   x	Vx_1	Vx_2	Rx	Lx	Cx
                    $("#pedelAA_result").html(reply['html']);
                    $("#pedelAA_plot_log").bootstrapSwitch();
                    replot(reply['data'], 'pedelAA');
                    $('#plotoptdiv input').on('change', function() {
                        replot(reply['data'], 'pedelAA');
                    });
                    $('#pedelAA_plot_log').on('switchChange.bootstrapSwitch', function(event, state) {
                        replot(reply['data'], 'pedelAA');
                    });
                },
                error: function(xhr) {
                    $("#pedelAA_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span>Oh Snap. Ajax error ({0})</h3><pre><code>{1}</pre><code></div>'.format(xhr.status, escapeHtml(xhr.responseText)));
                },
                cache: false,
                contentType: false,
                processData: false
            });
        } catch (err) {
            $("#pedelAA_result").html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span> Client side error (<i>i.e.</i> something is wrong on your side)</h3><pre><code>{0}</pre><code></div>'.format(err.message));
        }
        return false;
    }

    function replot(data, ver='pedel') {
        var layout = {
                    yaxis: {
                        title: 'Number of mutants in each bin',
                        type: 'lin',
                        autorange: true
                    },
                    xaxis: {
                        title: 'x, Exact number of mutations per sequence',
                        type: 'lin',
                        autorange: true
                    },bargap:0,barmode: 'stack'
                };
        if ($("#"+ver+"_plot_log").is(":checked")) {
                layout['yaxis']['type'] = 'log';
            }
        var m = $('input[name=plotopt]:radio:checked').val();
        var x = data.map(function(x) {
                    return x[0]});
        if (m == 0) {
            //Combined.
            if (ver == 'pedelAA') {
            locs=[5, 7];}
            else {
            locs=[4, 6];}
            var y1 = data.map(function(x) {
                    return x[locs[0]]});
            var y2 = data.map(function(x) {
                    return x[locs[1]]});
            Plotly.newPlot('plot_'+ver+'_stats', [{
                x: x,
                y: y1,
                name: 'Unique diversity (Cx)',
                type: 'bar'
            },{
                x: x,
                y: y2,
                name: 'Redundant diversity (Lx − Cx)',
                type: 'bar'
            },], layout);
        }
        else {
            // individual
            var y = data.map(function(x) {
                    return x[m]});
            Plotly.newPlot('plot_'+ver+'_stats', [{
                x: x,
                y: y,
                type: 'bar'
            }], layout);
        }

    }
}

function Btn_calcFreq() {
    window.sessionStorage.setItem('sequence', $('#sequence').val());
    var mutball = read(["sequence", "baseList"]);
    calc(mutball, 0);
    //return false;
}

function Btn_calcBias() {
    $("#mutanalyst_seq§").hide();
    $("#mutanalyst_freq§").hide();
    $("#freq§").show();
    $("#mutanalyst_bias§").show();
    $("#next§").show();
    //console.log(ways.concat(["sumA","sumT","sumG","sumC"]));
    mutball = calc(read(ways.concat(["sumA", "sumT", "sumG", "sumC"])), 1);
    //return false;
}

function Btn_FrqIn() {
    //$("#mutanalyst_seq§").css("visibility", "collapse");
    $("#mutanalyst_seq§").hide();
    $("#mutanalyst_freq§").hide();
    $("#freq§").show();
    $("#mutanalyst_bias§").hide();
    $("#next§").show();
    $("#optionality").html('If the former option is desired,  <a href="#" onClick="Btn_SeqIn();">click here</a>.');
    //return false;
}

function Btn_SeqIn() {
    //$("#mutanalyst_seq§").css("visibility", "collapse");
    $("#mutanalyst_seq§").show();
    $("#mutanalyst_freq§").hide();
    $("#freq§").hide();
    $("#mutanalyst_bias§").hide();
    $("#next§").show();
    $("#optionality").html('If the latter option is desired,  <a href="#" onClick="Btn_FrqIn();">click here</a>.');
    //return false;
}
//Interactions of Mutball and the HTML
function commit(mutball) {
    mutball = mutball || mutagen();
    if (mutball.source == 'freq') {
        $("#freq§").show();
        $("#mutanalyst_freq§").show();
        $("#next§").show();
    }
    if (mutball.source == 'Bias') {
        $("#mutanalyst_bias§").show();
        $("#next§").show();
    } //id="mutanalyst_bias§" style=
    for (handle in mutball) {
        if ($("#" + handle).is('table')) {
            //if (handle =='mutTable') {
            for (i = 0; i < 4; i++) {
                for (j = 0; j < 4; j++) {
                    $("#" + handle + " tbody tr:eq(" + i + ") td:eq(" + j + ")").html(rd(mutball[handle][i][j]));
                }
            }
        }
        //it will try changing non existant sections, but that's okay
        else {
            $("#" + handle).val(mutball[handle]);
            $("#" + handle).text(mutball[handle]);
        }
    }
    sessionStorage.setItem('ball', JSON.stringify(mutball));
}

function read(handles) {
    var mutball = mutagen();
    if (!!handles) {
        for (h in handles) {
            mutball[handles[h]] = $("#" + handles[h]).val();
        }
    } else {
        mutball = JSON.parse(sessionStorage.getItem('ball'));
    }
    return mutball;
}

function svgTabulate(table) {
    var bases = ['A', 'T', 'G', 'C'];
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            $("#" + bases[i] + bases[j] + "_line").attr("stroke-width", 2 * table[i][j] / 12.5);
            //console.log(bases[i]+bases[j]+"_line "+table[i][j]);
        }
    }
    //pedel(mutball);
}
/*
function pedel(mutball) {
	if (! mutball) {mutball = JSON.parse(sessionStorage.getItem('ball'));}
	seq=mutball.sequence;
	url='http://guinevere.otago.ac.nz/cgi-bin/aef/pedel-AA.pl';
	if ($("#pedEnd").is(':checked')) {seq=seq.substring(0,seq.length-3)}
	offset=parseInt($("#pedOff").val());
	if (offset > 0) {seq=seq.substring(offset);}
	if (seq.length%3) {seq.substring(0,seq.length-(seq.length%3))}

	url+='?sequence='+seq;
	url+="&library="+parseInt($("#library").val())+"&";
url+="a1="+mutball.T2C+"&";
url+="b1="+mutball.T2A+"&";
url+="c1="+mutball.T2G+"&";
url+="a2="+mutball.C2T+"&";
url+="d1="+mutball.C2A+"&";
url+="e1="+mutball.C2G+"&";
url+="b2="+mutball.A2T+"&";
url+="d2="+mutball.A2C+"&";
url+="f1="+mutball.A2G+"&";
url+="c2="+mutball.G2T+"&";
url+="e2="+mutball.G2C+"&";
url+="f2="+mutball.G2A+"&";
url+="nsubst="+mutball.freqλ+"&";
url+="ninsert="+parseInt($("#pedIn").val())+"&ndelete="+parseInt($("#pedDel").val())+"&";
if ($("#pedDist").is(':checked')) {url+="distr=1&ncycles="+parseInt($("#pedCyc").val())+"&eff="+$("#pedEff").val()+"&";}
else {url+="distr=0&";}
url+="nucnorm=0";
$("#pedel").attr("href", url);
	}
*/

function diagnose_arrow() {
    $("#intro§").hide();
    $("#mutanalyst_seq§").hide();
    $("#mutanalyst_freq§").hide();
    $("#freq§").hide();
    for (a = 0; a < 4; a++) {
        for (b = 0; b < 4; b++) {
            x = [
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0]
            ];
            svgTabulate(x);
            $("#" + bases[a] + bases[b] + "_line").attr("stroke-width", 10);
            alert(bases[a] + bases[b]);
        }
    }
    return false;
}

function svg() {
    var bases = ['A', 'T', 'G', 'C'];
    mutball = read();
    if ($("input[name=fig]:checked").val() == 1) {
        svgTabulate(mutball.rawTable);
        mutball.outTable = mutball.rawTable;
        mutball.mutBlabla = "Raw incidence of mutations (%)."
    } else if ($("input[name=fig]:checked").val() == 2) {
        svgTabulate(mutball.mutTable);
        mutball.outTable = mutball.mutTable;
        mutball.mutBlabla = "Sequence-composition–corrected incidence of mutations (%)."
    } else if ($("input[name=fig]:checked").val() == 3) {
        svgTabulate(mutball.compTable);
        mutball.outTable = mutball.compTable;
        mutball.mutBlabla = "Sequence-composition–corrected incidence of mutations averaged assuming strand complementary (%)."
    } else {
        alert('No radiobox selection');
    }
    commit(mutball);
    $('#down').attr("href", 'data:image/svg+xml;utf8,' + unescape($('#Layer_1')[0].outerHTML));
}

function displot(mutball) {
    poisson = function(k, λ) {
        function factorial(n) {
            if (n == 0) {
                return 1
            } else if (n == 1) {
                return 1
            } else {
                return n-- * factorial(n)
            }
        }
        return Math.pow(λ, k) * Math.exp(-λ) / factorial(k);
    }
    /*var goo=google.visualization.arrayToDataTable([['Bins','Counts','Fit']].concat(mutball.freqList.map(function(v,i){return [i, v, mutball.freqΣ * poisson(i,mutball.freqλ)]})));
	var opt = {
      title : 'Distribution of mutations per sequence',
      vAxis: {title: 'Number of counts'},
      hAxis: {title: 'Number of mutations per sequence', baselineColor:'transparent'},
      seriesType: 'bars',
      series: {1: {type: 'line'}}
    };

    //dischart = new google.visualization.ComboChart($('#disChart')[0]);
    dischart.draw(goo, opt);
    */

    var data = [{
            x: mutball.freqList.map(function(v, i) {
                return i
            }),
            y: mutball.freqList,
            type: 'bar',
            name: 'Empirical data'
        },
        {
            x: mutball.freqList.map(function(v, i) {
                return i
            }),
            y: mutball.freqList.map(function(v, i) {
                return mutball.freqΣ * poisson(i, mutball.freqλ)
            }),
            type: 'scatter',
            name: 'Poisson fit'
        }
    ];
    var layout = {
        yaxis: {
            title: 'Number of counts'
        },
        xaxis: {
            title: 'Number of mutations per sequence'
        },
        bargap: 0
    };
    Plotly.newPlot('disChart', data, layout);
}

function plot(mutball) {
    /*
	data = google.visualization.arrayToDataTable([
	['Indicator', 'value',{role:"interval"},{role:"interval"},{ role: "style" }],
	['Tv/Ts',mutball.TsOverTv*100,(mutball.TsOverTv-mutball.TsOverTv_error)*100,(mutball.TsOverTv+mutball.TsOverTv_error)*100,"Indianred"],
['AT→GC/GC→AT',mutball.W2SOverS2W*100,(mutball.W2SOverS2W-mutball.W2SOverS2W_error)*100,(mutball.W2SOverS2W+mutball.W2SOverS2W_error)*100,"orange"],
['AT→N',mutball.W2N,mutball.W2N-mutball.W2N_error,mutball.W2N+mutball.W2N_error,"green"],
['GC→N',mutball.S2N,mutball.S2N-mutball.S2N_error,mutball.S2N+mutball.S2N_error,"green"],
['AT→GC',mutball.W2S,mutball.W2S-mutball.W2S_error,mutball.W2S+mutball.W2S_error,"teal"],
['GC→AT',mutball.S2W,mutball.S2W-mutball.S2W_error,mutball.S2W+mutball.S2W_error,"teal"],
['Total Ts',mutball.ΣTs,mutball.ΣTs-mutball.ΣTs_error,mutball.ΣTs+mutball.ΣTs_error,"purple"],
['A→G + T→C',mutball.Ts1,mutball.Ts1-mutball.Ts1_error,mutball.Ts1+mutball.Ts1_error,"blue"],
['G→A + C→T',mutball.Ts2,mutball.Ts2-mutball.Ts2_error,mutball.Ts2+mutball.Ts2_error,"blue"],
['Total Tv',mutball.ΣTv,mutball.ΣTv-mutball.ΣTv_error,mutball.ΣTv+mutball.ΣTv_error,"purple"],
['A↔T',mutball.TvW,mutball.TvW-mutball.TvW_error,mutball.TvW+mutball.TvW_error,"blue"],
['A→C + T→G',mutball.TvN1,mutball.TvN1-mutball.TvN1_error,mutball.TvN1+mutball.TvN1_error,"blue"],
['G→T + C→A',mutball.TvN2,mutball.TvN2-mutball.TvN2_error,mutball.TvN2+mutball.TvN2_error,"blue"],
['G↔C',mutball.TvS,mutball.TvS-mutball.TvS_error,mutball.TvS+mutball.TvS_error,"blue"]
	]);
	chart = new google.visualization.ColumnChart($('#biasChart')[0]);  //weird JQ [0]
	chart.draw(data,{
        title: "Bias Indicators",
        legend: { position: "none" },
		vAxis: {title: "Proportion %"},
		intervals: { style: 'bars' }
		});
		*/

    var foredata = [
        ['Tv/Ts', mutball.TsOverTv * 100, mutball.TsOverTv_error * 100, "Indianred"],
        ['AT→GC/GC→AT', mutball.W2SOverS2W * 100, mutball.W2SOverS2W_error * 100, "orange"],
        ['AT→N', mutball.W2N, mutball.W2N_error, "green"],
        ['GC→N', mutball.S2N, mutball.S2N_error, "green"],
        ['AT→GC', mutball.W2S, mutball.W2S_error, "teal"],
        ['GC→AT', mutball.S2W, mutball.S2W_error, "teal"],
        ['Total Ts', mutball.ΣTs, mutball.ΣTs_error, "purple"],
        ['A→G + T→C', mutball.Ts1, mutball.Ts1_error, "blue"],
        ['G→A + C→T', mutball.Ts2, mutball.Ts2_error, "blue"],
        ['Total Tv', mutball.ΣTv, mutball.ΣTv_error, "purple"],
        ['A↔T', mutball.TvW, mutball.TvW_error, "blue"],
        ['A→C + T→G', mutball.TvN1, mutball.TvN1_error, "blue"],
        ['G→T + C→A', mutball.TvN2, mutball.TvN2_error, "blue"],
        ['G↔C', mutball.TvS, mutball.TvS_error, "blue"]
    ];
    var data = [{
        x: foredata.map(function(v) {
            return v[0]
        }),
        y: foredata.map(function(v) {
            return v[1]
        }),
        error_y: {
            type: 'data',
            array: foredata.map(function(v) {
                return v[2]
            }),
            visible: true
        },
        marker: {
            color: foredata.map(function(v) {
                return v[3]
            })
        },
        type: 'bar',
        name: 'indicator'
    }];
    var layout = {};
    Plotly.newPlot('biasChart', data, layout);
}