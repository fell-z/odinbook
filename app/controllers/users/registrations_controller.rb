# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super

    if @user.persisted?
      UserMailer.with(user: @user).welcome_email.deliver_later
    end
  end
end
