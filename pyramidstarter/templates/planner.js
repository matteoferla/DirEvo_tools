$('#planner_results').hide();

function planner_toggle(state) {
    if (state) {
    // verify
    $('.planner-verify').show();
    $('.planner-plan').hide();
    $('#planner_method').attr('state',"on"); //hack
    }
    else {
        // plan
        $('.planner-verify').hide();
        $('.planner-plan').show();
        $('#planner_method').attr('state',"off");

    }
}
planner_toggle($('#planner_method').checked);
$('#planner_method').on('switchChange.bootstrapSwitch', function(event, state) {planner_toggle(state)});


function validator (list) {

            console.log(list);
            console.log(list.map(function (value) {return data[value] != ''}));
            console.log(list.every(function (value) {return data[value]  != ''}));
        if (list.every(function (value) {return !! data[value]})) {
            return true;
        }
        else {
            $(list.map(function (value) {return '#planner_'+value})).each(function (i,v) {
                    if ($(v).val()) {$(v).addClass('is-valid');}
                    else {$(v).addClass('is-invalid'); $('#planner_results').append("<div class='alert alert-warning'>Incomplete input ("+v+")</div>");}
                });
            throw "Incomplete ";
        }

    }

$('#planner_demo').click(function () {
    $('.is-valid').removeClass('is-valid');
    $('.is-invalid').removeClass('is-invalid');
    data={'t_size':0.5,'p_size':5,'p_conc':50,'p_vol':1,'y_conc':1000,'y_vol':20,'r_vol':50,'loss':50,'m_rate':0.9,'m_load':5};
    for (var p in data) {
        $('#planner_'+p).val(data[p]);
    }
});

$('#planner_clear').click(function () {
    $('#planner_results').hide();
    $('.is-valid').removeClass('is-valid');
    $('.is-invalid').removeClass('is-invalid');
    data={'t_size':0.5,'p_size':5,'p_conc':50,'p_vol':1,'y_conc':1000,'y_vol':20,'r_vol':50,'loss':50,'m_rate':0.9,'m_load':5};
    for (var p in data) {
        $('#planner_'+p).val('');
    }
});

$('#planner_calculate').click(function () {
    $('#planner_results').show();
    $('#planner_results').html('');
    $('#planner_results').append('<h3>Results</h3>');
    $('.is-valid').removeClass('is-valid');
    $('.is-invalid').removeClass('is-valid');
    // parse data
    var data={};
    var template, product;
    $('input').each(function (i,v) {
        var name=$(v).attr('id');
        var m=name.match(/planner_(.*)/);
                if (m) {
                    data[m[1]] = $(v).val();
                }
    });
    // validation...
    $('#planner_p_conc,#planner_t_size,#planner_p_size').each(function (i,v) {
                    if ($(v).val()) {$(v).addClass('is-valid'); $(v).removeClass('is-invalid');}
                    else {$(v).removeClass('is-valid'); $(v).addClass('is-invalid');}
                });

    // determine state of switch for method (non=standard code)
    if ($('#planner_method').attr('state') == 'on') {
        // verify method
        // parse template
        if (! data['t_ng']) {
            validator(['p_conc', 'p_vol', 't_size', 'p_size']);
            template = parseFloat(data['p_conc']) * parseFloat(data['p_vol']) * parseFloat(data['t_size']) / parseFloat(data['p_size']);
        }
            else {
           template=parseFloat(data['t_ng']);
        }
        // parse yield
        if (! data['y_ng']) {
            validator(['y_conc', 'y_vol']);
            product = parseFloat(data['y_conc']) * parseFloat(data['y_vol']);
        }
            else {
           product = parseFloat(data['y_ng']);
        }
        // other
        validator(['r_vol', 'loss','m_rate']);
        // calc
        var cProd = product/(parseFloat(data['loss'])/100);
        var duplications=Math.log2(cProd/template);
        var mLoad=duplications*parseFloat(data['m_rate']);
        $('#planner_results').append(['<p>','<b>Template:</b>',template.toString(),'ng;',
                                            '<b>Yield:</b>',cProd.toString(),'ng;',
                                            '<b>Duplications:</b>',(Math.round(duplications*10)/10).toString(),'times',
                                            '<b>Mutational load:</b>',(Math.round(mLoad*10)/10).toString(),'mutations',
            '</p>'].join(' '));
    }
    else {
        // plan method
        validator(['p_conc', 't_size', 'p_size','m_load', 'loss','m_rate']);
        var mLoad=parseFloat(data['m_load']);




    }
});

//input#planner_method.switch, input#planner_t_ng.form-control, input#planner_p_conc.form-control, input#planner_p_vol.form-control, input#planner_t_size.form-control, input#planner_p_size.form-control, input#planner_y_ng.form-control, input#planner_y_conc.form-control, input#planner_y_conc.form-control, input#planner_r_vol.form-control, input#planner_r_vol.form-control, input#planner_m_load.form-control, input#planner_m_rate.form-control, input#comment_name.form-control, prevObject: r.fn.init(1)]