$(function() {
  $('.ui.button.claim').popup({
    popup : $('.popup.claim'),
    on: 'click'
  });

  $('#claim_task').click(function() {
    $('#task_url_form').show();
    $('#task_success_form').hide();
  });

  $('#claim_task_btn').click(function() {
    // TODO заблокировать кнопку сохранения задачи, когда пустое имя задачи, если имя задано - разблокировать
    if (taskUrl() == '') {
      return;
    }

    let elem = $(this);
    elem.toggleClass('loading');

    $.ajax({
      method: "PUT",
      url: $('#lang').val() + '/users/claim_task',
      data: {
        task_url: taskUrl()
      },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: function (data) {
        $('#claimed_result').html(data['message']);

        $('#claimed_task_url').val('');

        $('#task_url_form').hide();
        $('#task_success_form').show();
      },
      complete: function() {
        elem.toggleClass('loading');
      }
    });
  });

  function taskUrl() {
    return $('#claimed_task_url').val();
  }
});
