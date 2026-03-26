class UserMailer < ApplicationMailer
  default from: "odinbook.app@example.com"

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: "Welcome to OdinBook")
  end
end
