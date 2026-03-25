class FollowsController < ApplicationController
  before_action :set_destroy, only: %i[ refuse remove ]

  def requests
    @follow_requests = current_user.follow_requests_received
  end

  def send_request
    followee = User.find(params[:user_id])
    @follow = current_user.follow_requests_sent.build(followee:)

    respond_to do |with|
      if @follow.save
        with.turbo_stream
      else
        redirect_to users_path, alert: "Couldn't follow user"
      end
    end
  end

  def accept
    @follow = Follow.find(params[:id])
    @follow.accepted!

    respond_to do |with|
      with.turbo_stream
    end
  end

  def refuse
  end

  def remove
  end

  private

  def set_destroy
    @follow = Follow.find(params[:id])
    @follow.destroy

    respond_to do |with|
      with.turbo_stream
    end
  end
end
