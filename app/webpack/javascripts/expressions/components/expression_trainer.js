import { Attempt } from "../../application/attempt";
import { NextCorrectStep } from "./next_correct_step";

export class ExpressionTrainer {
  constructor(expression, chat) {
    this.chat = chat;
    this.expression = expression;

    this.next_correct_step_btn = new NextCorrectStep(chat, this);
    this.next_correct_step_btn.enable($('.operator').length > 0);

    this.attempt = new Attempt();

    this.$expression_trainer = $('#expression_trainer');

    this.setOperatorClick();
  }

  // Обновление тренажера (виджета с кнопками для выражения)
  update(elem, index = null, action = 'find_errors') {
    // TODO блокировать нажатие на элементы выражения пока не пришел ответ от сервера
    elem.toggleClass('loading');

    let original_context = this;

    $.ajax({
      method: "GET",
      url: '/expressions/check_expression',
      data: {
        data: JSON.stringify(this.expression.prepare(index, action)),
        attempt_id: this.attempt.getId(),
        student_name: localStorage.student_name
      },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: function (data) {
        original_context.$expression_trainer.html(data);

        original_context.next_correct_step_btn.show();
        original_context.next_correct_step_btn.updateEnabled();

        original_context.setOperatorClick();
        // Если все кнопки отключены, то задача успешно решена
        if (original_context.expressionSolved()) {
          original_context.next_correct_step_btn.enable(false);
          original_context.attempt.fetchData();
          $('.ui.modal.success').modal('show');
        }
        // Если есть кнопка с красным лейблом, то была совершена ошибка
        if (original_context.hasError()) {
          // TODO заблокировать выражение
          let error_operators = $('.error-operator');
          error_operators.mouseenter(function () { original_context.highlightOperator($(this)) });
          error_operators.mouseleave(function () { original_context.removeHighlightOperator($(this)); } );

          original_context.chat.collapse();
        }
      },
      complete: function() {
        // TODO разблокировать нажатие на элементы алгоритма
        elem.toggleClass('loading');
      }
    });
  }

  expressionSolved() {
    return $('.operator').length == $('.operator.disabled').length;
  }

  setOperatorClick() {
    let original_context = this;
    $('.operator').click(function() {
      original_context.operatorClick($(this));
    });
  }

  // Нажатие на кнокпку оператора выражения
  operatorClick(elem) {
    this.chat.renew();

    let index = elem.data('index');
    this.update(elem, index, 'find_errors');
  }

  // Интекс опратора, который был ошибочно выбран
  errorOperatorIndex() {
    return $('.operator.red').data('index');
  }

  hasError() {
    let error_index = this.errorOperatorIndex();
    return error_index !== null && error_index !== undefined;
  }

  operatorByIndex(index) {
    return $(`.operator[data-index=${index}]`)
  }

  highlightOperator(elem) {
    this.operatorByIndex(elem.data('index') - 1).addClass('basic violet');
  }

  removeHighlightOperator(elem) {
    this.operatorByIndex(elem.data('index') - 1).removeClass('basic violet');
  }
}
