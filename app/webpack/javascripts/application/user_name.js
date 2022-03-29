$(function() {
  let $user_name_popup = $('.ui.button.user_name');
  let $new_user_name = $('#new_user_name');
  $user_name_popup.popup({
    popup : $('.popup.user_name'),
    on: 'click'
  });

  $('#user_name').click(function() {
    $new_user_name.val(localStorage.student_name);
    $('#user_name_form').show();
  });

  $('#change_user_name_btn').click(function() {
    if ($new_user_name.val() == '') {
      return;
    }

    localStorage.student_name = $new_user_name.val();
    $('#user_name').text(localStorage.student_name);
    $user_name_popup.popup('hide');
  });
});
