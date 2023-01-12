import { ChatBtn } from "./chat_btn";

export class Chat {
  constructor(expression) {
    this.expression = expression;
    this.chat_btn = new ChatBtn(this);

    let original_context = this;
    $('#chat_understand_btn').click(function () {
      original_context.understandClick($(this));
    });

    $('#chat_close_btn').click(() => {
      // Показываем дополнительный вопрос студенту,
      // если он хочет закрыть чат, в котором еще есть активный диалог
      // (есть кнопки с ответами)
      if ($('button[data-additional-info]').length > 0) {
        this.hide(); // TODO баг - чат прыгает, теперь хотя бы скрываем
        $('#chat_close_alert').modal('show');
      } else {
        this.collapse();
      }
    });

    $('#chat_close_yes').click(() => {
      this.collapse();
      this.clearAnswers();
    });

    $('#chat_close_no').click(() => { this.open() });

    $(document).keyup(function(event) {
      if (event.key === "Escape") {
        this.collapse();
      }
    });

    this.$chat_answers_block = $('#chat_answers_block');
    this.$chat_content = $('#chat_content');
    this.$chat_feed = $('#chat_feed');
    this.$chat_answers = $('#chat_answers');
    this.$chat = $('#chat');
  }

  loadQuestion() {
    let error_index = this.errorOperatorIndex();

    $.ajax({
      method: "GET",
      url: '/expressions/get_supplement',
      data: {
        data: JSON.stringify(this.expression.prepare(error_index, 'find_errors')),
      },
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: (data) => {
        this.update(data);
      },
      complete: function () {
        // TODO разблокировать нажатие на элементы алгоритма
      }
    });
  }

  loadNextQuestion(elem) {
    // Добавляем выбранный студентом ответ в чат
    this.addText(elem.text(), 'right');

    let error_index = this.errorOperatorIndex();
    let type = elem.data('additional-info');

    $.ajax({
      method: "GET",
      url: '/expressions/get_next_supplement',
      data: {
        data: JSON.stringify(this.expression.prepare(error_index, 'get_supplement', type)),
      },
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: (data) => {
        if (data['answers'].length > 0) {
          // Добавляем в чат, правильно ли ответил студент
          this.addStudentAnswerReaction(elem);
        }

        this.update(data);
      },
      complete: function () {
        // TODO разблокировать нажатие на элементы алгоритма
      }
    });
  }

  update(data) {
    // Добавляем вопрос в нужное место
    this.addText(data['text'], 'left');

    this.clearAnswers();
    // Добавляем кнопки с ответами
    if (data['answers'].length > 0) {
      this.$chat_answers_block.show();
      data['answers'].forEach((answer) => {
        this.addAnswer(answer);
      });
    } else {
      this.$chat_answers_block.hide();
    }
  }

  // Скроллим чат до последнего сообщения
  scrollDown() {
    this.$chat_content.scrollTop(this.$chat_content.prop("scrollHeight"));
  }

  // Оценивает ответ студентв в словестной форме,
  // одним из вариантов слов "верно" или "неверно"
  rateStudentAnswer(elem) {
    let answers_selector = elem.data('status') === 'correct' ? '#chat_correct' : '#chat_incorrect';
    let answers = $(answers_selector).val().split(', ');
    return answers[Math.floor(Math.random() * answers.length)];
  }

  // Добавить фразу в чат
  addText(text, direction) {
    let $message = $(`#${direction}_event`).clone();
    $message.removeAttr('id');
    $(`#${direction}_event_text`, $message).text(text);
    $(`#${direction}_event_text`, $message).removeAttr('id');
    this.$chat_feed.append($message);
    $message.show();

    this.scrollDown();

    return $message;
  }

  // Добавить в чат слева реакцию на ответ студент
  // (корректный или некорректный у студента был ответ)
  addStudentAnswerReaction(elem) {
    let rate_answer = this.rateStudentAnswer(elem);
    return this.addText(rate_answer, 'left');
  }

  // Добавить вариант ответа в чат
  // options
  //  text - текст варианта ответа
  //  enabled - доступен ли для выбора вариант ответа
  //  status - правильный или нет ответ
  //  additional_info - доп. инфо
  addAnswer(options) {
    let $answer = $('#answer').clone();
    $answer.text(options['text']);
    if (options['enabled'] === false) {
      $answer.addClass('disabled');
    }
    $answer.attr('data-status', options['status']);
    $answer.attr('data-additional-info', options['additional_info']);
    $answer.removeAttr('id');
    this.$chat_answers.append($answer);
    let original_context = this;
    $answer.click(function () {
      original_context.loadNextQuestion($(this));
    });
    $answer.show();
    return $answer;
  }

  // Очистить чат
  clear() {
    this.$chat_feed.empty();
    this.clearAnswers();
  }

  // Очистить предоставленные студенту ответы
  clearAnswers() {
    this.$chat_answers.empty();
  }

  // Свернуть чат
  collapse() {
    this.$chat.hide();
    this.chat_btn.show();
  }

  // Развернуть чат
  open() {
    this.$chat.show();
    this.chat_btn.hide();
  }

  // Скрыть чат вместе с миниатюрой
  hide() {
    this.$chat.hide();
    this.chat_btn.hide();
  }

  // Пересоздать чат, чтобы он был как новый
  renew() {
    this.hide();
    this.clear();
  }

  understandClick(elem) {
    elem.toggleClass('loading');
    // Добавить ответ студента в чат
    this.addText(elem.text(), 'right');
    this.collapse();

    // TODO разблокировать выражение
    elem.toggleClass('loading');
  }

  // TODO дублируется
  errorOperatorIndex() {
    return $('.operator.red').data('index');
  }
}