# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostController, type: :controller do
  let(:user) { create(:user) }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]

    sign_in user
  end

  describe 'new' do
    subject { get :new }

    it 'is expected to render new template' do
      subject

      expect(response).to render_template('new')
    end
  end

  describe 'create' do
    context 'if succesful' do
      let(:params) { { post: { image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/ruby.jpg')) } } }

      subject { post :create, params: params }

      it 'must redirect to post' do
        subject

        expect(response).to redirect_to(assigns(:post))
      end
    end

    context 'must render new if fail' do
      let(:params) { { postt: { image: nil } } }
      let(:wrong_params) { { post: { image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/ruby.txt')) } } }

      it 'and no post or image param' do
        post :create, params: params

        expect(response).to render_template('new')
      end
      it 'and params are wrong' do
        post :create, params: wrong_params

        expect(response).to render_template('new')
      end
    end
  end

  describe 'show' do
    let(:post) { create(:post) }
    context 'if post found' do
      subject { get :show, params: { id: post.id } }

      it 'must render show template' do
        subject

        expect(response).to render_template('show')
      end
    end

    context 'if there are any errors' do
      let(:param_with_error) { { id: post.id, error: 'fsdfsdf' } }
      let(:param_with_invalid_post_number) { { id: post.id + 1, error: 'fsdfsdf' } }

      it 'must render error' do
        get :show, params: param_with_error

        expect(response).to have_http_status(:ok)
      end

      it 'must redirect to feed' do
        get :show, params: param_with_invalid_post_number

        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'destroy' do
    let(:post) { create(:post) }

    context 'must' do
      subject { delete :destroy, params: { id: post.id } }

      it 'redirect to index' do
        subject

        expect(response).to redirect_to(controller: 'user', action: 'show', user_id: user.id)
      end

      it 'delete post if current user' do
        post.user_id = user.id
        post.save

        subject

        expect(response).to redirect_to(controller: 'user', action: 'show', user_id: user.id)
      end
    end
  end
end
