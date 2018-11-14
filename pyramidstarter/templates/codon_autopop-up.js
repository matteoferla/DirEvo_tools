$(document).ready( function() {
    //$('#scheme_modal').modal('show');
    var codon=$('#scheme_modal .modal-body').detach();
    codon.removeClass('.modal-body');
    //$('#scheme_modal').modal('hide');
    $('.card-body').append(codon);
});