class LikesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    @like = post.likes.build(user: current_user)

    respond_to do |with|
      if @like.save
        with.turbo_stream
      end

      # TODO: Render turbo stream error message when it fails
    end
  end

  def destroy
    like = Like.find(params[:id])
    @post = like.post

    like.destroy

    respond_to do |with|
      with.turbo_stream
    end
  end
end
