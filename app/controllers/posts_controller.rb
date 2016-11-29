class PostsController < ApplicationController
  def index
    @posts = Post.order('published_at DESC')
    @posts = @posts.where(user_id: params[:user_id]) if params[:user_id]
  end

  def show
    @post = current_resource
  end

  def new
    @post = Post.new
  end

  def edit
    @post = current_resource
  end

  def create
    @post = Post.new(permitted_params)
    @post.user = current_user
    if @post.save
        redirect_to posts_path, notice: t('flash.post.create')
    else
      render :new
    end
  end

  def update
    @post = current_resource
    if @post.update(permitted_params)
      redirect_to posts_path, notice: t('flash.post.update')
    else
      render :edit
    end
  end

  def destroy
    @post = current_resource
    @post.destroy
    redirect_to posts_path, notice: t('flash.post.destroy')
  end
end
