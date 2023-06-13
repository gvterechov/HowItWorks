// TODO сделать компонент для предложения и для слов отдельно
export class WordsOrderTrainer {
  constructor() {
    $('.word').transition({
      animation : 'pulse',
      interval  : 200
    });

    // $('.word').draggable();
    // $("#sentence").droppable({
    //   drop: function( event, ui ) {
    //     $("#sentence").transition('pulse');
    //   }
    // });

    this.$selected_word = null;
    this.$selected_placeholder = null;

    this.$selected_word_placeholder = null;

    this.$sentence_trainer = $('#sentence_trainer');
    this.init();
  }

  lexemeClick(elem) {
    // Показать подсказку по Esc
    this.showReleaseLexeme();
    // Выделить кликнутое слово
    elem.addClass('green');
    this.disableLexemes();
    this.$selected_word = elem.find('> .lexeme-text');
    this.$selected_word.removeClass('disabled');

    // Удалить ошибочное слово из предложения, если оно есть
    let $error_placeholder = this.errorPlaceholder();
    $error_placeholder.removeClass(['red', 'filled']);
    $error_placeholder.text($error_placeholder.data('alt-placeholder'));
    // Выделить свободные поля в предложении
    let placeholders = null;
    if (this.$selected_word.text() === '-') {
      placeholders = this.emptyPlaceholdersBetweenWords();
    } else {
      placeholders = this.emptyPlaceholders();
    }
    this.enablePlaceholders(placeholders);
  }

  emptyPlaceholderClick(elem) {
    if (this.$selected_word !== null) { // Клик по placeholder после клика на word (вставляем слово в пустое место)
      this.hideReleaseLexeme();
      this.placeWord(elem);
    } else if(this.$selected_placeholder === null) { // Первый клик по placeholder, (выбор слова для замены местами)
      this.selectPlaceholder(elem); // TODO кажется, это не нужно
    } else { // Клик по placeholder со словом, затем по placeholder (замена слов местами)
      this.swapPlaceholders(elem); // TODO кажется, это не нужно
    }
    this.checkWordsOrder();
  }

  filledPlaceholderClick(elem) {
    // Подсвечиваем выбранное слово
    elem.addClass('green');
    // Если не выбрано ни одного слово
    if (this.$selected_word_placeholder === null) {
      // Включаем вторую подсказку
      this.showSelectHelpStep2();

      // Выбираем первое
      this.$selected_word_placeholder = elem.find('> .lexeme-text');
      // Отключаем все слова кроме слева и справа
      this.disablePlaceholders(this.filledPlaceholders());

      let placeholder = elem[0].previousElementSibling;
      if (placeholder !== null) {
        placeholder = placeholder.previousElementSibling;
        if (placeholder !== null) {
          this.enablePlaceholders($(placeholder));
        }
      }

      placeholder = elem[0].nextElementSibling;
      if (placeholder !== null) {
        placeholder = placeholder.nextElementSibling;
        if (placeholder !== null) {
          this.enablePlaceholders($(placeholder));
        }
      }
    } else {
      // Выбираем плейсхолдер между двумя зелеными словами
      let $empty_placeholder = null;
      this.emptyPlaceholders().each(function() {
        let $previous_sibling = $(this)[0].previousElementSibling;
        let $next_sibling = $(this)[0].nextElementSibling;

        if ($previous_sibling !== null && $($previous_sibling).hasClass('green') &&
          $next_sibling !== null && $($next_sibling).hasClass('green')) {
          $empty_placeholder = $(this);
        }
      });
      if ($empty_placeholder !== null) {
        // Вставляем дефис в плейсхолдер
        $empty_placeholder.text('-');
        $empty_placeholder.addClass('filled');
        // Отправляем запрос на сервер
        this.checkWordsOrder();
      }
    }
  }

  placeWord(elem) {
    // Добаляем слово в placeholder
    elem.text(this.$selected_word.text());
    elem.addClass('filled');
    // Удаляем слово word
    this.$selected_word.parent().remove();
    // this.$selected_word = null; // TODO кажется, это не нужно
    // Отключаем все пустые placeholder
    // this.disablePlaceholders(this.emptyPlaceholders());
    this.disablePlaceholders(this.placeholders());

    // // Включаем кнопку проверки когда все word закончились
    // if (this.isLexemesOver()) {
    //   // Показываем кнопку завершения задачи
    //   this.showCompleteBtn();
    // } else {
    //   // Включаем все оставшиеся слова
    //   this.enableLexemes();
    // }
  }

  selectPlaceholder(elem) {
    this.$selected_placeholder = elem;
    this.$selected_placeholder.addClass('disabled');
  }

  // TODO кажется, это не нужно
  swapPlaceholders(elem) {
    let text = elem.text();
    elem.text(this.$selected_placeholder.text());
    this.$selected_placeholder.text(text);

    this.$selected_placeholder.removeClass('disabled');
    this.$selected_placeholder = null;
  }

  placeholders() {
    return $('.word-placeholder');
  }

  emptyPlaceholders() {
    return $('.word-placeholder:not(.filled)');
  }

  emptyPlaceholdersBetweenWords() {
    return this.emptyPlaceholders().filter('.between-words');
  }

  filledPlaceholders() {
    return $('.word-placeholder.filled');
  }

  errorPlaceholder() {
    return $($('.word-placeholder.red')[0]);
  }

  hidePlaceholders(objs) {
    objs.hide();
  }

  enablePlaceholders(objs) {
    objs.removeClass('disabled').css({ 'cursor': 'pointer' });
  }

