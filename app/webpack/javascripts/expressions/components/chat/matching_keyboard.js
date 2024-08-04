export class MatchingKeyboard {
  constructor(chat, send_btd) {
    this.chat = chat;

    this._original_answer_options = [];
    this._original_match_options = [];

    this.send_btd = send_btd;
    this.send_btd.setKeyboard(this);
    this.send_btd.show();
    this.send_btd.activate();
    this.send_btd.disable();

    this.$chat_answers = $('#chat_answers');
  }

  addAnswers(answers, matches) {
    this._original_answer_options = answers;
    this._original_match_options = matches;

    let match_options = [];
    matches.forEach((match_option) => {
      match_options.push({ name: match_option['text'], value: match_option['id'] });
    });

    answers.forEach((answer_options) => {
      this.#addAnswer(answer_options, match_options);
    });

    this.send_btd.show();
    this.send_btd.activate();
    this.send_btd.disable();
  }

  #addAnswer(answer_options, match_options) {
    let $answer = $('#match_answer').clone();
    $answer.find('> .match_text').text(answer_options['text']);
    $answer.attr('data-id', answer_options['id']);
    $answer.removeAttr('id');

    let $match_select = $('#match_select').clone();
    $match_select.removeAttr('id');

    $answer.append($match_select);

    $match_select.dropdown({
      values: match_options,
      onChange: (value, text) => {
        let answers_count = this.selectedAnswers().length;
        let selected_count = 0;
        this.selectedAnswers().each((i, select) => {
          if ($(select).dropdown('get text').length > 0) {
            selected_count += 1;
          }
        });

        if (answers_count == selected_count) {
          this.send_btd.enable();
        } else {
          this.send_btd.disable();
        }
      }
    });

    this.$chat_answers.append($answer);
    $answer.show();
    return $answer;
  }

  toText() {
    return this.$chat_answers
      .children()
      .map((i, elem) => {
        let answer_variant = $(elem).find('> .answer_variant').dropdown('get text');
        let match_text = $(elem).find('> .match_text').text()
        return `${match_text} - ${answer_variant}`;
      })
      .get();
  }

  resultData() {
    return this.selectedAnswers()
      .map((i, select) => {
        let match_id = $(select).dropdown('get item', $(select).dropdown('get text')).attr('data-value');
        let value = this._original_match_options.find((option) => option['id'] == match_id);
        return value;
      })
      .get();
  }

  selectedAnswers() {
    return $('#chat_answers >> .answer_variant');
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
