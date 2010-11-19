class CommentsController < ApplicationController
  respond_to :html

  # GET /comments
  def index
    @comments = Comment.all
    respond_with @comments
  end

  # GET /comments/1
  def show
    @comment = Comment.find(params[:id])
    respond_with @comment
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    respond_with @comment
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    respond_with @comment
  end

  # POST /comments
  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:notice] = 'Comment was successfully created.'
    end
    respond_with(@comment)
  end

  # PUT /comments/1
  def update
    @comment = Comment.find(params[:id])
     if @comment.update_attributes(params[:comment])  
       flash[:notice] = 'Comment was successfully updated.'
     end  
     respond_with(@comment)
  end

  # DELETE /comments/1
  def destroy
    @comment = Comment.find(params[:id])
    flash[:notice] = 'Successfully destroyed comment.'
    respond_with @comment
  end
end