  disablePlaceholders(objs) {
    objs.addClass('disabled').css({ 'cursor': 'default' });
  }

  placeholdersRelease() {
    this.placeholders().removeClass('green');
  }

  enableLexemes() {
    $('.word').removeClass('disabled');
  }

  disableLexemes() {
    $('.word').addClass('disabled');
  }

  isLexemesOver() {
    return $('.word').length === 0;
  }

  hasErrors() {
    return $('#error_messages').length > 0
  }

  async checkWordsOrder() {
    $("#sentence").toggleClass('loading');

    let original_context = this;

    await $.ajax({
      method: "GET",
      url: '/words_order/check_expression',
      data: {
        data: JSON.stringify({
          lang: this.language(),
          studentAnswer: this.student_answer(),
          wordsToSelect: this.words_to_select(),
          taskInTTLFormat: this.task_in_ttl_format()
        })
      },
      // dataType: "json",
      error: function (jqXHR) {
        // TODO показать сообщение об ошибке
        alert('error');
      },
      success: function (data) {
        original_context.$sentence_trainer.html(data);
        original_context.init();

        // Если задача успешно решена
        if (original_context.taskSolved()) {
          $('.ui.modal.success').modal('show'); // TODO сделать класс модального окна, в него метод show
          original_context.hidePlaceholders(original_context.emptyPlaceholders());
        }
      },
      complete: function() {
        original_context.$selected_word = null;
      }
    });
  }

  student_answer() {
    return $('.filled')
      .toArray()
      .map((lexeme) => {
        return {
          'id': $(lexeme).data('id'),
          'name': $(lexeme).text()
        }
      });
  }

  words_to_select() {
    return $('#words_to_select').val();
    // return $('.word > .lexeme-text').toArray().map((lexeme) => { return $(lexeme).text() });
  }

  task_in_ttl_format() {
    return $('#task_in_ttl_format').val();
  }

  language() {
    return $('#lang').val();
  }

  async completeTask() {
    await this.checkWordsOrder(); // TODO если отослали запрос и ошибок в ответе нет, то решили задачу верно
    if ($('#error_messages').length === 0) {
      $('.ui.modal.success').modal('show'); // TODO сделать класс модального окна, в него метод show
      this.hidePlaceholders(this.emptyPlaceholders());
      this.disableLexemes();
      $('#complete_task').hide();
    }
  }

  enableWordsSelection() {
    // Выключаем слова
    this.disableLexemes();
    // Выключаем плейсхолдеры между словами
    this.disablePlaceholders(this.emptyPlaceholdersBetweenWords());
    // Включаем слова, между которыми еще нет дефиса
    this.enablePlaceholders(this.filledPlaceholders());
  }

  disableWordsSelection() {
    // Очищаем выбранные слова
    this.$selected_word_placeholder = null;
    // Выключаем плейсхолдеры
    this.disablePlaceholders(this.placeholders());
    // Включаем слова
    this.placeholdersRelease();
    this.enableLexemes();
  }

  releaseLexeme() {
    if (this.$selected_word !== null) {
      this.$selected_word = null;
      this.disablePlaceholders(this.placeholders());
      $('.word.green').removeClass('green');
      this.enableLexemes();
    }
  }

  init() {
    let original_context = this;

    $('.word').click(function(e) {
      e.preventDefault();
      if ($(this).hasClass('disabled')) return;
      original_context.lexemeClick($(this));
    });

    this.emptyPlaceholders().click(function(e) {
      e.preventDefault();
      if ($(this).hasClass('disabled')) return;
      original_context.emptyPlaceholderClick($(this));
    });

    this.filledPlaceholders().click(function(e) {
      e.preventDefault();
      if ($(this).hasClass('disabled')) return;
      original_context.filledPlaceholderClick($(this));
    });

    $('#complete_task').click(function(e) {
      e.preventDefault();
      original_context.completeTask();
    });

    $(document).keydown(function(e) {
      switch (e.key) {
        case "Alt":
          // TODO включить только если есть дефис
          if (original_context.taskSolved()) return;
          original_context.showSelectHelpStep1();
          original_context.releaseLexeme();
          original_context.enableWordsSelection();
          break;
      }
    });

    $(document).keyup(function(e) {
      switch(e.key) {
        case "Escape":
          original_context.hideReleaseLexeme();
          original_context.releaseLexeme();
          break;
        case "Alt":
          // TODO включить только если есть дефис
          original_context.showSelectHelp();
          original_context.disableWordsSelection();
          break;
      }
    });
  }

  taskSolved() {
    return this.isLexemesOver() && !this.hasErrors();
  }

  // --- Подсказки ---
  // TODO назвать режим вставки
  select_help() {
    return $('#select_help');
  }

  select_help_step1() {
    return $('#select_help_step1');
  }

  select_help_step2() {
    return $('#select_help_step2');
  }

  showSelectHelp() {
    this.select_help().show();
    this.select_help_step1().hide();
    this.select_help_step2().hide();
  }

  showSelectHelpStep1() {
    this.select_help().hide();
    this.select_help_step1().show();
    this.select_help_step2().hide();
  }

  showSelectHelpStep2() {
    this.select_help().hide();
    this.select_help_step1().hide();
    this.select_help_step2().show();
  }

  release_lexeme() {
    return $('#release_lexeme');
  }

  showReleaseLexeme() {
    this.release_lexeme().show();
  }

  hideReleaseLexeme() {
    this.release_lexeme().hide();
  }
  // --- /Подсказки ---
}
