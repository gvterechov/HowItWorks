class ApplicationController < ActionController::Base
  before_action :set_locale

  def index
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
end
