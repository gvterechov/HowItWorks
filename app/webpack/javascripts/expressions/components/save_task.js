import { showTeacherModal } from "../../application/teacher";

export class SaveExpressionTask {
  constructor(expression, available_syntaxes) {
    this.available_syntaxes = available_syntaxes;
    this.expression = expression;

    this.$task_name = $('#task_name');
    this.$collect_statistics = $('#collect_statistics');
    this.$enable_hints = $('#enable_hints');
    this.$max_hints_count = $('#max_hints_count');

    this.$enable_hints.click(function() {
      this.$max_hints_count.toggle(this.enableHints());
    });
  }

  save() {
    // TODO заблокировать кнопку сохранения задачи, когда пустое имя задачи, если имя задано - разблокировать
    if (this.taskName() == '') {
      return;
    }

    let elem = $(this);
    elem.toggleClass('loading');

    $.ajax({
      method: "POST",
      url: '/expressions/create_task',
      data: {
        task: {
          expression: JSON.stringify(this.expression.tokens()),
          task_lang: this.available_syntaxes.taskLang(),
          title: this.taskName(),
          introduce_yourself: this.collectStatistics(),
          enable_hints: this.enableHints(),
          max_hints_count: this.maxHintsCount()
        }
      },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: function (data) {
        let $task_url = $('#task_url');
        $task_url.val(window.location.href + data['task_path']);
        $task_url.select();
        $task_url.parent().toggleClass('focus');

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
  }

  taskName() {
    return this.$task_name.val();
  }

  collectStatistics() {
    return this.$collect_statistics.prop('checked');
  }

  enableHints() {
    return this.$enable_hints.prop('checked');
  }

  maxHintsCount() {
    return this.enableHints() ? this.$max_hints_count.val() : 0;
  }
}
