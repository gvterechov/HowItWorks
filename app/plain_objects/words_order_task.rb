# frozen_string_literal: true

class WordsOrderTask
  MAX_LEXEME_COUNT = 999
  INFINITE_LEXEMES = %w[-]

  attr_accessor :data

  def initialize(data)
    @data = data
    @data[:availableLexemes] = reduce_lexemes(@data[:wordsToSelect])
  end

  def assignment
    noun = "'#{data[:studentAnswer].first[:name]}'"
    data[:availableLexemes].keys
                          .reject { |l| INFINITE_LEXEMES.include?(l) }
                          .shuffle!
                          .map! { |l| "'#{l}'" }
                          .join(", #{I18n.t('words_order.task.linking')}")
                          .then { |tail| I18n.t('words_order.task.assignment', tail: tail, noun: noun) }
  end

  private
    def reduce_lexemes(lexemes)
      lexemes.reduce({}) do |memo, lexeme|
        memo[lexeme] = INFINITE_LEXEMES.include?(lexeme) ? MAX_LEXEME_COUNT : (memo[lexeme] || 0) + 1
        memo
      end
    end
end
