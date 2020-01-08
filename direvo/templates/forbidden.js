$('#password_send').click(function(){
    $.post("/admin", { password: $('#password').val()}).done(function() {
    location.reload(true);
  });
});