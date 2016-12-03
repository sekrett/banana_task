class API::V1::CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @comments = Post.find(params[:post_id]).comments.order('created_at DESC')
  end

  def create
    @comment = Comment.new(permitted_params)
    @comment.post_id = params[:post_id]
    @comment.user = current_user

    if @comment.save
      render :show, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = current_resource
    @comment.destroy
    head :no_content
  end
end
