class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    if @comment.update(permitted_params)
      redirect_to @post, notice:  t('flash.comment.update')
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: t('flash.comment.destroy')
  end

  private
  def set_comment
    @comment = current_resource
  end

  def set_post
    @post = @comment.try(:post) || Post.find(params[:post_id])
  end
end
