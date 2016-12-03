require 'rails_helper'

describe PostsController, type: :controller do
  render_views
  before(:all) do
    2.times { create(:post) }
  end

  context 'as guest' do
    it "index action should render index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "show action should render index template" do
      get :show, params: { id: Post.first }
      expect(response).to render_template(:show)
    end
  end

  context 'as user' do
    login_user Post

    it "new action should render new template" do
      get :new
      expect(response).to render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      expect_any_instance_of(Post).to receive(:valid?).and_return(false)
      post :create, params: { post: attributes_for(:post) }
      expect(response).to render_template(:new)
    end

    it "create action should redirect when model is valid" do
      expect_any_instance_of(Post).to receive(:valid?).and_return(true)
      post :create, params: { post: attributes_for(:post) }
      expect(response).to redirect_to(post_url(Post.last))
    end

    it "edit action should render edit template" do
      get :edit, params: { id: Post.first }
      expect(response).to render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      expect_any_instance_of(Post).to receive(:valid?).and_return(false)
      put :update, params: { id: Post.first, post: attributes_for(:post) }
      expect(response).to render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      expect_any_instance_of(Post).to receive(:valid?).and_return(true)
      put :update, params: { id: Post.first, post: attributes_for(:post) }
      expect(response).to redirect_to(post_url(Post.first))
    end

    it "destroy action should destroy model and redirect to index action" do
      post = Post.first
      delete :destroy, params: { id: post }
      response.should redirect_to(posts_url)
      expect(Post.exists?(post.id)).to be(false)
    end
  end
end
