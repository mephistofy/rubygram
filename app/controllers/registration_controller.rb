class RegistrationController < ApplicationController
  before_action :user_exist?, only: :create

  def new
  end
  # POST /sign_up
  def create
    user = User.new(get_registration_params)

    if user.save
      action = redirect_to sign_in_path
      data = nil

      succesful_response(:created, action, data)
    else
      @error = user.errors.full_messages
      action = render 'new'

      failed_response(@error, 500, action)
        
    end
  end

  def update
    respond_to do |format|
      format.html {
        
      }

      format.json {

      }
    end
  end
   
  private
  def get_registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :avatar)
  end

  def update_params_html
  end

  def update_params_json
  end

  def user_exist?
    @user = User.find_by(email: params[:email])

    if @user != nil
      @error = 'User already exists!'
      action = render 'new'

      failed_response(@error, 400, action)
    end  
  end
end
