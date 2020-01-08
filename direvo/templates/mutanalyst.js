$('#mutanalyst_bias_calculate').click(Btn_calcBias);
$('#mutanalyst_bias_demo').click(Btn_demo);
$('#mutanalyst_bias_clear').click(function(){Btn_blank(1)});
$('#mutanalyst_freq_calculate').click(Btn_calcFreq);
$('#mutanalyst_freq_demo').click(Btn_demo);
$('#mutanalyst_freq_clear').click(function(){Btn_blank(1)});



$("#mutanalyst_seq§").show();
$("#mutanalyst_freq§").hide();
$("#altH_showing_button").hide();
$("#altH_showing_button_off").hide();
$("#mutanalyst_freq_alt_in§").hide();
$("#mutanalyst_corrected§").hide();
$("#mutanalyst_bias§").hide();
$("#mutanalyst_more§").hide();


//PedelAA
function applyLoad(data) {
var bases=['A','T','G','C'];
    for (var fi=0; fi<4; fi++) { //from
        for (var ti=0; ti<4; ti++) { //to
            $("#{0}2{1}".format(bases[fi],bases[ti])).val(data[fi][ti]);
        }
    }
}
$("#mutanalyst_opt_mutazyme").click(function () {applyLoad([[0, 15, 9, 2],[15, 0, 2, 9],[13, 7, 0, 2],[7, 13, 2, 0]]);});
$("#mutanalyst_opt_manganese").click(function () {applyLoad([[0, 20, 14, 4],[20, 0, 4, 14],[7, 2, 0, 1],[2, 7, 1, 0]]);});
$("#mutanalyst_opt_MP6").click(function () {applyLoad([[0,3,,15,8],[3,0,8,16],[13,8,0,2],[7,17,0,0]]);});
$("#mutanalyst_opt_D473G").click(function () {applyLoad([[0,5,8,5],[14,0,0,5],[9,4,0,2],[3,6,3,0]]);});
$("#mutanalyst_opt_analogues").click(function () {applyLoad([[0,0,27,6],[0,0,2,54],[11,0,0,0],[0,6,0,0]]);});
$("#mutanalyst_opt_uniform").click(function () {applyLoad([[0,8.3,8.3,8.3],[8.3,0,8.3,8.3],[8.3,8.3,0,8.3],[8.3,8.3,8.3,0]]);});
$('#mutanalyst_sequence_retrieve').click(function () {
    $('#mutanalyst_sequence').val(window.sessionStorage.getItem('sequence'));
});
$('#mutanalyst_retrieve_spectrum').click(function () {
    applyLoad(JSON.parse(window.sessionStorage.getItem('spectrum')));
});

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



/*  __DOC__ equivalent:
The library uses an object mutball, as in mutation ball, like tarball, which store all the variables.
DOM I/O is handled by mutationalAux.js, in there there are some elements whose IDs match attributes of the mutball and it reads the query string too if the webhost allows it. The attributes are:
source: a note telling us whence the object came
sequence: ATATCGG
baseList:G286A T306C A687T T880C\nWT\nWT
freqMean: mean frequency of number of mutations per sequence, average
freqVar: var of #muts/seq
freqList: array of the mutation counts of the rows of baselist.
freqΣ: sum of #muts/seq sampled
freqλ: Poisson distribution of #muts/seq
rawTable: 4x4 nested arrays. containing the mutation spectrum observed
mutTable: as above but normalised.
sumA: 29.6
sumT etc.
A2T number of incidents going from N to N. There are 16 of these.
size: gene size in kb.
_types: seriously lazy way of doing this, its an array of the attributes I care about. python's __dict__
TsOverTv and TsOverTv_error: transitions over transversions
More like that, see _types. W=weak AT, S=strong GC, N=any ΣTs total transitions. ΣTv transversions.

The mutball constructor is mutagen.

*/

