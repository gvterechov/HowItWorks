# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    return unless user.present?

    user.roles.each do |role|
      send("#{role}_can") if respond_to?("#{role}_can", true)
    end
  end

  private

  def basic_can
    can :manage, TaskTag, user_id: user.id
    can :read, Publication
  end

  def admin_can
    can :manage, :all
  end
end

