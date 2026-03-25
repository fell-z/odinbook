class UsersController < ApplicationController
  include PageHandler

  def index
    @users = User.excluding(current_user).page(@page_number)
  end
end
