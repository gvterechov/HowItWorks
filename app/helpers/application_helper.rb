module ApplicationHelper
  # Установить мета тег title на странице
  def title(page_title)
    content_for(:title) { page_title }
  end

  def language_switcher
    flags = { ru: 'ru', en: 'gb uk' }
    languages = { ru: 'Русский', en: 'English' }
    I18n.available_locales.each do |loc|
      if I18n.locale != loc
        name = "<i class='#{flags[loc]} flag'></i> #{languages[loc]}".html_safe
        return link_to(name,
                       alternate_url(request.original_url, loc),
                       class: "ui teal button",
                       'data-tooltip': I18n.t('change_language', locale: loc),
                       'data-position': "bottom right")
      end
    end
  end

  def feedback_button
    button_tag(t('feedback'),
               type: 'button',
               id: 'feedback_btn',
               class: 'ui basic button',
               style: 'margin-right: 10px;',
               'data-tooltip': I18n.t('teacher_modal.header'),
               'data-position': "bottom center")
  end

  def save_button(**options)
    enable_hints = options.fetch(:enable_hints, false)
    render partial: 'common/save_btn', locals: { enable_hints: enable_hints }
  end

  def show_next_correct_step_button(max_hints_count = 0)
    render partial: 'common/show_next_correct_step', locals: { max_hints_count: max_hints_count }
  end

  def tasks_button(href)
    if current_user.present?
      css_class = 'item'
      css_class += 'active' if request.fullpath.match(href)
      link_to t('my_tasks'),
              href,
              class: css_class
    end
  end

  def sign_out_button
    link_to("#{sign_out_icon}#{t('sign_out')}".html_safe,
            destroy_user_session_url,
            style: 'margin-right: 10px;',
            'data-method': :delete)
  end

  def sign_in_button
    link_to("#{sign_in_icon}#{t('sign_in')}".html_safe,
            new_user_session_url,
            style: 'margin-right: 10px;')
  end

  def user_session_button
    current_user.present? ? sign_out_button : sign_in_button
  end

  def claim_task_button
    render partial: 'common/claim_btn' if current_user.present?
  end

  def user_name
    render partial: 'common/user_name'
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

  def task_name(task)
    task.title.presence || t('name_not_set')
  end
end
