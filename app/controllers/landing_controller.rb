class LandingController < ApplicationController
  respond_to :html
  
  def index
    @comments = Comment.order('created_at DESC').limit(10).reverse
    @comment = Comment.new
    respond_with @comments, @comment
  end
  
end
