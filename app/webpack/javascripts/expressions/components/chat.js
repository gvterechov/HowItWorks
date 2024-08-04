import { ChatBtn } from "./chat_btn";
import { SingleKeyboard } from "./chat/single_keyboard";
import { MultipleKeyboard } from "./chat/multiple_keyboard";
import { MatchingKeyboard } from "./chat/matching_keyboard";
import { SendAnswersBtn } from "./chat/send_answers_btn";

export class Chat {
  constructor(expression) {
    this.supplementary_info = '';

    this.expression = expression;
    this.chat_btn = new ChatBtn(this);

    this.keyboard = null;
    this.$chat_answers_block = $('#chat_answers_block');

    this.send_btd = new SendAnswersBtn();

    $('#chat_understand_btn').on('click', () => {
      this.understandClick($(this));
    });

    $('#chat_close_btn').on('click', () => {
      // Показываем дополнительный вопрос студенту,
      // если он хочет закрыть чат, в котором еще есть активный диалог
      // (есть кнопки с ответами)
      if ($('#chat_answers').children().length > 0) {
        this.hide(); // TODO баг - чат прыгает, теперь хотя бы скрываем
        $('#chat_close_alert').modal('show');
      } else {
        this.collapse();
      }
    });

    $('#chat_close_yes').on('click', () => {
      this.collapse();
      this.clearKeyboard();
    });

    $('#chat_close_no').on('click', () => { this.open() });

    $(document).on('keyup', (event) => {
      if (event.key === "Escape") {
        this.collapse();
      }
    });

    this.$chat_content = $('#chat_content');
    this.$chat_feed = $('#chat_feed');
    this.$chat = $('#chat');
  }

  // Задержа ответа чат-бота, мс
  loadAnswerDelay() { return 0; }

  loadQuestion() {
    this.addStub();

    setTimeout(() => {
      this.firstQuestion();
    }, this.loadAnswerDelay());
  }

  firstQuestion() {
    let error_index = this.errorOperatorIndex();

    $.ajax({
      method: "GET",
      url: '/expressions/get_supplement',
      data: {
        data: JSON.stringify(this.expression.prepare(error_index, 'get_supplement')),
      },
      error: (jqXHR) => {
        // TODO показать сообщение об ошибке
        alert('error');
        this.removeStub();
        this.supplementary_info = '';
      },
      success: (data) => {
        this.update(data);
      },
      complete: () => {
        // TODO разблокировать нажатие на элементы алгоритма
      }
    });
  }

  loadNextQuestion(answer_texts, answer_data) {
    // Добавляем выбранный студентом ответ в чат
    answer_texts.forEach((answer_text) => {
      this.addText(answer_text, 'right');
    });

    this.addStub();

    setTimeout((answer_data) => {
      this.nextQuestion(answer_data);
    }, this.loadAnswerDelay(), answer_data);
  }

  nextQuestion(answer_data) {
    let error_index = this.errorOperatorIndex();

    if (this.supplementary_info != null) {
      answer_data['supplementaryInfo'] = this.supplementary_info;
    }

    $.ajax({
      method: "GET",
      url: '/expressions/get_next_supplement',
      data: {
        data: JSON.stringify(this.expression.prepare(error_index, 'get_supplement', answer_data)),
      },
      error: (jqXHR) => {
        // TODO показать сообщение об ошибке
        alert('error');
        this.removeStub();
        this.supplementary_info = '';
      },
      success: (data) => {
        this.update(data);
      },
      complete: () => {
        // TODO разблокировать нажатие на элементы алгоритма
      }
    });
  }

  update(data) {
    this.supplementary_info = data['supplementaryInfo'];

    this.removeStub();

    // Печатаем объяснения
    if (data['explanations'] != null && data['explanations'].length > 0) {
      data['explanations'].forEach((explanation) => {
        this.addText(explanation['text'], 'left');
      });
    }

    // Печатаем вопрос
    if ('questionInfo' in data) {
      if ('text' in data.questionInfo) {
        this.addText(data['questionInfo']['text'], 'left');
      }

      // Печатаем варианты ответов
      this.clearKeyboard();

      if ('answerOptions' in data.questionInfo) {
        let answers = data['questionInfo']['answerOptions'];
        if (answers.length > 0) {
          this.$chat_answers_block.show();

          switch(data['questionInfo']['type']) {
            case 'single':
              this.keyboard = new SingleKeyboard(this);
              this.keyboard.addAnswers(answers);
              break;
            case 'multiple':
              this.keyboard = new MultipleKeyboard(this, this.send_btd);
              this.keyboard.addAnswers(answers);
              break;
            case 'matching':
              this.keyboard = new MatchingKeyboard(this, this.send_btd);
              this.keyboard.addAnswers(answers, data['questionInfo']['matchOptions']);
              break;
          }
        } else {
          this.$chat_answers_block.hide();
        }
      }
    } else {
      this.clearKeyboard();
      this.$chat_answers_block.hide();
    }
  }

  // Скроллим чат до последнего сообщения
  scrollDown() {
    this.$chat_content.scrollTop(this.$chat_content.prop("scrollHeight"));
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

  // Добавить заглушку в виде многоточий для чат-бота
  addStub() {
    let $stub = this.addText('...', 'left');
    $stub.attr('id', 'message_stub');

    return $stub;
  }

  // Удалить последнее сообщение из чата
  removeStub() {
    $('#message_stub').remove();
  }

  clearKeyboard() {
    if (this.keyboard != null) {
      this.keyboard.clear();
    }
  }

  // Очистить чат
  clear() {
    this.$chat_feed.empty();
    this.clearKeyboard();
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

  // TODO: вынести?
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
