module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :set_token
  end

  class_methods do
    def token_for_model(model_name)
      define_method :model_name do
        model_name
      end
    end
  end

  protected

    def set_token
      self.token = generate_token
    end

    def generate_token
      loop do
        random_token = SecureRandom.hex
        break random_token unless model_name.to_s.classify.constantize.where(token: random_token).exists?
      end
    end
end