//**************************************************
//Globals. Turbo Pascal style declaration at the top. Go high school nostagia!
    var A = 0; //Not the nicest way, but it's handy way to avoid a needless obj and quotes.
    var T = 1;
    var G = 2;
    var C = 3;
	var bases = ['A', 'T', 'G', 'C']; // Unfortunately two different approaches to fill tables were inadvertedly taken.
	var ways=[];
	for (b in bases) {
		for (d in bases) {
		ways.push(bases[b]+"2"+bases[d]);
	}
	}
//**************************************************
//the mutball object.
//Commit and read were initially written as methods of mutball, but were moved out in order to quarantine interactions with document to the document.
//The single letter codes (A, C, T, G, S, W, N and so forth are the normal ones. see https://en.wikipedia.org/wiki/Nucleic_acid_notation if unfamiliar. Ts transition, Tv transversion.
function mutagen() {
    var mutball = {
        source: "load",
        sequence: "",
        baseList: "",
        freqMean: "N/A",
        freqVar: "N/A",
        freqList: "N/A",
        mutTable: [
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ],
		compTable: [
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ],
		rawTable: [
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ],
        _types: ['TsOverTv', 'W2SOverS2W', 'W2N', 'S2N', 'W2S', 'S2W', 'ΣTs', 'Ts1', 'Ts2', 'ΣTv', 'TvW', 'TvN1', 'TvS', 'TvN2']
    }
    for (b in bases) {
        mutball["sum" + bases[b]] = "25";
    }
    for (b in ways) {
        mutball[ways[b]] = "0";
    }
    return mutball;
}

//**********************************
//Math fnxs
function variance(values) {
    var avg = average(values);
    var squareDiffs = values.map(function(value) {
        var diff = value - avg;
        return diff * diff;
    });
    return average(squareDiffs);
}

function average(data) {
    var sum = data.reduce(function(sum, value) {
        return sum + value;
    }, 0);
    return sum / data.length;
}

function rd(x) {
    return Math.round(x * 10) / 10;
}

function transSum(m, x, y, w, z) {
    var s = m[x][y] + m[w][z];
    var v = variance([m[x][y], m[w][z]]);
    var d = Math.sqrt(v / 2);
    return [s, d, v];
}

function varRatio(mx, vx, my, vy, n) {
    var mxsq = Math.pow(mx, 2);
    var mysq = Math.pow(my, 2);
    var mxqd = Math.pow(mx, 4);
    return Math.abs(vy / mxsq + mysq * vx / mxqd) / n; //covariance set to 0.
}

function qV(m, x, y) {
    return variance([m[x][y], m[y][x]]);
}

function fit(ordinate) {
    //ordinate=mutball.freqList;
    abscissa = [];
    s = ordinate.reduce(function(a, b) {
        return a + b;
    }); //And this is why JS is a pain.
    //load underscore range? Nah, I need to fix blanks and normalise
    for (n = 0; n < ordinate.length; n++) {
        ordinate[n] = ordinate[n] / s || 0;
        abscissa[n] = n;
    }
    //
    //Math.factorial() does not call. http://mathjs.org/docs/reference/functions/factorial.html says it should.
    poisson = function(x, P) {
        λ = P[0];
        return x.map(function(xi) {
            function factorial(n) {
                if (n == 0) {
                    return 1
                } else if (n == 1) {
                    return 1
                } else {
                    return n-- * factorial(n)
                }
            }
            return Math.pow(λ, xi) * Math.exp(-λ) / factorial(xi)
        })
    }
    return fminsearch(poisson, [0.5], abscissa, ordinate);
}

//Major fnxs

