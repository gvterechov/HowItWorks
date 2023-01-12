export class StudentModal {
  constructor() {
    this.$student_modal = $('.ui.modal.student');
    this.$attempt_id = $('#attempt_id');

    if (this.$student_modal.length === 0)
      return;

    this.$student_name = $('#student_name');
    this.$task_type = $('#task_type');
    this.$task_token = $('#task_token');

    this.showModal();
    // Создаем попытку, когда студент ввел имя
    let original_context = this;
    $('#student_modal_submit_btn').click(function () {
      original_context.createAttempt($(this))
    });
  }

  showModal() {
    this.$student_modal.modal('setting', 'closable', false);
    this.$student_modal.modal('show');
  }

  createAttempt(elem) {
    elem.toggleClass('loading');

    $.ajax({
      method: "POST",
      url: '/attempts.json',
      data: {
        attempt: {
          student_name: this.$student_name.val(),
          task_type: this.$task_type.val(),
          task_token: this.$task_token.val()
        }
      },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: (data) => {
        this.$attempt_id.val(data['id']);
        this.$student_modal.modal('hide');
      },
      complete: function() {
        // TODO разблокировать нажатие на элементы алгоритма
        elem.toggleClass('loading');
      }
    });
  }

  getAttemptId() {
    return this.$attempt_id.val();
  }
}
