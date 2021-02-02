require 'rails_helper'

RSpec.describe UserController, type: :controller do
  let(:user) { create(:user) }
  
  before(:each) do 
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user 
  end
    
  describe 'index' do
    context 'all users' do
      let(:params) {
            {
              search: 'sdfsdfsd'
            }
      }
      subject { get :index, params: params }
                
      it 'is expected to render index template' do
        subject
        
        expect(response).to render_template('index') 
      end 
    end

    context 'current_user' do
      let(:params) {
            {
              search: user.email
            }
      }
      subject { get :index, params: params }

      it 'is expected to redirect to current user page' do
        subject
        
        expect(response).to redirect_to(:controller=>'user',:action=>'show',:user_id=>user.id) 
      end
    end
  end

  describe 'show' do
    context 'user found' do    
      subject { get :show, params: {user_id: user.id} }
    
      it 'is expected to render show template' do
        subject
            
        expect(response).to render_template('show') 
      end 
    end

    context 'user not ound' do    
      subject { get :show, params: {user_id: user.id + 1} }
    
      it 'is expected to render show template' do
        subject
            
        expect(response).to redirect_to(:controller=>'feed',:action=>'index')
      end 
    end
  end
end
