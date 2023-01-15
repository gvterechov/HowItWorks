module WordsOrder::TaskHelper
  def placeholder(label: nil, attributes: {}, klass: nil)
    attributes = attributes.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')

    "<div class=\"ui large label disabled word-placeholder #{klass} #{'filled' if label}\"
          style=\"cursor: default;\"
          #{attributes}
    >#{label || '___'}</div>".html_safe
  end

  def count_sign(num)
    num == WordsOrderTask::MAX_LEXEME_COUNT ? infinite_sign : num
  end

  def infinite_sign
    '&#8734;'.html_safe
  end
end
