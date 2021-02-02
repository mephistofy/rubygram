# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FollowController, type: :controller do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user1]

    sign_in user1
  end

  describe 'index' do
    let(:show_params1) { { method: 'followers', user_id: user2.id } }
    let(:show_params2) { { method: 'following', user_id: user2.id } }
    let(:show_params3) { { method: 'fdfdf', user_id: user2.id } }

    context 'followers' do
      subject { get :index, params: show_params1 }

      it 'get' do
        subject

        expect(response).to render_template('index')
      end
    end

    context 'following' do
      subject { get :index, params: show_params2 }

      it 'get' do
        subject

        expect(response).to render_template('index')
      end
    end

    context 'unknown method' do
      subject { get :index, params: show_params3 }

      it 'redirect' do
        subject

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'create' do
    let(:create_params1) { { user_id: user2.id } }
    let(:create_params2) { { user_id: user1.id } }

    context 'follow' do
      it 'succesful' do
        post :create, params: create_params1

        expect(response).to redirect_to(controller: 'user', action: 'show', user_id: user2.id)
      end

      it 'failed if the same as user' do
        post :create, params: create_params2

        expect(response).to have_http_status(302)
      end
    end

    context 'unfollow' do
      it 'succesful' do
        2.times do
          post :create, params: create_params1
        end

        expect(response).to redirect_to(controller: 'user', action: 'show', user_id: user2.id)
      end
    end
  end

  describe 'find user' do
    let(:show_params) { { method: 'fdfdf', user_id: user2.id + 1 } }

    context 'user' do
      subject { get :index, params: show_params }

      it 'not found' do
        subject

        expect(response).to have_http_status(302)
      end
    end
  end
end
