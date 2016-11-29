class PostsController < ApplicationController
  def index
    @posts = Post.order('published_at DESC')
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
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
    @post = Post.find(params[:id])
    if @post.update(permitted_params)
      redirect_to posts_path, notice: t('flash.post.update')
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: t('flash.post.destroy')
  end
end
