export class ChatBtn {
  constructor(chat) {
    this.chat = chat;
    this.$chat_btn = $('#chat_btn');

    let original_context = this;
    this.$chat_btn.on('click', function () {
      original_context.click($(this));
    });
  }

  click(elem) {
    elem.toggleClass('loading');
    // TODO заблокировать выражение
    this.chat.loadQuestion();
    this.chat.open();
    elem.toggleClass('loading');
  }

  show() {
    this.$chat_btn.show();
  }

  hide() {
    this.$chat_btn.hide();
  }
}
