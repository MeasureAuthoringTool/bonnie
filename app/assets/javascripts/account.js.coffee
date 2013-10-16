submitKeyPress = (e) ->
  if(window.event)
    keynum = e.keyCode
  else if(e.which)
    keynum = e.which
  else return true

  if (keynum == 13)
    document.login_form.submit();
    return false;
  else
    return true;

submitLoginform = ->
  document.login_form.submit();

submitRegisterform = ->
  document.register_form.submit();

submitResetPasswordinform = ->
  document.forgot_password_form.submit();

submitAccountForm = ->
  document.account_form.submit();
