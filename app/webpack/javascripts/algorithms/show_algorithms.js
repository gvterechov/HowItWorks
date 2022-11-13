import { on_solve_step, paper_on_load } from './show_diagram'
import { getAttemptData } from '../application/attempt'

$(function() {
  // $('.ui.dropdown').dropdown();

  // Кнопка "возврат в редактор"
  $('#back_to_editor').click(function() {
    window.location.href = window.location.href.replace("/tasks/preview", '');
  });


  $('.ui.modal').modal({
    allowMultiple: false
  });
  // attach events to buttons
  $('.second.modal')
      .modal('attach events', '.first.modal .button');


  // enableNextCorrectStepBtn($('.alg_button').length > 0);
  enableNextCorrectStepBtn(true);
  let available_hints_count = parseInt($('#max_available_hints_count').val()) || 1000;


  function bindAlgorithmButtons() {
    $('.alg_button').click(algorithmClick);
  }

  function initPreviewMode() {
    // получить syntax и XML из localstorage
    // запросить check_expression с синтаксисом
    // получить данные по алгоритму
    // отрисовать его

    // move the button to be outside of replaceable div
    // $("#back_to_editor").before($("#algorithm_trainer"));
    let target = document.getElementById('algorithm_trainer').parentNode;
    target.prepend(document.getElementById('back_to_editor'));

    const task_syntax = localStorage.task_syntax || $('#default_syntax').val();
    const blockly_xml = localStorage.blockly_xml_backup || null;

    // update text of label & hidden field
    $('#syntax_label').html(task_syntax);
    $('#task_lang').val(task_syntax);

    if (!blockly_xml) {
      let algorithm_text_field = $('#algorithm_text_field');
      algorithm_text_field.addClass('negative');
      // TODO: add i18n
      algorithm_text_field.html("!<br>" + $('#empty_algorithm').val());
      return;
    }

    let lang = $('#lang').val();
    const check_data = { algorithm_text: blockly_xml, task_lang: task_syntax, user_language: lang }


    $.ajax({
      method: "GET",
      url: '/algorithms/check_expression',
      data: { data: JSON.stringify(check_data) },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error: making task');
      },
      success: function (data) {
        data = JSON.parse(data);
        const algorithm_text_field = $('#algorithm_text_field');
        algorithm_text_field.removeClass('negative');
        if (data['errors_html'].length > 0) {
          algorithm_text_field.addClass('negative');
          algorithm_text_field.html("!<br>" + data['errors_html']);
        } else {
          $('#algorithm_json').val(JSON.stringify(data['algorithm_json']));
          algorithm_text_field.html(data['algorithm_as_html']);
          bindAlgorithmButtons();
          // run custom init code
          if (paper_on_load)
            paper_on_load()
        }
      // },
      // complete: function() {
      //   // elem.toggleClass('loading');
      }
    });
  }


  if ($('#preview_mode').val() == "true") {
    initPreviewMode();
  } else {
    bindAlgorithmButtons();
  }

  function prepareData(elem) {
    let lang = $('#lang').val();
    let algorithm_json = JSON.parse($('#algorithm_json').val());
    let algorithm_element_id = parseInt(elem.attr('algorithm_element_id'));
    let act_type = elem.attr('act_type'); // SOLVED: algorithm_button_tips уже не актуален
    let existing_trace_json = JSON.parse($('#existing_trace_json').val()); // SOLVED: список всех актов, т.к. фильтрация по is_valid == true производится на стороне c_owl.

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

      data: {
        data: JSON.stringify(prepareData($(this))),
        task_lang: $('#task_lang').val(),
        attempt_id: $('#attempt_id').val(),
        student_name: localStorage.student_name
      },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error: verify_trace_act');
      },
      success: function (data) {
        updateAlgorithmTrainer(data);
      }//,
      // complete: function() {
        // TODO разблокировать нажатие на элементы алгоритма
      // }
    });
  }

  function updateAlgorithmTrainer(data) {
    // TODO после ответа от сервера обновлять следующие элементы: json трассы

    // Обновить алгоритм и трассу
    $('#algorithm_trainer').html(data);

    // Показать модальное окно об успешном завершении задачи
    // (если в full_trace_json есть акт, у которого is_final true)
    if ($('#is_final').length > 0) {
      enableNextCorrectStepBtn(false);
      getAttemptData();
      $('.ui.modal.success').modal('show');

      // Задача решена - убрать все кнопки из algorithm_text_field
      $('.alg_button').remove();
      if (on_solve_step) {
        on_solve_step(true);
      }

    } else {

      $('#show_next_correct_step').show();
      enableNextCorrectStepBtn(available_hints_count != 0);

      bindAlgorithmButtons();
      if (on_solve_step) {
        on_solve_step(false);
      }
    }
  }


  $('#show_next_correct_step').click(nextCorrectStepClick);

  function enableNextCorrectStepBtn(enabled = true) {
    $('#show_next_correct_step').attr("disabled", !enabled);
  }

  function nextCorrectStepClick() {
    --available_hints_count;
    if (available_hints_count >= 0) { // && $('#available_hints_count').length > 0) {
      $('#available_hints_count').text(available_hints_count);
    }
    // updateExpressionTrainer($(this), 1000, 'next_step'); TODO
    hintNextStep();
  }

  function hintNextStep() {
    $.ajax({
      method: "POST",
      url: '/' + $('#lang').val() + '/algorithms/hint_next_step',
      data: {
        data: JSON.stringify(prepareData($(this))),
        task_lang: $('#task_lang').val(),
        attempt_id: $('#attempt_id').val(),
        student_name: localStorage.student_name
      },
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error: hint_next_step');
      },
      success: function (data) {
        updateAlgorithmTrainer(data);
      }//,
      // complete: function() {
      // TODO разблокировать нажатие на элементы алгоритма
      // }
    });
  }
});
