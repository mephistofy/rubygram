# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentController, type: :controller do
  let(:user1) { create(:user) }
  let(:comment) { create(:comment) }

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

    context 'succesful action' do
      let(:params) { { comment_form: { comment: 'fsdfdsf', post_id: postt.id } } }

      it 'must redirect to post page' do
        comment.post_id = postt.id
        comment.author_id = user1.id

        subject

        expect(response).to redirect_to(controller: 'post', action: 'show', id: comment.post_id)
      end
    end

    context 'failed action' do
      let(:params) { { comment_form: { comment: nil, post_id: postt.id } } }

      it 'must redirect to post page' do
        comment.post_id = postt.id
        comment.author_id = user1.id

        subject

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'update' do
    let(:postt) { create(:post) }

    context 'action' do
      let(:params1) { { comment: { comment_id: comment.id + 1, new_comment: 'fdfdfd', post_id: postt.id } } }
      let(:params2) { { comment: { comment_id: comment.id, new_comment: 'fdfdfd', post_id: postt.id } } }

      it 'must fail and redirect if comment not found' do
        put :update, params: params1

        expect(response).to have_http_status(302)
      end

      it 'must fail and redirect if author is not the same' do
        comment.author_id = user1.id + 1

        put :update, params: params2

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'delete' do
    let(:postt) { create(:post) }

    context 'action' do
      let(:params1) { { comment_id: comment.id + 1, post_id: postt.id } }
      let(:params2) { { comment_id: comment.id, post_id: postt.id } }

      it 'must fail and redirect if comment not found' do
        delete :destroy, params: params1

        expect(response).to have_http_status(302)
      end

      it 'must fail and redirect if author is not the same' do
        comment.author_id = user1.id + 1

        delete :destroy, params: params2

        expect(response).to have_http_status(302)
      end
    end
  end
end
