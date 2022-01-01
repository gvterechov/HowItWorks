export function getAttemptData() {

  // не выполнять запрос в режиме preview
  if (window.location.href.includes('preview'))
    return;

  $.ajax({
    method: "GET",
    url: '/' + $('#lang').val() + '/attempts/' + $('#attempt_id').val() + '/statistic',
    data: {},
    // dataType: "json",
    error: function (jqXHR) {
      // TODO показать сообщение об ошибке
      alert('error');
    },
    success: function (data) {
      $('#student_statistic').html(data);
    }
  });
};
