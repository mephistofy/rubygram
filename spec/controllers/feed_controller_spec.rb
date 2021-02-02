# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedController, type: :controller do
  let(:user) { create(:user) }

  subject { get :index }

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]

    sign_in user
  end

  describe 'index' do
    it 'must render feed page' do
      subject

      expect(response).to render_template('index')
    end
  end
end
