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

  $('#expression').on('input', function () {
    $('#prepare').prop('disabled', $(this).val().length === 0);
  });

  // Кнокпка "запустить"
  $('#prepare').click(function() {
    renewChat();
    updateExpressionTrainer($(this));
  });

  // Кнокпка "запустить" по нажатию на Enter
  $(document).keyup(function(event) {
    if (event.key === "Enter") {
      $('#prepare').click();
    }

    if (event.key === "Escape") {
      collapseChat();
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
        $('#expression_trainer').html(data);

        $('#show_next_correct_step').show();
        enableNextCorrectStepBtn(available_hints_count != 0);

        $('.operator').click(operatorClick);
        // Если все кнопки отключены, то задача успешно решена
        if ($('.operator').length == $('.operator.disabled').length) {
          enableNextCorrectStepBtn(false);
          getAttemptData();
          $('.ui.modal.success').modal('show');
        }
        // Если есть кнопка с красным лейблом, то была совершена ошибка
        let error_index = errorOperatorIndex();
        if (error_index !== null && error_index !== undefined) {
          // TODO заблокировать выражение
          $('.error-operator').mouseenter(highlightOperator);
          $('.error-operator').mouseleave(removeHighlightOperator);

          collapseChat();
          loadChatQuestion();
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
    renewChat();

    let index = $(this).data('index');
    updateExpressionTrainer($(this), index, 'find_errors');
  }

  // Нажатие на кнопку отображения следующего успешного шага
  function nextCorrectStepClick() {
    renewChat();

    --available_hints_count;
    if (available_hints_count >= 0) { // && $('#available_hints_count').length > 0) {
      $('#available_hints_count').text(available_hints_count);
    }
    updateExpressionTrainer($(this), 1000, 'next_step');
  }

  function enableNextCorrectStepBtn(enabled = true) {
    $('#show_next_correct_step').attr("disabled", !enabled);
  }

  // Интекс опратора, который был ошибочно выбран
  function errorOperatorIndex() {
    return $('.operator.red').data('index');
  }

  function operatorByIndex(index) {
    return $(`.operator[data-index=${index}]`)
  }

  function highlightOperator() {
    operatorByIndex($(this).data('index') - 1).addClass('basic violet');
  }

  function removeHighlightOperator() {
    operatorByIndex($(this).data('index') - 1).removeClass('basic violet');
  }


  // --- Чат с подсказками
  $('#chat_understand_btn').click(function () {
    chatUnderstandClick($(this));
  });

  $('#chat_btn').click(function () {
    chatBtnClick($(this));
  });

  $('#chat_close_btn').click(function () {
    // Показываем дополнительный вопрос студенту,
    // если он хочет закрыть чат, в котором еще есть активный диалог
    // (есть кнопки с ответами)
    if ($('button[data-additional-info]').length > 0) {
      hideChat(); // TODO баг - чат прыгает, теперь хотя бы скрываем
      $('#chat_close_alert').modal('show');
    } else {
      collapseChat();
    }
  });

  $('#chat_close_yes').click(function () {
    collapseChat();
    clearChatAnswers();
  });

  $('#chat_close_no').click(openChat);

  function loadChatQuestion() {
    let error_index = errorOperatorIndex();
    $.ajax({
      method: "GET",
      url: '/expressions/get_supplement',
      data: {
        data: JSON.stringify(prepareExpression(error_index, 'find_errors')),
      },
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: function (data) {
        updateChat(data);
      },
      complete: function () {
        // TODO разблокировать нажатие на элементы алгоритма
      }
    });
  }

  function loadNextChatQuestion() {
    let $elem = $(this);
    // Добавляем выбранный студентом ответ в чат
    addChatText($elem.text(), 'right');

    let error_index = errorOperatorIndex();
    let type = $(this).data('additional-info');
    $.ajax({
      method: "GET",
      url: '/expressions/get_next_supplement',
      data: {
        data: JSON.stringify(prepareExpression(error_index, 'get_supplement', type)),
      },
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: function (data) {
        if (data['answers'].length > 0) {
          // Добавляем в чат, правильно ли ответил студент
          addStudentAnswerReaction($elem);
        }

        updateChat(data);
      },
      complete: function () {
        // TODO разблокировать нажатие на элементы алгоритма
      }
    });
  }

  function updateChat(data) {
    // Добавляем вопрос в нужное место
    addChatText(data['text'], 'left');

    clearChatAnswers();
    // Добавляем кнопки с ответами
    if (data['answers'].length > 0) {
      $('#chat_answers_block').show();
      data['answers'].forEach(function(answer) {
        addChatAnswer(answer);
      });
    } else {
      $('#chat_answers_block').hide();
    }
  }

  // Скроллим чат до последнего сообщения
  function scrollCharDown() {
    let $chat_content = $('#chat_content');
    $chat_content.scrollTop($chat_content.prop("scrollHeight"));
  }

  // Оценивает ответ студентв в словестной форме,
  // одним из вариантов слов "верно" или "неверно"
  function rateStudentChatAnswer(elem) {
    let answers_selector = elem.data('status') === 'correct' ? '#chat_correct' : '#chat_incorrect';
    let answers = $(answers_selector).val().split(', ');
    return answers[Math.floor(Math.random() * answers.length)];
  }

  // Добавить фразу в чат
  function addChatText(text, direction) {
    let $message = $(`#${direction}_event`).clone();
    $message.removeAttr('id');
    $(`#${direction}_event_text`, $message).text(text);
    $(`#${direction}_event_text`, $message).removeAttr('id');
    $('#chat_feed').append($message);
    $message.show();

    scrollCharDown();

    return $message;
  }

  // Добавить в чат слева реакцию на ответ студент
  // (корректный или некорректный у студента был ответ)
  function addStudentAnswerReaction(elem) {
    let rate_answer = rateStudentChatAnswer(elem);
    return addChatText(rate_answer, 'left');
  }

  // Добавить вариант ответа в чат
  // options
  //  text - текст варианта ответа
  //  enabled - доступен ли для выбора вариант ответа
  //  status - правильный или нет ответ
  //  additional_info - доп. инфо
  function addChatAnswer(options) {
    let $answer = $('#answer').clone();
    $answer.text(options['text']);
    if (options['enabled'] === false) {
      $answer.addClass('disabled');
    }
    $answer.attr('data-status', options['status']);
    $answer.attr('data-additional-info', options['additional_info']);
    $answer.removeAttr('id');
    $('#chat_answers').append($answer);
    $answer.click(loadNextChatQuestion);
    $answer.show();
    return $answer;
  }

  // Очистить чат
  function clearChat() {
    $('#chat_feed').empty();
    clearChatAnswers();
  }

  // Очистить предоставленные студенту ответы
  function clearChatAnswers() {
    $('#chat_answers').empty();
  }

  // Свернуть чат
  function collapseChat() {
    $('#chat').hide();
    $('#chat_btn').show();
  }

  // Развернуть чат
  function openChat() {
    $('#chat').show();
    $('#chat_btn').hide();
  }

  // Скрыть чат вместе с миниатюрой
  function hideChat() {
    $('#chat').hide();
    $('#chat_btn').hide();
  }

  // Пересоздать чат, чтобы он был как новый
  function renewChat() {
    hideChat();
    clearChat();
  }

  function chatUnderstandClick(elem) {
    elem.toggleClass('loading');
    // Добавить ответ студента в чат
    addChatText(elem.text(), 'right');
    collapseChat();

    // TODO разблокировать выражение
    elem.toggleClass('loading');
  }

  function chatBtnClick(elem) {
    elem.toggleClass('loading');
    // TODO заблокировать выражение
    openChat();
    elem.toggleClass('loading');
  }
  // ---/Чат с подсказками


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
