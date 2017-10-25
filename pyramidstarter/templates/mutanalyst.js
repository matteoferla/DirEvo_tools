$( document ).ready(function() {
$("#introT2").hide();
$("#seq§").show();
$("#seqT1").hide();
$("#seq§2").hide();
$("#avg§").hide();
$("#avgT2").hide();
$("#freq§").show();
$("#freqT1").hide();
$("#freq§2").hide();
$("#bias§").hide();
$("#next§").hide();
$("#biasT2").hide();
$("#nextT2").hide();
$("#corrT2").hide();

$("#pedel_opt§").hide();
var mutball=mutagen();
var queries = window.location.search.substring(1).split("&");
for (var i=0;i<queries.length;i++) {
var pair=queries[i].split("=");
if (!!pair[1]) {
eval("mutball."+pair[0]+"='"+pair[1].replace("%20"," ").replace("%0A","\\n")+"'");}}
commit(mutball);
//google.load('visualization', '1', {packages: ['corechart'],callback: function() {}}); //callback is stop it writing, but append

$('#sequence_retrieve').click(function () {
    $('#sequence').val(window.sessionStorage.getItem('sequence'));
});

});

//**************************************************
//**************************************************
//Button wrappers.
//They don't touch any Doc elements. Only the mutball does via it's read() and commit() methods. This was done for portability. However, the attributes are document ids too. If one were to change them the read and commit methods need changing.
function Btn_blank(n) {
commit();
$("#seq§2").hide();
$("#seqT1").hide();
$("#seqT2").show();
$("#avg§").hide();
$("#freq§2").hide();
$("#freqT1").hide();
$("#freqT2").show();
$("#bias§").hide();
$("#next§").hide();
if (n ==1) {$("#seq§").show();}
else if (n==2)  {$("#freq§").show();}
//return false;
}
function Btn_demo() {
var mutball=mutagen();
mutball.sequence="ATGAACACAGACGACATTCTGTTTTCTTACGGAGAAGAAGACATTCCTTTGAAGGCGCTGTCGTTTCCCATCTTCGAAACGACGAATTTCTACTTCGACAGTTTCGACGAGATGTCGAAAGCCCTCAGAAACGGAGACTACGAATTCGTTTACAAAAGAGGAAGTAATCCCACAACGAGACTGGTGGAGAAGAAACTCGCAGCGCTTGAAGAGTGTGAAGATGCCCGCCTCGTTGCCTCTGGAATGAGCGCCATTTCGCTTTCCATCCTTCATTTCCTCAGCTCGGGAGACCACGTCGTGTGTGTGGACGAGGCTTACTCCTGGGCGAAAAAGTTCTTCAACTACCTTTCAAAGAAGTTCGATATAGAAGTCAGCTACGTTCCTCCCGACGCGGAAAGAATAGTCGAAGCCATCACGAAGAAGACGAAGCTCATCTACCTCGAAAGTCCCACGAGTATGAGAATGAAAGTGATCGATATAAGAAAGGTCACAGAAGCGGCAGGAGAACTCAAGATAAAAACCGTCATAGACAACACCTGGGCGTCGCCGATCTTTCAAAAACCAAAGCTTCTGGGAGTGGATGTGGTGGTCCACTCTGCGACGAAGTACATCTCAGGACACGGAGACGTGATGGCAGGAGTGATCGCAGGAGACGTCGAAGATATGAAGAACATCTTCGTGGATGAATACAAAAACATCGGACCGGTTCTCTCGCCCATAGAAGCCTGGCTCATCTTGAGAGGTCTTAGAACGCTGGAACTCCGTATGAAAAAGCACTACGAAAACGCTCTTGTGGTGTCTGACTTCCTCATGGATCACCCGAAGGTCCTCGAGGTGAACTACCCGATGAATCCAAGATCACCGCAGTACGAACTCGCTTCCTCTCAGATGAGCGGTGGCTCAGGACTGATGAGCTTCAGGCTGAAAACGGACAGCGCAGAGAAAGTCAAAGAGTTCGTCGAAAGTCTGAGGGTTTTCAGGATGGCTGTGAGCTGGGGAAGTCACGAGAACCTTGTTGTTCCAAGGGTGGCTTATGGAGACTGCCCGAAAAAAGACGTGAACCTGATAAGAATCCATGTGGGTCTCGGAGATCCAGAAAAGCTCGTGGAAGATCTGGATCAGGCACTCAAAAAGATTTAA";
mutball.baseList="G286A T306C A687T T880C\nWT\nWT\nC372T A923G\nG832A\nA650C\nA720C\nC449A A556G A814G A853G C826T C1059T\nG793A\nA1048G\nG726T\nG982C\nC53T G678T T798A\nA224T A447G A586T C964T\nA185T\nT860A\nA979T A1005T\nC453T\nWT";
calc(mutball,0);
//return false;
}

