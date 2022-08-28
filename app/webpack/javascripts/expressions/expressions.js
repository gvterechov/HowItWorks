import { getAttemptData } from '../application/attempt'
import { showTeacherModal } from '../application/teacher'

$(function() {
  $('.ui.dropdown.task_lang').toggleClass('loading');

  loadAvailableSyntaxes();

  enableNextCorrectStepBtn($('.operator').length > 0);
  let available_hints_count = parseInt($('#max_available_hints_count').val()) || 1000;

  $('.ui.button.share').popup({
    popup : $('.popup.share'),
    on: 'click'
  });

  $('.ui.modal').modal({
    blurring: true
  });

  // setTimeout(function() {
  //   $('.ui.modal.teacher').modal('show');
  // }, 1000);

  $('.operator').click(operatorClick);
  $('#show_next_correct_step').click(nextCorrectStepClick);

  // Кнокпка "запустить"
  $('#prepare').click(function() {
    updateExpressionTrainer($(this));
  });

  // Кнокпка "запустить" по нажатию на Enter
  $(document).keyup(function(event) {
    if (event.keyCode == 13) {
      $('#prepare').click();
    }
  });

  $('#enable_hints').click(function() {
    $('#max_hints_count').toggle(enableHints());
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
      url: '/expressions/create_task',
      data: {
        task: {
          expression: JSON.stringify(expressionTokens()),
          task_lang: taskLang(),
          title: taskName(),
          introduce_yourself: collectStatistics(),
          enable_hints: enableHints(),
          max_hints_count: maxHintsCount()
        }
      },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
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

  // TODO сохранение данных анкеты преподавателя


  // Обновление тренажера (виджета с кнопками для выражения)
  function updateExpressionTrainer(elem, index = null, action = 'find_errors') {
    // TODO блокировать нажатие на элементы выражения пока не пришел ответ от сервера
    elem.toggleClass('loading');

    $.ajax({
      method: "GET",
      // url: '/check_expression.json',
      url: '/expressions/check_expression',
      data: {
        data: JSON.stringify(prepareExpression(index, action)),
        attempt_id: $('#attempt_id').val(),
        student_name: localStorage.student_name
      },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: function (data) {
        // alert('success');
        $('#expression_trainer').html(data);

        $('#error_learn_more_btn').click(function() {
          learnMoreClick($(this));
        });

        $('#error_understand_btn').click(function() {
          $('#error_messages').hide(400);
        });

        $('#show_next_correct_step').show();

        enableNextCorrectStepBtn(available_hints_count != 0);

        $('.operator').click(operatorClick);
        // Если все кнопки отключены, то задача успешно решена
        if ($('.operator').length == $('.operator.disabled').length) {
          enableNextCorrectStepBtn(false);
          getAttemptData();
          $('.ui.modal.success').modal('show');
        }
      },
      complete: function() {
        // TODO разблокировать нажатие на элементы алгоритма
        elem.toggleClass('loading');
      }
    });
  }

  // Возвращает выражение в ввиде json
  function prepareExpression(selected_index = null, action = 'find_errors', error_type = null) {
    let lang = $('#lang').val();
    let task_lang = taskLang();
    let tokens_json = expressionTokens(selected_index);

    let result = { expression: tokens_json, task_lang: task_lang, lang: lang, action: action };

    if (error_type != null) {
      result['errors'] = [{ "parts": [], "type": error_type }]
    }

    return result;
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

  function enableHints() {
    return $('#enable_hints').prop('checked');
  }

  function maxHintsCount() {
    return enableHints() ? $('#max_hints_count').val() : 0;
  }

  function expressionTokens(selected_index = null) {
    let expr_str = $('#expression').val();
    let expr_tokens = expr_str.split(' ');

    let buttons = $('.operator').toArray();

    // let selected_operators = $('.operator.green[data-index]').map(function() {
    //   return parseInt($(this).attr('data-index'));
    // }).toArray();
    let tokens_json = expr_tokens.map(function(currentValue, index) {
      let result = { "text": currentValue };
      // Если был выбран оператор с заданным индексом
      // или оператор уже был выбран корректно ранее
      // if ((selected_index != null && index == selected_index)
      //     || (selected_operators.includes(index))) {
      //   result["check_order"] = index;
      // }

      if (selected_index != null) {
        let $button = $(buttons[index]);
        // Либо кнопка уже имеет порядок
        if ($button != undefined && $button.hasClass('green') && $button.data('order') != undefined) {
          result["check_order"] = $button.data('order');
          // Либо кнопка была нажата последней и мы устанавливаем ей порядок
        } else if (index == selected_index) {
          result["check_order"] = $('.operator.green[data-order]').length + 1;
        }
      }

      return result;
    });

    return tokens_json;
  }

  // Нажатие на кнокпку оператора выражения
  function operatorClick() {
    let index = $(this).data('index');
    updateExpressionTrainer($(this), index, 'find_errors');
  }

  // Нажатие на кнопку отображения следующего успешного шага
  function nextCorrectStepClick() {
    --available_hints_count;
    if (available_hints_count >= 0) { // && $('#available_hints_count').length > 0) {
      $('#available_hints_count').text(available_hints_count);
    }
    updateExpressionTrainer($(this), 1000, 'next_step');
  }

  function enableNextCorrectStepBtn(enabled = true) {
    $('#show_next_correct_step').attr("disabled", !enabled);
  }

  function learnMoreClick(elem) {
    elem.toggleClass('loading');

    let error_index = errorOperatorIndex();
    $.ajax({
      method: "GET",
      url: '/expressions/learn_more',
      data: {
        data: JSON.stringify(prepareExpression(error_index, 'find_errors')),
      },
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: function (data) {
        $('#error_buttons').hide();

        updateLearnMoreQuiz(data);
      },
      complete: function () {
        // TODO разблокировать нажатие на элементы алгоритма
        elem.toggleClass('loading');
      }
    });
  }

  function learnMoreSubmitClick() {
    $('#learn_more_question').addClass('loading');

    // $('#learn_more_error_message').hide();

    let error_index = errorOperatorIndex();
    let type = quizSelectAnswerAdditionalInfo();
    $.ajax({
      method: "GET",
      url: '/expressions/learn_more_next',
      data: {
        data: JSON.stringify(prepareExpression(error_index, 'get_supplement', type)),
      },
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: function (data) {
        updateLearnMoreQuiz(data);
      },
      complete: function () {
        // TODO разблокировать нажатие на элементы алгоритма

        $('#learn_more_question').removeClass('loading');
      }
    });
  }

  // Интекс опратора, который был ошибочно выбран
  function errorOperatorIndex() {
    return $('.operator.red').data('index');
  }

  // Выбранный студентом ответ в анкете
  function quizSelectAnswer() {
    return $('.answer.checked');
  }

  // Информация о выбранном студентом ответе в анкете
  function quizSelectAnswerAdditionalInfo() {
    return quizSelectAnswer().data('additional-info');
  }

  // Статус выбранного студентом ответа в анкете (правильный ответ или нет)
  function quizSelectAnswerStatus() {
    return quizSelectAnswer().data('status');
  }

  function updateLearnMoreQuiz(data) {
    $('#learn_more_quiz').html(data);

    $('#learn_more_question').show();
    $('.ui.radio.checkbox').checkbox();

    $('.answer').click(function() {
      $(this).find(">:first-child").show();
      setTimeout(learnMoreSubmitClick, 1000);
    });
  }

  function loadAvailableSyntaxes() {
    $.ajax({
      method: "GET",
      url: '/expressions/available_syntaxes',
      dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error: available_syntaxes');
      },
      success: function (data) {
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
  }
});
