export class AvailableSyntaxes {
  constructor() {
    this.$dropdown_task_lang = $('.ui.dropdown.task_lang');
    this.$dropdown_task_lang.toggleClass('loading');

    this.task_lang = $('#task_lang');
  }

  load() {
    let $dropdown_task_lang = this.$dropdown_task_lang;

    $.ajax({
      method: "GET",
      url: '/expressions/available_syntaxes',
      dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error: available_syntaxes');
      },
      success: function (data) {
        $dropdown_task_lang.dropdown({
          values: data['available_syntaxes']
        });
        // set value as choosen before
        if (localStorage.task_syntax) {
          $dropdown_task_lang.dropdown('set selected', localStorage.task_syntax);
        }
      },
      complete: function() {
        $dropdown_task_lang.toggleClass('loading');
      }
    });
  }

  taskLang() {
    if (this.$dropdown_task_lang.length > 0) {
      return this.$dropdown_task_lang.dropdown('get value');
    }
    return this.task_lang.val();
  }
}
