class RegistrationController < ApplicationController
  before_action :user_exist?, only: :create

  def new
  end
  # POST /sign_up
  def create
      user = User.new(get_registration_params)

      if user.save!
        respond_to do |format|
            format.html {
              redirect_to sign_in_path
            }
            format.json {
              render json:{}, status: :created
            }
        end
      else
        @error = 'Internal Server Error'

        respond_to do |format|
            format.html {
              render 'new'
            }
            format.json {
              render json: { error: @error }, status: 500
            }
        end

      end
  end
   
  private
  def get_registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :avatar)
  end

  def user_exist?
    @user = User.find_by(email: params[:email])

    if @user != nil
      @error = 'User already exists!'

      respond_to do |format|
        format.html {
          render 'new'
        }
        format.json {
          render json: { error: @error }, status: 400
        }
      end
    end  
  end
end
