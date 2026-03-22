class PostsController < ApplicationController
  def index
    @page_number = params.fetch(:page_number, 1).to_i
    @page_number = 1 if @page_number.zero? || @page_number.negative?

    @posts = Post.includes(:user).recent.page(@page_number)
  end
end