function calcFreq(mutball) {
    //mutball = mutball || mutagen().read(["sequence","baseList"]);
    //parse sequence
    var seq = mutball.sequence.replace(/\>.*?(\n|\r)/g, '').replace(/U/g, 'T').replace(/[^ATGC]/g, '').split('');//lowercase means masked normally, so best no i.
    var freq = {
        'A': 0,
        'C': 0,
        'G': 0,
        'T': 0
    };
    for (var x = 0; x < seq.length; x++) {
        freq[seq[x]]++;
    }
    for (var x = 0; x < 4; x++) {
        mutball["sum" + bases[x]] = Math.round(freq[bases[x]] / seq.length * 1000) / 10;
    }
	mutball.size=Math.round(mutball.sequence.length/100)/10;
    //parse mutants
    var tally = [];
    var raw_list = mutball.baseList.replace(/U/g, 'T').split(/\r\n|\r|\n|\;/g);
    for (var i = 0; i < raw_list.length; i++) {
        if (!raw_list[i].match(/\w/)) {
            continue;
        }
        var variant = raw_list[i].split(/[\s\t\,]+/g);//split on white space.
        if ((variant[0] == 'WT') || (variant[0] == 'wt') || (variant[0].match("wild"))) {
            tally[i] = 0;
            continue;
        }
        tally[i] = variant.length;
        for (var j = 0; j < variant.length; j++) {
			//console.log(variant[j]);
			if (variant[j].match(/\>/)) {mutball[variant[j].substr(-3, 1) + "2" + variant[j].substr(-1, 1)]++;}  //123A>C
			else if (variant[j].match(/\w/)) {mutball[variant[j].substr(0, 1) + "2" + variant[j].substr(-1, 1)]++;}  //A123C
			else {tally[i]-=1;} ///Don't die? why is there this formatting error? drunk student?

        }
    }
	var sum=tally.reduce(function(a, b) {return a + b;});
		    for (var x = 0; x < 4; x++) {
			    for (var y = 0; y < 4; y++) {
					mutball.rawTable[x][y]=mutball[bases[x]+ "2" + bases[y]]/sum*100;
				}
		}
    mutball.freqMean = Math.round(average(tally) * 10) / 10;
    mutball.freqVar = Math.round(variance(tally) * 10) / 10;
	mutball.freqΣ=tally.reduce(function(sum, value) {return sum + value;}, 0);

    var pivot = []; //can't remember the fancy trick to make a counter
    for (var j = 0; j < tally.length; j++) {
        pivot[tally[j]] = pivot[tally[j]] || 0;
        pivot[tally[j]]++;
    }
    for (var j = 0; j < pivot.length; j++) { //copypaste fix. clean needed.
        pivot[j] = pivot[j] || 0;
    }
    mutball.freqList = pivot.map(function(x) {
        return x
    }); //deref and re-ref.
    mutball.freqλ = rd(fit(pivot) * 10) / 10;
    mutball.source = "freq";
	//not mutball.mutTable_raw! as I don't want to loose the input boxes.


    return mutball;
}

