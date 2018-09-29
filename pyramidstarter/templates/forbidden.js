$('#password_send').click(function(){
$.post("/admin", { password: $('#password').val()} );
location.reload();
});