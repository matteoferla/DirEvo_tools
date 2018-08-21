$(function() {
   // Snippet taken from: https://www.abeautifulsite.net/whipping-file-inputs-into-shape-with-bootstrap-3
  // We can attach the `fileselect` event to all file inputs on the page
  $(document).on('change', ':file', function() {
    var input = $(this),
        numFiles = input.get(0).files ? input.get(0).files.length : 1,
        label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.trigger('fileselect', [numFiles, label]);
  });

  // We can watch for our custom `fileselect` event like this
  $(document).ready( function() {
      $(':file').on('fileselect', function(event, numFiles, label) {

          var input = $(this).parents('.input-group').find(':text'),
              log = numFiles > 1 ? numFiles + ' files selected' : label;

          if( input.length ) {
              input.val(log);
          } else {
              if( log ) alert(log);
          }

      });
  });

  $('#land_calculate').click(function() {
        $("#land_results§").show();
        $("#land_results§").removeClass('hidden');
        $("#land_results_status").html('<div class="alert alert-info" role="alert">Calculating</div>');
        var data = new FormData();
        data.append("file", document.getElementById('land_upload').files);
        //data.append("your_study", $('input[name=your_study2]:checked').val());
        try {
            $.ajax({
                url: "/ajax_land",
                type: "POST",
                data: data,
                processData: false,
                cache: false,
                contentType: false,
                success: function(result) {
                    //reply = JSON.parse(result.message);
                    reply = result;
                    $("#land_results").html(reply['html']);
                    $("#land_results_status").html('');
                },
                error: function(xhr, s) {
                    $("#land_results").html(s);
                    $("#land_results_status").html('<div class="alert alert-danger" role="alert">Error — server side</div>');
                }
            });
        } catch (err) {
            $("#land_results").html(err);
            $("#land_results_status").html('<div class="alert alert-danger" role="alert">Error — client side</div>');
        }
    });

});