function calc(mutball,n) {
	if (! n) {
	mutball=calcFreq(mutball);
	$("#altH").html("Editing the");
commit(mutball); //Not redundant due to the div show and hide.
//if (google.visualization.arrayToDataTable) {
//displot(mutball);} else {
//google.setOnLoadCallback(function (){displot(mutball)})}
displot(mutball);
}
	mutball=calcBias(mutball);
commit(mutball);
svg();
/*
if (google.visualization.arrayToDataTable) {
plot(mutball);} else {
google.setOnLoadCallback(function (){plot(mutball)})}
}
*/
plot(mutball);
}

function Btn_calcFreq() {
window.sessionStorage.setItem('sequence', $('#sequence').val());
var mutball=read(["sequence","baseList"]);
calc(mutball,0);
//return false;
}
function Btn_calcBias(){
$("#seq§").hide();
$("#avg§").hide();
$("#freq§").show();
$("#bias§").show();
$("#next§").show();
//console.log(ways.concat(["sumA","sumT","sumG","sumC"]));
mutball = calc(read(ways.concat(["sumA","sumT","sumG","sumC"])),1);
//return false;
}
function Btn_FrqIn() {
//$("#seq§").css("visibility", "collapse");
$("#seq§").hide();
$("#avg§").hide();
$("#freq§").show();
$("#bias§").hide();
$("#next§").show();
$("#optionality").html('If the former option is desired,  <a href="#" onClick="Btn_SeqIn();">click here</a>.');
//return false;
}

function Btn_SeqIn() {
//$("#seq§").css("visibility", "collapse");
$("#seq§").show();
$("#avg§").hide();
$("#freq§").hide();
$("#bias§").hide();
$("#next§").show();
$("#optionality").html('If the latter option is desired,  <a href="#" onClick="Btn_FrqIn();">click here</a>.');
//return false;
}
//Interactions of Mutball and the HTML
function commit(mutball) {
mutball= mutball || mutagen();
if (mutball.source=='freq') {$("#freq§").show(); $("#avg§").show(); $("#next§").show();}
if (mutball.source=='Bias') {$("#bias§").show(); $("#next§").show();} //id="bias§" style=
for (handle in mutball) {
if ($("#"+handle).is('table')) {
//if (handle =='mutTable') {
for (i = 0; i < 4; i++) {
for (j = 0; j < 4; j++) {
$("#"+handle+" tbody tr:eq("+i+") td:eq("+j+")").html(rd(mutball[handle][i][j]));
}
}
}
//it will try changing non existant sections, but that's okay
else{$("#"+handle).val(mutball[handle]); $("#"+handle).text(mutball[handle]);}
}
sessionStorage.setItem('ball', JSON.stringify(mutball));
}
function read (handles) {
var mutball=mutagen();
if (!! handles) {
for (h in handles) {mutball[handles[h]]=$("#"+handles[h]).val();}}
else {mutball = JSON.parse(sessionStorage.getItem('ball'));}
return mutball;
}
function svgTabulate(table) {
var bases=['A','T','G','C'];
for (i=0; i<4;i++){
for (j=0; j<4;j++){
$("#"+bases[i]+bases[j]+"_line").attr("stroke-width",2*table[i][j]/12.5);
//console.log(bases[i]+bases[j]+"_line "+table[i][j]);
}
}
pedel(mutball);
}

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

