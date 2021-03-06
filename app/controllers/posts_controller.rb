class PostsController < ApplicationController
  include Pagination::ControllerExt

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.order('published_at DESC')
    if params[:user_id]
      @posts = @posts.where(user_id: params[:user_id])
    else
      @posts = @posts.published
    end
    @posts = @posts.tagged_with(params[:tag]) if params[:tag]
    @posts = paginate(@posts, params[:page])
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(permitted_params)
    @post.user = current_user
    if @post.save
      redirect_to @post, notice: t('flash.post.create')
    else
      render :new
    end
  end

  def update
    if @post.update(permitted_params)
      redirect_to @post, notice: t('flash.post.update')
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: t('flash.post.destroy')
  end

  private
  def set_post
    @post = current_resource
  end
end
