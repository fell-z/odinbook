class CommentsController < ApplicationController
  def create
    @post = Post.includes(comments: [ :user ]).find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post)
    else
      render "posts/show", status: :unprocessable_content
    end
  end

  private

  def comment_params
    params.expect(comment: [ :body ])
  end
end
