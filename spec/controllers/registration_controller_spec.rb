# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationController, type: :controller do
  describe 'new' do
    subject { get :new }

    it 'is expected to render new template' do
      subject

      expect(response).to render_template('new')
    end
  end

  describe 'create' do
    let(:params) {
      {
        user: {
          email: 'test@xxx',
          password: '12345688',
          password_confirmation: '12345688'
        }
      }
    }

    context 'valid action' do
      subject { post :create, params: params }

      it 'must redirect to sign in page' do
        subject

        expect(response).to redirect_to('/sign_in')
      end
    end

    context 'render new' do
      let(:wrong_params) {
        {
          user: {
            email: 'test@xxx',
            password: '12345fsdf6',
            password_confirmation: '1234fdsffff56'
          }
        }
      }

      subject { post :create, params: wrong_params }

      it 'if user was not saved' do
        subject

        expect(response).to render_template('new')
      end
    end
  end
end
