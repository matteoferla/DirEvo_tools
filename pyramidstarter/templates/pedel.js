$('#pedel_method').on('switchChange.bootstrapSwitch', function(event, state) {
    $('#pedelbasic').toggle(!state);
    $('#pedelAA').toggle(state);
});
$('#pedelAA').toggle(false);

<%include file="pedel-classic.js" args="page=page"/>
<%include file="pedelAA.js" args="page=page"/>
