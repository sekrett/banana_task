require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  render_views
  before(:all) do
    @post = create(:post)
    2.times { create(:comment, post: @post) }
  end

  context 'as user' do
    login_user Comment

    it "edit action should Comment edit template" do
      get :edit, params: { post_id: @post.id, id: Comment.first }
      expect(response).to render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      expect_any_instance_of(Comment).to receive(:valid?).and_return(false)
      put :update, params: { post_id: @post.id, id: Comment.first, comment: attributes_for(:comment) }
      expect(response).to render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      expect_any_instance_of(Comment).to receive(:valid?).and_return(true)
      put :update, params: { post_id: @post.id, id: Comment.first, comment: attributes_for(:comment) }
      expect(response).to redirect_to(post_url(Post.first))
    end

    it "destroy action should destroy model and redirect to index action" do
      comment = Comment.first
      delete :destroy, params: { post_id: @post.id, id: comment }
      response.should redirect_to(post_url(@post))
      expect(Comment.exists?(comment.id)).to be(false)
    end
  end
end
