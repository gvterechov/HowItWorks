import { StudentModal } from "./student_modal";

export class Attempt {
  constructor() {
    this.$student_statistic = $('#student_statistic');
    this.student_modal = new StudentModal();
  }

  fetchData() {
    // не выполнять запрос в режиме preview
    if (window.location.href.includes('preview') || !this.hasAttempt())
      return;

    $.ajax({
      method: "GET",
      url: `/${$('#lang').val()}/attempts/${this.getId()}/statistic`,
      data: {},
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: (data) => {
        this.$student_statistic.html(data);
      }
    });
  }

  getId() {
    return this.student_modal.getAttemptId();
  }

  hasAttempt() {
    let id = this.getId();
    return id !== null && id !== undefined && id !== '';
  }
}
