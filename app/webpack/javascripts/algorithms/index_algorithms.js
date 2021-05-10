import { workspace } from './init_blockly'

$(function() {
  $('.ui.dropdown.task_lang').toggleClass('loading');
  $.ajax({
    method: "GET",
    url: '/algorithms/available_syntaxes',
    dataType: "json",
    error: function (jqXHR) {
      // TODO показать сообщение об ошибке
      alert('error: available_syntaxes');
    },
    success: function (data) {
      // data = JSON.parse(data);
      $('.ui.dropdown.task_lang').dropdown({
        values: data['available_syntaxes']
      });
    },
    complete: function() {
      $('.ui.dropdown.task_lang').toggleClass('loading');
    }
  });

  $('.ui.button.share').popup({
    popup : $('.popup.share'),
    on: 'click'
  });

  $('.ui.modal').modal({
    blurring: true
  });

  // Кнопка "запустить"
  $('#prepare').click(function() {
    let elem = $(this);
    elem.toggleClass('loading');

    $.ajax({
      method: "GET",
      // url: '/check_expression.json',
      url: '/algorithms/check_expression',
      data: { data: JSON.stringify(prepareExpression()) },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error: get trace');
      },
      success: function (data) {
        data = JSON.parse(data);
        $('#trace').html(data['trace_html']);

        $('#algorithm_form').removeClass('error');
        if (data['errors_html'].length > 0) {
          $('#algorithm_form').addClass('error');
          $('#errors').html(data['errors_html']);
        }
      },
      complete: function() {
        elem.toggleClass('loading');
      }
    });
  });

  // Кнокпка "запустить" по нажатию на Enter
  $(document).keyup(function(event) {
    if (event.keyCode == 13) {
      $('#prepare').click();
    }
  });

  // Сохранение выражения
  $('#create_task').click(function() {
    let elem = $(this);
    elem.toggleClass('loading');

    $.ajax({
      method: "POST",
      url: '/algorithms/create_task',
      data: { task: { data: JSON.stringify(prepareExpression()) } },
      // data: { data: JSON.stringify(prepareExpression()) },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error: create_task');
      },
      success: function (data) {
        $("#task_url").val(window.location.href + data['task_path']);
      },
      complete: function() {
        elem.toggleClass('loading');
      }
    });
  });

  function prepareExpression() {
    let lang = $('#lang').val();
    let task_lang = taskLang();
    let tokens_json = expressionTokens();

    // return { algorithm_text: tokens_json, syntax: task_lang, user_language: lang }
    return { algorithm_text: tokens_json, task_lang: task_lang, user_language: lang }
  }

  function taskLang() {
    if ($('.ui.dropdown.task_lang').length > 0) {
      return $('.ui.dropdown.task_lang').dropdown('get value');
    }
    return $('#task_lang').val();
  }

  function expressionTokens() {
    let xml = Blockly.Xml.workspaceToDom(workspace);
    return Blockly.Xml.domToPrettyText(xml);
  }
});
