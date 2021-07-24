class ApplicationController < ActionController::Base
  before_action :set_locale

  rescue_from BaseService::ServiceNotAvailableException, with: :render_not_available

  class << self
    def default_url_options
      { locale: I18n.locale }
    end
  end

  def index
  end

  def publications
  end

  private
    def set_locale
      locale_from_header = extract_locale_from_accept_language_header
      I18n.locale =
        if params[:locale] && locale_exist?(params[:locale].to_sym)
          params[:locale].to_sym
        elsif locale_from_header.present? && locale_exist?(locale_from_header)
          locale_from_header
        else
          I18n.default_locale
        end
    end

    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
    end

    def locale_exist?(locale)
      I18n.available_locales.include?(locale)
    end

    def render_not_available
      render 'application/not_available'
    end
end
