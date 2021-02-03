# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentController, type: :controller do
  let(:user1) { create(:user) }
  let(:comment) { create(:comment) }

  let(:set_comment_author) { comment.author_id = user1.id }
  let(:save_comment) { comment.save }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]

    sign_in user1
  end

  describe 'show' do
    let(:params) { { comment_id: comment.id } }

    subject { get :show, params: params }

    it 'must render show page' do
      subject

      expect(response).to render_template('show')
    end
  end

  describe 'create' do
    let(:postt) { create(:post) }

    subject { post :create, params: params }

    context 'must SUCCEED and redirect to post page' do
      let(:params) { { comment_form: { comment: 'fsdfdsf', post_id: postt.id } } }

      it 'if evything is ok' do
        comment.post_id = postt.id
        comment.author_id = user1.id

        subject

        expect(response).to redirect_to(controller: 'post', action: 'show', id: comment.post_id)
      end
    end

    context 'must FAIL and redirect to post page' do
      let(:params) { { comment_form: { comment: nil, post_id: postt.id } } }

      it 'if comment param is nil' do
        comment.post_id = postt.id
        comment.author_id = user1.id

        subject

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'update' do
    let(:postt) { create(:post) }

    subject { expect(response).to have_http_status(:found) }

    context 'must fail and redirect ' do
      let(:params_unknown_comment) { { comment: { comment_id: comment.id + 1, new_comment: 'fdfdfd', post_id: postt.id } } }
      let(:params_nil_new_comment) { { comment: { comment_id: comment.id, new_comment: nil, post_id: postt.id } } }

      it 'if comment not found' do
        put :update, params: params_unknown_comment

        subject
      end

      it 'if author is not the same' do
        comment.author_id = user1.id + 1

        put :update, params: params_nil_new_comment

        subject
      end

      it 'if comment not saved' do
        set_comment_author
        save_comment

        put :update, params: params_nil_new_comment

        subject
      end
    end

    context 'must succeed' do
      before(:each) do
        set_comment_author
        save_comment
      end

      let(:params) { { comment: { comment_id: comment.id, new_comment: 'fdfdfdf', post_id: postt.id } } }

      it 'if everythinh is ok' do
        put :update, params: params

        subject
      end
    end
  end

  describe 'delete' do
    let(:postt) { create(:post) }

    let(:params2) { { comment_id: comment.id, post_id: postt.id } }

    subject { expect(response).to have_http_status(:found) }

    context 'must fail and redirect if ' do
      let(:params1) { { comment_id: comment.id + 1, post_id: postt.id } }

      it 'comment not found' do
        delete :destroy, params: params1

        subject
      end

      it 'author is not the same' do
        comment.author_id = user1.id + 1

        delete :destroy, params: params2

        subject
      end
    end

    context 'must succeed and redirect if ' do
      it 'everything is ok' do
        set_comment_author
        save_comment

        delete :destroy, params: params2

        subject
      end
    end
  end
end
