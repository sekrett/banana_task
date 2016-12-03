require 'rails_helper'

describe API::V1::CommentsController, type: :controller do
  render_views
  before(:all) do
    @post = create(:post)
    2.times { create(:comment, post: @post) }
  end

  context 'as guest' do
    it "index action should render index template" do
      get :index, params: { post_id: @post.id }, format: 'json'
      expect(response).to render_template(:index)
    end
  end

  context 'as user' do
    login_user Comment

    it "create action should render new template when model is invalid" do
      expect_any_instance_of(Comment).to receive(:valid?).and_return(false)
      post :create, params: { post_id: @post.id, comment: attributes_for(:comment) }, format: 'json'
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "create action should redirect when model is valid" do
      expect_any_instance_of(Comment).to receive(:valid?).and_return(true)
      post :create, params: { post_id: @post.id, comment: attributes_for(:comment) }, format: 'json'
      expect(response).to have_http_status(:created)
    end
  end
end