function diagnose_arrow() {
	$("#intro§").hide();
$("#seq§").hide();
$("#avg§").hide();
$("#freq§").hide();
for (a=0; a<4;a++){
for (b=0; b<4;b++){
x=[ [0, 0, 0, 0], [0, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0]];
svgTabulate(x);
$("#"+bases[a]+bases[b]+"_line").attr("stroke-width",10);
alert(bases[a]+bases[b]);
}
}
return false;
	}

function svg() {
var bases=['A','T','G','C'];
mutball=read();
if ($("input[name=fig]:checked").val()==1) {svgTabulate(mutball.rawTable); mutball.outTable=mutball.rawTable; mutball.mutBlabla="Raw incidence of mutations (%)."}
else if ($("input[name=fig]:checked").val()==2) {svgTabulate(mutball.mutTable);  mutball.outTable=mutball.mutTable; mutball.mutBlabla="Sequence-composition–corrected incidence of mutations (%)."}
else if ($("input[name=fig]:checked").val()==3) {svgTabulate(mutball.compTable);  mutball.outTable=mutball.compTable; mutball.mutBlabla="Sequence-composition–corrected incidence of mutations averaged assuming strand complementary (%)."}
else {alert('No radiobox selection');}
commit(mutball);
$('#down').attr("href",'data:image/svg+xml;utf8,' +  unescape($('#Layer_1')[0].outerHTML));
}

function displot(mutball){
	poisson = function(k, λ) {function factorial(n) {
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

    var data = [
          {
            x: mutball.freqList.map(function(v,i){return i}),
            y: mutball.freqList,
            type: 'bar',
            name: 'Empirical data'
          },
          {x: mutball.freqList.map(function(v,i){return i}),
          y: mutball.freqList.map(function(v,i){return mutball.freqΣ * poisson(i,mutball.freqλ)}),
          type: 'scatter',
          name: 'Poisson fit'}
        ];
    var layout = {yaxis: {title: 'Number of counts'},xaxis: {title: 'Number of mutations per sequence'},bargap:0};
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

	var foredata =[['Tv/Ts',mutball.TsOverTv*100,mutball.TsOverTv_error*100,"Indianred"],
['AT→GC/GC→AT',mutball.W2SOverS2W*100,mutball.W2SOverS2W_error*100,"orange"],
['AT→N',mutball.W2N,mutball.W2N_error,"green"],
['GC→N',mutball.S2N,mutball.S2N_error,"green"],
['AT→GC',mutball.W2S,mutball.W2S_error,"teal"],
['GC→AT',mutball.S2W,mutball.S2W_error,"teal"],
['Total Ts',mutball.ΣTs,mutball.ΣTs_error,"purple"],
['A→G + T→C',mutball.Ts1,mutball.Ts1_error,"blue"],
['G→A + C→T',mutball.Ts2,mutball.Ts2_error,"blue"],
['Total Tv',mutball.ΣTv,mutball.ΣTv_error,"purple"],
['A↔T',mutball.TvW,mutball.TvW_error,"blue"],
['A→C + T→G',mutball.TvN1,mutball.TvN1_error,"blue"],
['G→T + C→A',mutball.TvN2,mutball.TvN2_error,"blue"],
['G↔C',mutball.TvS,mutball.TvS_error,"blue"]
	];
	var data = [{x:foredata.map(function(v) {return v[0]}),
	            y:foredata.map(function(v) {return v[1]}),
	            error_y: {
                    type: 'data',
                    array: foredata.map(function(v) {return v[2]}),
                    visible: true
                  },marker:{
                        color: foredata.map(function(v) {return v[3]})
                      },
	            type: 'bar', name: 'indicator'}];
	var layout = {};
	Plotly.newPlot('biasChart', data, layout);
	}

