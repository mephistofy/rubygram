# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LikeController, type: :controller do
  let(:user) { create(:user) }
  let(:postt) { create(:post) }
  let(:params) { { post_id: postt.id } }

  subject { post :create, params: params }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]

    sign_in user
  end

  describe 'create' do
    context 'create like' do
      it 'succesful' do
        postt.user_id = user.id

        subject

        expect(response).to redirect_to(controller: 'post', action: 'show', id: postt.id)
      end
    end

    context 'destroy like' do
      it 'succesful' do
        postt.user_id = user.id

        post :create, params: params

        subject

        expect(response).to redirect_to(controller: 'post', action: 'show', id: postt.id)
      end
    end

    context 'redirect if' do
      let(:params) { { post_id: postt.id + 1 } }

      it 'like not saved' do
        subject

        expect(response).to have_http_status(302)
      end
    end
  end
end
