// JavaScript Document

function Sequence(seqstr) {
	//I hate JS objects. So unclassy.
	this.raw=seqstr;
	temp=seqstr.split(/\r\n|\r|\n/);
	this.header=temp.shift();
	this.sequence=temp.join("").toUpperCase().replace(/[^ATUGC\-\.NWSRYMKBDHV]/g,"").replace("U","T").replace(".","-");
	this.mutations=[];
	return this;
	}

function mutation(wt,mut,i) {
	var equivalency={S:"GC", W:"AT", Y:"GA", R:"TC", M:"AC", K:"GT", N:"ATGC", B:"CTG",D:"ATG", H:"ATC",V:"ACG"};
	this.index=i;
	this.valid=0;
	this.pair=[wt.sequence[i],mut.sequence[i]];
	this.id=wt.sequence[i]+(i+1)+mut.sequence[i];
	if (i==0) {this.quintets=["**"+wt.sequence.substring(0,3),"**"+mut.sequence.substring(0,3)];}
	else if (i==1) {this.quintets=["*"+wt.sequence.substring(0,4),"*"+mut.sequence.substring(0,4)];}
	else if (i==wt.sequence.length-1) {this.quintets=[wt.sequence.substring(i-3,i)+"**",mut.sequence.substring(i-3,i)+"**"];}
	else if (i==wt.sequence.length-2) {this.quintets=[wt.sequence.substring(i-3,i+1)+"*",mut.sequence.substring(i-3,i+1)+"*"];}
	else {this.quintets=[wt.sequence.substring(i-2,i+3),mut.sequence.substring(i-2,i+3)];}
	this.flag=[];
	if(this.quintets[1][2]==this.quintets[1][1]) {
		if(this.quintets[1][2]==this.quintets[1][0]) {
			this.flag.push("slip of forward repeats?");
		}
		else {this.flag.push("slip of forward repeat?");}
	}
		if(this.quintets[1][2]==this.quintets[1][3]) { //the sequence could be reveresed..
		if(this.quintets[1][2]==this.quintets[1][4]) {
			this.flag.push("slip of backward repeats?");
		}
		else {this.flag.push("slip of backward repeat?");}
		}
		if (mut.sequence[i].match(/[ATGC\-]/)) { } //pass
		else if (equivalency[mut.sequence[i]].match(wt.sequence[i])) {
			this.flag.push(mut.sequence[i]+" includes "+wt.sequence[i]);
			}
			
		if(mut.sequence[i].match(/[NBDHV]/)) {
			this.flag.push("bad sequencing quality ("+mut.sequence[i]+")");
			}
	return this;
	}
	
function matcher(wt,mut) {
	if (mut.sequence.length !=wt.sequence.length) {
		alert("Length Mismatch: "+mut.header);
		console.log(mut.sequence.length+" "+mut.sequence);
		console.log(wt.sequence.length+" "+wt.sequence);
		return 0;}
			for (i=0; i <mut.sequence.length; i++) {
				if (wt.sequence[i] != mut.sequence[i]) {
					mut.mutations.push(new mutation(wt,mut,i));
					}
				  }
	}

function Btn_identifier() {
	var wtSeq=$("#wt").val();
	var mutSeqs=$("#mutants").val().split(">");
	wt=new Sequence(wtSeq);
	seqball=[wt];
	$("#out_match¶").html("");
	for (x=0; x< mutSeqs.length; x++) {
		if (mutSeqs[x].search(/[ATUGC]/) == -1) {continue;}
			mut=new Sequence(">"+mutSeqs[x]); //Might as well keep the chevron.
			matcher(wt,mut);
			$("#out_match¶").append("<br/>"+mut.header+"<br/>"+"mutations: "+mut.mutations.length+"; <br/>");
			$("#out_match¶").append(mut.mutations.map(function(m, j){s="<label style='text-align:left'><input type='checkbox' id="+('č'+x+'_'+j)+" style='width=20px'> "+m.id+" from "+m.quintets[0]+" to "+m.quintets[1]+"  "; if (!! m.flag.length){s+=" &mdash;"+(m.flag.join(", "));} s+="</label>"; return s;}).join("<br/>")+"<br/>"); //Bad Perl flashbacks of $#(\[f(x)]) idioms.
			seqball.push(mut);
		}
		sessionStorage.setItem('seqball', JSON.stringify(seqball));
		$("#result§").show("slow");
	}

function Btn_blank() {
	$("#wt").val("");
	$("#mutants").val("");
		$("#result§").hide();
		$("#sel§").hide();
	}
	
function Btn_spam() {
	var names=["alpha","bravo","charlie","delta","echo","foxtrot","golf","hotel","india","juliet","kite","llama","mike","november","oscar"]; 
	var bases=["A","T","G","C"];
	var header=">"+names[Math.round(Math.random()*names.length-0.5)]+"\n";
	var wt="";
	for (x=0; x<100; x++) {
		wt+=bases[Math.round(Math.random()*3.5)];
		}
	$("#wt").val(header+wt);
	bases=["A","T","G","C","W","S","-","K","M","Y","R","N"];
	var mutants="";
	for (y=0; y<4; y++) {
		var header=">"+names[Math.round(Math.random()*names.length-0.5)]+"\n";
		var mut=""+wt; //cheat clone
		for (m=0; m<10; m++) {
			index=Math.round(Math.random()*mut.length);
			mut=mut.substr(0, index) + bases[Math.round(Math.random()*bases.length-0.5)] + mut.substr(index+1);
}
mutants+=header+mut+"\n";
			}
$("#mutants").val(mutants);
	}
function selector() {
	
	seqball = JSON.parse(sessionStorage.getItem('seqball'));
     var m=$(this).attr('id');
  $("#out_sel§").html("");
	for (i=1; i<seqball.length;i++) {
		  var valid=[];
		  if ($("#radw").is(":checked")) {$("#out_sel§").append(seqball[i].header+"<br/>");}
		for (j=0; j<seqball[i].mutations.length; j++) {
			if ($("#č"+i+"_"+j).is(':checked')) {
					seqball[i].mutations[j].valid=1;
					valid.push(seqball[i].mutations[j].id);
}
			}
			(valid.length)?$("#out_sel§").append(valid.join(" ")):$("#out_sel§").append("wt");
			$("#out_sel§").append("<br/>");
		}
		$("#sel§").show("slow");
	}
	
$(document).ready(function(e) {
	$("#introT2").hide();
	$("#prep_in§").hide();
	$("#prep_out§").hide();
	$("#result§").hide();
		$("#sel§").hide();
	$("#prep_inT2").hide();
	$("#prep_outT2").hide();
	$("#in_alignT2").hide();
	$("#resultsT2").hide();
	$("#out_matchT2").hide();
	$("#sel§").hide();
	$("#selT2").hide();
	
	
});