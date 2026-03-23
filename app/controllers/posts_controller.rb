class PostsController < ApplicationController
  def index
    @page_number = params.fetch(:page_number, 1).to_i
    @page_number = 1 if @page_number.zero? || @page_number.negative?

    @posts = Post.includes(:user).recent.page(@page_number)
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
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy

    redirect_to posts_path, status: :see_other
  end

  private

  def post_params
    params.expect(post: [ :body ])
  end
end
