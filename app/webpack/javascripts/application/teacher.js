// Показать анкету для преподавателя
export function showTeacherModal() {
  if (getCookie('teacher_modal_was_shown') == undefined) {
    renderTeacherModal();
  }
}

// возвращает куки с указанным name,
// или undefined, если ничего не найдено
export function getCookie(name) {
  let matches = document.cookie.match(new RegExp(
      "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
  ));
  return matches ? decodeURIComponent(matches[1]) : undefined;
}

function renderTeacherModal() {
  $('.ui.modal.teacher').modal('show');
  // запомнить (на 1 год) что модальное окно уже было показано, не показывать больше
  document.cookie = 'teacher_modal_was_shown=true; max-age=31536000';
}

$(function() {
  $('#feedback_btn').click(function() {
    renderTeacherModal();
  });

  $('#teacher_modal_submit_btn').click(function() {
    saveTeacherName();

    let elem = $(this);
    elem.toggleClass('loading');

    let formdata = $("#teacher_feedback").serializeArray();
    let data = {};
    $(formdata).each(function(index, obj){
      data[obj.name] = obj.value;
    });

    $.ajax({
      method: "POST",
      url: '/teacher_feedback.json',
      data: { teacher_feedback: data },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: function (data) {
        $('.ui.modal.teacher').modal('hide');
      },
      complete: function() {
        // TODO разблокировать нажатие на элементы алгоритма
        elem.toggleClass('loading');
      }
    });
  });

  // Запомнить имя преподавателя, если оно задано, использовать его при генерации ссылки на задачу
  function saveTeacherName() {
    localStorage.teacher_name = $('#teacher_name').val();
  }
});
