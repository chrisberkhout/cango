class LandingController < ApplicationController
  respond_to :html
  
  def index
    @comment = Comment.new
    respond_with @comment
  end
end
