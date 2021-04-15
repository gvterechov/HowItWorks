module ApplicationHelper
  # Установить мета тег title на странице
  def title(page_title)
    content_for(:title) { page_title }
  end

  def language_switcher
    I18n.available_locales.each do |loc|
      if I18n.locale != loc
        return link_to(loc.to_s.capitalize!,
                       alternate_url(request.original_url, loc),
                       class: "ui button")
      end
    end
  end

  # Генерирует альтернативный url для заданной локали на основе заданного url
  # @param original_url [String] исходная ссылка
  # @param locale [Symbol] локаль, для которой сгенерировать ссылку
  # @return [String] url на заданную страницу на другом языке
  def alternate_url(original_url, locale)
    current_url = URI(original_url)
    lang_in_url = Regexp.new("/#{I18n.locale}(?=/|$)")

    if original_url.match?(lang_in_url)
      original_url.sub(lang_in_url, "/#{locale}")
    elsif current_url.path.present?
      current_url.path = "/#{locale}#{current_url.path}"
      current_url.to_s
    else
      "#{original_url}/#{locale}"
    end
  end
end
