$(function() {
  // $('.ui.dropdown').dropdown();

  $('.ui.modal').modal({
    allowMultiple: false
  });
  // attach events to buttons
  $('.second.modal')
      .modal('attach events', '.first.modal .button');

  function bindAlgorithmButtons(argument) {
    $('.alg_button').click(algorithmClick);
  }
  bindAlgorithmButtons();

  function prepareData(elem) {
    let lang = $('#lang').val();
    let algorithm_json = JSON.parse($('#algorithm_json').val());
    let algorithm_element_id = parseInt(elem.attr('algorithm_element_id'));
    let act_type = elem.attr('act_type');
    let existing_trace_json = JSON.parse($('#existing_trace_json').val());

    return {
      user_language: lang,
      algorithm_json: algorithm_json,
      algorithm_element_id: algorithm_element_id,
      act_type: act_type,
      existing_trace_json: existing_trace_json,
    }
  }

  function algorithmClick() {
    // TODO блокировать нажатие на элементы алгоритма пока не пришел ответ от сервера

    // заменим кнопки на часики: hourglass half
    $('#algorithm_text_field .icon').removeClass("alg_button tooltip play stop").addClass("hourglass half");

    $.ajax({
      method: "POST",
      // url: '/algorithms/' + $('#lang').val() + '/verify_trace_act',
      // url: '/algorithms/verify_trace_act',
      url: '/' + $('#lang').val() + '/algorithms/verify_trace_act',
      data: { data: JSON.stringify(prepareData($(this))), task_lang: $('#task_lang').val() },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error: verify_trace_act');
      },
      success: function (data) {
        // alert('success');
        // TODO после ответа от сервера обновлять следующие элементы: json трассы

        // Обновить алгоритм и трассу
        $('#algorithm_trainer').html(data);

        // Показать модальное окно об успешном завершении задачи
        // (если в full_trace_json есть акт, у которого is_final true)
        if ($('#is_final').length > 0) {
          $('.ui.modal.success').modal('show');

          // Задача решена - убрать все кнопки из algorithm_text_field
          $('.alg_button').remove();
          on_solve_step(true);

        } else {
          bindAlgorithmButtons();
          on_solve_step(false);
        }

      }//,
      // complete: function() {
      // TODO разблокировать нажатие на элементы алгоритма
      // }
    });
  }
});
