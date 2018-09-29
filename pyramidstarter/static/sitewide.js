//init
$('[data-toggle="tooltip"]').tooltip();
$(".slider").bootstrapSlider();
$(".switch").bootstrapSwitch();
$(".hidden").hide();
$('#§welcome').modal('hide');
$('#scheme_modal').modal('hide');
$('#comment_modal').modal('hide');
window.setTimeout(function() {
    $('#§welcome').modal('show');
}, 300);

//Themes!!!
var themeNames = ["darkly", "default", "amelia", "cerulean", "cosmo", "cyborg", "flatly", "journal", "readable", "sandstone", "simplex", "slate", "solar", "spacelab", "superhero", "united", "lumen", "paper", "yeti"];
var themes = {};
var mytheme=sessionStorage.getItem('theme') ? sessionStorage.getItem('theme') : 'darkly';
for (i = 0; i < themeNames.length; i++) {
    themes[themeNames[i]] = "/static/bootstrap/themes/" + themeNames[i] + ".min.css";
    if (themeNames[i] == mytheme) {$('#themeSelector').append('<li><a href="#" data-theme=' + themeNames[i] + ' class="theme-link"><b>' + themeNames[i] + '</b></a></li>');}
    else {$('#themeSelector').append('<li><a href="#" data-theme=' + themeNames[i] + ' class="theme-link">' + themeNames[i] + '</a></li>');}
}
var themesheet = $('#theme_CSS');
themesheet.attr('href',themes[mytheme]); //The CDN is loaded first, then I override with the default because JS is done last.
$('.theme-link').click(function() {
    var themeurl = themes[$(this).attr('data-theme')];
    themesheet.attr('href', themeurl);
    $('#current_theme').html($(this).attr('data-theme'));
    sessionStorage.setItem('theme',$(this).attr('data-theme'));
});

// Let's mod string python-style alla StackOverflow (.formatUnicorn)
String.prototype.format = String.prototype.format ||
    function() {
        "use strict";
        var str = this.toString();
        if (arguments.length) {
            var t = typeof arguments[0];
            var key;
            var args = ("string" === t || "number" === t) ?
                Array.prototype.slice.call(arguments) :
                arguments[0];

            for (key in args) {
                str = str.replace(new RegExp("\\{" + key + "\\}", "gi"), args[key]);
            }
        }

        return str;
    };


//comments
$('#comment_send').click(function() {
    $("#comment_status").show();
    $("#comment_status").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
    $.ajax({
        url: '/ajax_email',
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify({
            "message": $('#comment_msg').val(),
            "name": $('#comment_name').val()
        }),
        success: function(result) {
            reply = JSON.parse(result);
            $("#comment_status").html('<div class="alert alert-success" role="alert">' + reply.msg + '</div>');
        },
        error: function() {
            $("#comment_status").html('<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Oh Snap. Nothing back.</div>');
        },
        cache: false,
        contentType: false,
        processData: false
    });
    $("#comment_status").delay(2000).fadeOut();
    $("#comment_modal").delay(3000).modal('hide');
});

//codons
function codonist() {
    $("#codon_result").html('<div class="alert alert-warning" role="alert"><span class="pyspinner"></span> Waiting for server reply.</div>');
    $("#codon_result").removeClass('hidden');
    $("#codon_result").show(); //weird combo.
    data = $('#codon_drop').val();
    if (data == 'other') {
        $("#codon_manual").removeClass('hidden');
        $("#codon_manual").show();
        data = $('#codon_mutation').val();
        if (!data) {
            data = 'NNN';
        }
    } else {
        $("#codon_manual").addClass('hidden');
        $("#codon_manual").hide();
    }
    $.ajax({
        url: '/ajax_codon',
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(data),
        success: function(result) {
            reply = JSON.parse(result.message);
            window.sessionStorage.setItem('codon', JSON.stringify(reply['data']));
            $("#codon_result").html(reply['html']);
            //$("#QQC_download").removeClass('hidden');
            //$("#QQC_download").show(); //weird combo.
            //$("#QQC_result").html(reply['html']);
            AA = ['A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y', '*'];
            Plotly.newPlot('codon_graph', [{
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
$('#codonAA_calculate').click(aminocodonist);
function aminocodonist() {
try {
    var data={list: $('#codonAA_list').val(), antilist: $('#codonAA_antilist').val()};
    $.ajax({
        url: '/ajax_codonAA',
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(data),
        success: function(result) {
            reply = JSON.parse(result.message);
            window.sessionStorage.setItem('codonAA', JSON.stringify(reply['data']));
            $("#codonAA_result").html(reply['html']);
            },
        error: function(xhr) {ajax_error(xhr,"#codonAA_result")},
        cache: false,
        contentType: false,
        processData: false
    });
    }
    catch(err) {client_error(err,"#codonAA_result")}
    return false;
}
parse_query();

var entityMap = {
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;',
  '"': '&quot;',
  "'": '&#39;',
  '/': '&#x2F;',
  '`': '&#x60;',
  '=': '&#x3D;'
};

function escapeHtml (string) {
  return String(string).replace(/[&<>"'`=\/]/g,
    function (s) {
    return entityMap[s];
  });
  }


function ajax_error(xhr,id) {
    $(id).html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span>Oh Snap. Ajax error ({0})</h3><pre><code>{1}</pre><code></div>'.format(xhr.status,escapeHtml(xhr.responseText)));
}

function parse_query() {
    var query = window.location.search.substring(1);
    if (! query) {return }
    var vars = query.split('&');
    for (var i = 0; i < vars.length; i++) {
        //find it...
        var pair = vars[i].split('=');
        var key='error';
        if ($('#'+pair[0]).length) {
            key='#'+pair[0];
        } else {
            var match_flag=false;
            var id = ['main','pedel','MC','MA','QQC','pedelAA','driver','silico','glue'];
            for (var j=0; j < id.length; j++) {
                if ($('#'+id[j]+'_'+pair[0]).length) {
                    key='#'+id[j]+'_'+pair[0];
                    match_flag=true;
                    break;
                }
            }
            if (! match_flag) {alert('document element with id="{0}" not found (value to set: {1})'.format(pair[0], pair[1])); continue;}
        }
        //parse it..
        var value=pair[1];
        if ($(key).is(':checkbox')) {
            switch (value) {
                case 'true': value=true; break;
                case true: value=true; break;
                case '1': value=true; break;
                case 1: value=true; break;
                case 'false': value=false; break;
                case false: value=false; break;
                case '0': value=false; break;
                case 0: value=false; break;
                default: alert('Unrecognised boolean value {1} for id {0}'.format(key, value)); break;
            }
            $(key).bootstrapSwitch('state', value);
            $(key).prop("checked", value);
        }
        else if ($(key).hasClass('btn')) {
            $(key).click();
        }
        else {
            $(key).val(value);
        }
    }
}

function client_error(err,id) {
    $(id).html('<div class="alert alert-danger" role="alert"><h3><span class="pycorpse"></span> Client side error (<i>i.e.</i> something is wrong on your side)</h3><pre><code>{0}</pre><code></div>'.format(err.message));
}
