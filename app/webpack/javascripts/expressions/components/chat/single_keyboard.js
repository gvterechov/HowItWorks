export class SingleKeyboard {
  constructor(chat) {
    this.chat = chat;

    this._original_answer_options = [];

    this.current_answer = null;

    this.$chat_answers = $('#chat_answers');
  }

  addAnswers(answers) {
    this._original_answer_options = answers;

    answers.forEach((options) => {
      this.#addAnswer(options);
    });
  }

  #addAnswer(options) {
    let $answer = $('#answer').clone();
    $answer.text(options['text']);

    $answer.attr('data-id', options['id']);
    $answer.removeAttr('id');
    this.$chat_answers.append($answer);
    let original_context = this;
    $answer.on('click', function () {
      original_context.current_answer = $(this);

      // Блокируем варианты ответов
      original_context.disable();

      original_context.chat.loadNextQuestion(
        original_context.toText(),
        {
          'answers': original_context.resultData($(this))
        }
      );
    });
    $answer.show();
    return $answer;
  }

  toText() {
    if (this.current_answer == null) {
      return [''];
    }

    return [this.current_answer.text()];
  }

  resultData(elem) {
    let answer_id = elem.attr('data-id');
    let answer = this._original_answer_options.find((option) => option['id'] == answer_id);
    return [answer];
  }

  clear() {
    this.$chat_answers.empty();
  }

  // Заблокировать ответы
  disable() {
    this.$chat_answers.children().each(function() { $(this).addClass('disabled'); })
  }
}
