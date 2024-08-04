export class SendAnswersBtn {
  constructor() {
    this.$chat_send_answers_btd = $('#chat_send_answers_btd');
    this.#init_click();
  }

  setKeyboard(keyboard) {
    this.keyboard = keyboard;
  }

  enable() {
    this.$chat_send_answers_btd.removeClass('disabled');
  }

  disable() {
    this.$chat_send_answers_btd.addClass('disabled');
  }

  show() {
    this.$chat_send_answers_btd.show();
  }

  hide() {
    this.$chat_send_answers_btd.hide();
  }

  activate() {
    this.$chat_send_answers_btd.removeClass('loading');
    this.$chat_send_answers_btd.removeClass('disabled');
  }

  deactivate() {
    this.$chat_send_answers_btd.addClass('loading');
    this.$chat_send_answers_btd.addClass('disabled');
  }

  #init_click() {
    this.$chat_send_answers_btd.on('click', () => {
      if(this.keyboard == null) {
        return;
      }

      this.deactivate();

      // Блокируем варианты ответов
      this.keyboard.disable();

      this.keyboard.chat.loadNextQuestion(
        this.keyboard.toText(),
        {
          'answers': this.keyboard.resultData()
        }
      );
    });
  }
}
