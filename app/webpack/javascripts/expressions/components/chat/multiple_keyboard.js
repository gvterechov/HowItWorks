export class MultipleKeyboard {
  constructor(chat, send_btd) {
    this.chat = chat;

    this._original_answer_options = [];

    this.send_btd = send_btd;
    this.send_btd.setKeyboard(this);
    this.send_btd.show();
    this.send_btd.activate();
    this.send_btd.disable();

    this.$chat_answers = $('#chat_answers');
  }

  addAnswers(answers) {
    this._original_answer_options = answers;

    answers.forEach((options) => {
      this.#addAnswer(options);
    });

    this.send_btd.show();
    this.send_btd.activate();
    this.send_btd.disable();
  }

  #addAnswer(options) {
    let $answer = $('#multiple_answer').clone();
    $answer.text(options['text']);

    $answer.attr('data-id', options['id']);
    $answer.removeAttr('id');
    this.$chat_answers.append($answer);

    let original_context = this;
    $answer.on('click', function() {
      $(this).toggleClass('active');

      if (original_context.selectedAnswers().length > 0) {
        original_context.send_btd.enable();
      } else {
        original_context.send_btd.disable();
      }
    });

    $answer.show();
    return $answer;
  }

  toText() {
    return this.selectedAnswers().map((i, elem) => $(elem).text()).get();
  }

  resultData() {
    return this.selectedAnswers()
      .map((i, elem) => {
        let answer_id = $(elem).attr('data-id');
        return this._original_answer_options.find((option) => option['id'] == answer_id);
      })
      .get();
  }

  selectedAnswers() {
    return $('#chat_answers > .active');
  }

  clear() {
    this.$chat_answers.empty();
    this.send_btd.hide();
  }

  // Заблокировать ответы
  disable() {
    this.$chat_answers.children().each(function() { $(this).addClass('disabled'); })
  }
}
