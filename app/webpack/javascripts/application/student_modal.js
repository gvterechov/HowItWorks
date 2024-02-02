import { getCookie } from './teacher'

export class StudentModal {
  constructor() {
    this.$student_modal = $('.ui.modal.student');
    this.$attempt_id = $('#attempt_id');

    if (this.$student_modal.length === 0)
      return;

    this.$student_name = $('#student_name');
    this.$task_type = $('#task_type');
    this.$task_token = $('#task_token');

    if (this.getStudentName() == '') {
      this.showModal();

      // Создаем попытку, когда студент ввел имя
      let original_context = this;
      $('#student_modal_submit_btn').click(function () {
        let student_name = original_context.$student_name.val();
        if(student_name != '') {
          // запомнить (на 1 год) введенное имя студента
          document.cookie = `tmp_student_name=${student_name}; max-age=31536000`;

          original_context.createAttempt($(this));
        }
      });
    } else {
      this.createAttempt();
    }
  }

  showModal() {
    this.$student_modal.modal('setting', 'closable', false);
    this.$student_modal.modal('show');
  }

  createAttempt(elem = null) {
    if (elem != null) {
      elem.toggleClass('loading');
    }

    $.ajax({
      method: "POST",
      url: '/attempts.json',
      data: {
        attempt: {
          student_name: this.getStudentName(),
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
        if (elem != null) {
          elem.toggleClass('loading');
        }
      }
    });
  }

  getAttemptId() {
    return this.$attempt_id.val();
  }

  getStudentName() {
    return this.$student_name.val() || getCookie('tmp_student_name') || '';
  }
}
