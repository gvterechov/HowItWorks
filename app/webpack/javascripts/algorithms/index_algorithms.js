import { workspace } from './init_blockly'
import { showTeacherModal } from '../application/teacher'

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
      // set value as choosen before
      if (localStorage.task_syntax) {
        $('.ui.dropdown.task_lang').dropdown('set selected', localStorage.task_syntax);
      }
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

  // Кнопка "запустить" по нажатию на Enter
  $(document).keyup(function(event) {
    if (event.keyCode == 13) {
      $('#prepare').click();
    }
  });

  // Кнопка "Предпросмотр"
  $('#preview').click(function() {
    // Save syntax to be accessible from preview page
    const task_syntax = taskLang();
    localStorage.task_syntax = task_syntax;

    window.location.href = (window.location.href.replace(/\/$/, "") + "/tasks/preview");
  });

  // Галочка "Включить активити-диаграмму"
  let is_beta = window.location.href.includes('beta');
  let enable_diagram_check = $('#enable_diagram_check');
  enable_diagram_check.checkbox(is_beta? 'set checked' : 'set unchecked');
  enable_diagram_check.checkbox("set enabled");
  enable_diagram_check.checkbox({
      onChecked: function() {
        window.location.href = window.location.href.replace("/algorithms", "/algorithms/beta");
      },
      onUnchecked: function() {
        window.location.href = window.location.href.replace("/algorithms/beta", "/algorithms");
      }
  });

  $('#save_task').click(function() {
    $('#task_info_form').show();
    $('#task_url_form').hide();
  });

  $('#copy_task_url').click(function() {
    navigator.clipboard.writeText($("#task_url").val());
  });

  // Сохранение выражения
  $('#create_task').click(function() {
    // TODO заблокировать кнопку сохранения задачи, когда пустое имя задачи, если имя задано - разблокировать
    if (taskName() == '') {
      return;
    }

    let elem = $(this);
    elem.toggleClass('loading');

    $.ajax({
      method: "POST",
      url: '/algorithms/create_task',
      data: {
        task: {
          data: JSON.stringify(prepareExpression()),
          title: taskName(),
          introduce_yourself: collectStatistics()
        }
      },
      // data: { data: JSON.stringify(prepareExpression()) },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error: create_task');
      },
      success: function (data) {
        let task_url = $("#task_url");
        task_url.val(window.location.href + data['task_path']);
        task_url.select();
        task_url.parent().toggleClass('focus');

        $('#saved_task_name').html(data['task_title']);

        $('#task_info_form').hide();
        showTeacherModal();
        $('#task_url_form').show();
        $('#copy_task_url').popup({
          on: 'click'
        });
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

  function taskName() {
    return $('#task_name').val();
  }

  function collectStatistics() {
    return $('#collect_statistics').prop('checked');
  }

  function expressionTokens() {
    let xml = Blockly.Xml.workspaceToDom(workspace);
    return Blockly.Xml.domToPrettyText(xml);
  }
});
