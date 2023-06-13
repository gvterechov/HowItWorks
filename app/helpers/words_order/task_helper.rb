module WordsOrder::TaskHelper
  def default_placeholder
    '___'.freeze
  end

  def placeholder(label: nil, attributes: {}, klass: '', error: false)
    attributes = attributes.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')

    klass += "#{klass} red between-words" if error

    "<div class=\"ui large label disabled word-placeholder #{klass} #{'filled' if label && !error}\"
          style=\"cursor: default;\"
          #{attributes}
    >#{label || default_placeholder}</div>".html_safe
  end

  def count_sign(num)
    num == WordsOrderTask::MAX_LEXEME_COUNT ? sync_icon : "#{close_icon('small')}#{num}".html_safe
  end

end