function calcBias(mutball) {
	//don't use storage as it could be user given.
    //mutball = mutball || mutagen().read(ways.concat(["sumA","sumT","sumG","sumC"]));
    //Get data. As they are separate input boxes the thing is more nightmare
    var Amuts = ["A2A", "A2T", "A2G", "A2C"].map(function(x) {
        return mutball[x]
    });
    var Tmuts = ["T2A", "T2T", "T2G", "T2C"].map(function(x) {
        return mutball[x]
    });
    var Gmuts = ["G2A", "G2T", "G2G", "G2C"].map(function(x) {
        return mutball[x]
    });
    var Cmuts = ["C2A", "C2T", "C2G", "C2C"].map(function(x) {
        return mutball[x]
    });
    var muts = [Amuts, Tmuts, Gmuts, Cmuts];
    var dis = ["sumA", "sumT", "sumG", "sumC"].map(function(x) {
        return mutball[x]
    });;

    //Normalise
    var summa = 0;
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            muts[i][j] /= dis[i];
            summa += muts[i][j];
        }
    }
    summa /= 100; // /100 --> %
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            muts[i][j] /= summa;
        }
    }
    mutball.mutTable = muts;


			//the 4 2x2 submatrices are symmetric if ordered AT-GC.
		for (h=0; h<3; h+=2){ //0 or 2
			for (g=0; g<3; g+=2){
				console.log("submatrix "+h+","+g);
			for (x =0; x<2; x++) {
				for (y =0; y<2; y++) {
					//console.log(h+"+"+x+" into "+g+"+"+y+" vs. "+h+"+"+y+" into "+g+"+"+x);
					//console.log(bases[h+x]+'2'+bases[g+y]+' '+bases[h+y]+'2'+bases[g+x]);
					mutball.compTable[h+x][g+y]=muts[h+x][g+y]/2 +muts[h+!x][g+!y]/2;//it actually switches the diagonal. But it's zero.
					}
			}
				}
			}
	//Check: if the following is used, the errors should be zero.
	//muts=mutball.compTable;

    //Canculate fancy table
    //A>G + T>C
    var Ts1 = transSum(muts, A, G, T, C);

    //G>A + C>T
    var Ts2 = transSum(muts, G, A, C, T);

    //Ts total
    //As of ECMA 5, unicode variables you say?
    var ΣTs = [];
    ΣTs[0] = Ts1[0] + Ts2[0];
    ΣTs[2] = Ts1[2] + Ts2[2]; //Biename for variance.
    ΣTs[1] = Math.sqrt(ΣTs[2] / 2); // n  is 2

    //A>T + T>A
    var TvW = transSum(muts, A, T, T, A);

    //A&#8594;C, T&#8594;G
    var TvN1 = transSum(muts, A, C, T, G);

    // G&#8594;C, C&#8594;G
    var TvS = transSum(muts, G, C, C, G);

    // G&#8594;T, C&#8594;A
    var TvN2 = transSum(muts, G, T, C, A);

    //Tv total
    var ΣTv = [];
    ΣTv[0] = TvW[0] + TvS[0] + TvN1[0] + TvN2[0];
    ΣTv[2] = TvW[2] + TvS[2] + TvN1[2] + TvN2[2]; //Biename for variance.
    ΣTv[1] = Math.sqrt(ΣTv[2] / 4); // n =4

    //Ts/Tv
    var TsOverTv = [];
    TsOverTv[0] = ΣTs[0] / ΣTv[0];
    TsOverTv[2] = varRatio(ΣTs[0], ΣTs[2], ΣTv[0], ΣTv[2], 2); // Taylor w n =2
    TsOverTv[1] = Math.sqrt(TsOverTv[2] / 2);

    //AT&#8594;GC
    var W2S = [];
    W2S[0] = muts[A][G] + muts[A][C] + muts[T][G] + muts[T][C];
    W2S[2] = variance([muts[A][G], muts[T][C]]) + variance([muts[A][C], muts[T][G]]);
    W2S[1] = Math.sqrt(W2S[2] / 2);

    //GC&#8594;AT
    var S2W = [];
    S2W[0] = muts[G][A] + muts[G][T] + muts[C][A] + muts[C][T];
    S2W[2] = variance([muts[G][A], muts[C][T]]) + variance([muts[G][T], muts[C][A]]);
    S2W[1] = Math.sqrt(S2W[2] / 2);

    //AT&#8594;GC/GC&#8594;AT
    var W2SOverS2W = [];
    W2SOverS2W[0] = W2S[0] / S2W[0];
    W2SOverS2W[2] = varRatio(W2S[0], W2S[2], S2W[0], S2W[2], 2);
    W2SOverS2W[1] = Math.sqrt(W2SOverS2W[2] / 2);

    ////AT&#8594;GC/GC&#8594;AT
    var W2SOverS2W = [];
    W2SOverS2W[0] = W2S[0] / S2W[0];
    W2SOverS2W[2] = varRatio(W2S[0], W2S[2], S2W[0], S2W[2], 2);
    W2SOverS2W[1] = Math.sqrt(W2SOverS2W[2] / 2);

    //A&#8594;N, T&#8594;N
    var W2N = [];
    W2N[0] = muts[A][T] + muts[A][G] + muts[A][C] + muts[T][A] + muts[T][G] + muts[T][C];
    W2N[2] = qV(muts, A, T) + qV(muts, A, G) + qV(muts, A, C) + qV(muts, T, A) + qV(muts, T, G) + qV(muts, T, C);
    W2N[1] = Math.sqrt(W2N[2] / 6);

    //G&#8594;N, C&#8594;N
    var S2N = [];
    S2N[0] = muts[G][A] + muts[G][T] + muts[G][C] + muts[C][A] + muts[C][G] + muts[C][T];
    S2N[2] = qV(muts, G, A) + qV(muts, G, T) + qV(muts, G, C) + qV(muts, C, A) + qV(muts, C, G) + qV(muts, C, T);
    S2N[1] = Math.sqrt(W2N[2] / 6);
    var types = mutball._types;

    for (var x = 0; x < types.length; x++) {
        var indicator = types[x]; //I hate JS. 'for in' couldn't be used.
        eval("mutball." + indicator + "=rd(" + indicator + "[0])");
        //this[indicator] did not work. So much for dynamic variables.
        eval("mutball." + indicator + "_error=rd(" + indicator + "[1])");
    }
    mutball.source = 'Bias';
    return mutball;
}

