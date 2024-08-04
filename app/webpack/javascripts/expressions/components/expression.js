export class Expression {
  constructor(available_syntaxes) {
    this.available_syntaxes = available_syntaxes;
  }

  // Возвращает выражение в ввиде json
  prepare(selected_index = null, action = 'find_errors', options = null) {
    let lang = $('#lang').val();
    let task_lang = this.available_syntaxes.taskLang();
    let tokens_json = this.tokens(selected_index);

    let result = { expression: tokens_json, task_lang: task_lang, lang: lang, action: action };

    if (options != null) {
      if (options['answers'] != null) {
        result['answers'] = options['answers'];
      }
      if (options['supplementaryInfo'] != null) {
        result['supplementaryInfo'] = options['supplementaryInfo'];
      }
    }

    return result;
  }

  tokens(selected_index = null) {
    let expr_str = $('#expression').val();
    let expr_tokens = expr_str.split(' ');

    let buttons = $('.operator').toArray();

    // let selected_operators = $('.operator.green[data-index]').map(function() {
    //   return parseInt($(this).attr('data-index'));
    // }).toArray();
    let tokens_json = expr_tokens.map(function(currentValue, index) {
      let result = { "text": currentValue };
      // Если был выбран оператор с заданным индексом
      // или оператор уже был выбран корректно ранее
      // if ((selected_index != null && index == selected_index)
      //     || (selected_operators.includes(index))) {
      //   result["check_order"] = index;
      // }

      if (selected_index != null) {
        let $button = $(buttons[index]);
        // Либо кнопка уже имеет порядок
        if ($button != undefined && $button.hasClass('green') && $button.data('order') != undefined) {
          result["check_order"] = $button.data('order');
          // Либо кнопка была нажата последней и мы устанавливаем ей порядок
        } else if (index == selected_index) {
          result["check_order"] = $('.operator.green[data-order]').length + 1;
        }
      }

      return result;
    });

    return tokens_json;
  }
}
