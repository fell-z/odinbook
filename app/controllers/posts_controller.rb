class PostsController < ApplicationController
  include PageHandler

  before_action :set_post, only: %i[ edit update destroy ]

  def index
    @posts = Post.includes(:user)
      .where(user: [ current_user, *current_user.followees ])
      .recent
      .page(@page_number)
  end

  def show
    @post = Post.includes(comments: [ :user ]).find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to posts_path
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @post.destroy

    redirect_to posts_path, status: :see_other
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.expect(post: [ :body ])
  end
end
