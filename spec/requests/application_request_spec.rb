require 'rails_helper'

RSpec.describe "ApplicationController", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) {create(:user)}
  
  it 'after sign in' do 
    sign_in user
    get sign_in_url

    expect(response).to redirect_to(feed_url)  
  end

  it 'after sign out' do 
    get feed_url

    expect(response).to redirect_to('/')  
  end
end
