require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before(:each) do 
    @request.env["devise.mapping"] = Devise.mappings[:user] 
  end

  describe 'new' do
    subject { get :new }
        
    it 'is expected to render new template' do
      subject

      expect(response).to render_template('new') 
    end
  end

  describe 'destroy' do
    let(:user) { create(:user) }
    let(:params) { 
        { 
          user: { 
                  email: user.email,
                  password: 'password',
                }
        }
      }

    before { post :create, params: params }

    subject { delete :destroy}
          
    it 'is expected to redirect to sign in' do
      subject 

      expect(response).to redirect_to('/sign_in') 
    end
  end
    
  describe 'create' do
    let(:user) { create :user }
    
    context 'valid action' do
      let(:params) { 
                     { 
                       user: { 
                               email: user.email,
                               password: 'password',
                             }
                     }
                   }

      subject { post :create, params: params}
    
      it 'must redirect to feed page' do
        subject
    
        expect(response).to redirect_to("/feed") 
      end
    end
    
    context 'render new' do
      let(:params) { 
                     { 
                       user: { 
                               email: user.email,
                               password: '12345fsdf6',
                               password_confirmation: '1234fdsffff56' 
                             }
                     } 
                   }
      let(:wrong_params) { 
                    { 
                      user: { 
                              email: 'sdfsdf@fdfsd',
                              password: '12345fsdf6',
                              password_confirmation: '1234fdsffff56' 
                            }
                    } 
                  }
      it 'if user exists with params email' do
        post :create, params: params
    
        expect(response).to render_template('new')
      end 
    
      it 'if was not saved' do
        post :create, params: wrong_params
    
        expect(response).to render_template('new')
      end 
    end
  end
end
