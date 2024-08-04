import { AvailableSyntaxes } from './components/available_syntaxes'
import { SaveExpressionTask } from './components/save_task'
import { Chat } from './components/chat'
import { ExpressionTrainer } from "./components/expression_trainer";
import { Expression } from "./components/expression";

$(function() {
  let available_syntaxes = new AvailableSyntaxes();
  available_syntaxes.load();

  let expression = new Expression(available_syntaxes);

  let chat = new Chat(expression);
  let expression_trainer = new ExpressionTrainer(expression, chat);

  let save_expression_task = new SaveExpressionTask(expression, available_syntaxes);
  $('#create_task').on('click', () => save_expression_task.save());

  $('.ui.button.share').popup({
    popup: $('.popup.share'),
    on: 'click'
  });

  $('.ui.modal').modal({
    blurring: true
  });

  // setTimeout(function() {
  //   $('.ui.modal.teacher').modal('show');
  // }, 1000);

  $('#expression').on('input', function () {
    $('#prepare').prop('disabled', $(this).val().length === 0);
  });

  // Кнокпка "запустить"
  $('#prepare').on('click', function() {
    chat.renew();
    expression_trainer.update($(this));
  });

  // Кнокпка "запустить" по нажатию на Enter
  $(document).on('keyup', function(event) {
    if (event.key === "Enter") {
      $('#prepare').trigger('click');
    }
  });

  $('#save_task').on('click', function() {
    $('#task_info_form').show();
    $('#task_url_form').hide();
  });

  $('#copy_task_url').on('click', function() {
    navigator.clipboard.writeText($("#task_url").val());
  });

  // TODO сохранение данных анкеты преподавателя
});