//The following function was copied from https://jmat.googlecode.com/git/jmat.js
//It seemed a bit silly loading a whole library for a function.
function fminsearch(fun,Parm0,x,y,Opt){// fun = function(x,Parm)
	if(!Opt){Opt={}};
	if(!Opt.maxIter){Opt.maxIter=1000};
	if(!Opt.step){// initial step is 1/100 of initial value (remember not to use zero in Parm0)
		Opt.step=Parm0.map(function(p){return p/100});
		Opt.step=Opt.step.map(function(si){if(si==0){return 1}else{ return si}}); // convert null steps into 1's
	};
	if(typeof(Opt.display)=='undefined'){Opt.display=true};
	if(!Opt.objFun){Opt.objFun=function(y,yp){return y.map(function(yi,i){return Math.pow((yi-yp[i]),2)}).reduce(function(a,b){return a+b})}} //SSD

	var cloneVector=function(V){return V.map(function(v){return v})};
	var ya,y0,yb,fP0,fP1;
	var P0=cloneVector(Parm0),P1=cloneVector(Parm0);
	var n = P0.length;
	var step=Opt.step;
	var funParm=function(P){return Opt.objFun(y,fun(x,P))}//function (of Parameters) to minimize
	// silly multi-univariate screening
	for(var i=0;i<Opt.maxIter;i++){
		for(var j=0;j<n;j++){ // take a step for each parameter
			P1=cloneVector(P0);
			P1[j]+=step[j];
			if(funParm(P1)<funParm(P0)){ // if parm value going in the righ direction
				step[j]=1.2*step[j]; // then go a little faster
				P0=cloneVector(P1);
			}
			else{
				step[j]=-(0.5*step[j]); // otherwiese reverse and go slower
			}
		}
		if(Opt.display){if(i>(Opt.maxIter-10)){console.log(i+1,funParm(P0),P0)}}
	}
	if (!!document.getElementById('plot')){ // if there is then use it
		fminsearch.plot(x,y,fun(x,P0),P0);
	}
	return P0
};



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
window.Btn_demo=Btn_demo;
window.Btn_blank=Btn_blank;
window.Btn_calcFreq=Btn_calcFreq;
window.Btn_calcBias=Btn_calcBias;
window.Btn_FrqIn=Btn_FrqIn;
window.Btn_SeqIn=Btn_SeqIn;

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
    console.log('here')
    console.log(mutball.freqλ)
    console.log(mutball.freqMean)
    if ((mutball.freqλ/mutball.freqMean > 1.3) || (mutball.freqMean/mutball.freqλ > 1.3)) {
        $('#avg_advice').addClass('show');
    } else {$('#avg_advice').removeClass('show');}
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