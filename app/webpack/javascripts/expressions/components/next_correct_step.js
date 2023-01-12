export class NextCorrectStep {
  constructor(chat, expression_trainer) {
    this.chat = chat;
    this.expression_trainer = expression_trainer;
    this.available_hints_count = parseInt($('#max_available_hints_count').val()) || 1000;

    this.$show_next_correct_step = $('#show_next_correct_step');
    this.$available_hints_count = $('#available_hints_count');

    this.$show_next_correct_step.click(() => { this.useHint(); });
  }

  show() {
    this.$show_next_correct_step.show();
  }

  hide() {
    this.$show_next_correct_step.hide();
  }

  enable(enabled = true) {
    this.$show_next_correct_step.attr("disabled", !enabled);
  }

  // Нажатие на кнопку отображения следующего успешного шага
  useHint() {
    this.chat.renew();

    --this.available_hints_count;
    if (this.available_hints_count >= 0) { // && $('#available_hints_count').length > 0) {
      this.$available_hints_count.text(this.available_hints_count);
    }

    this.expression_trainer.update($(this), 1000, 'next_step');
  }

  updateEnabled() {
    this.enable(this.available_hints_count != 0);
  }
}
