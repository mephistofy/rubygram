# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  before_action :find_user, only: :create

  def new
  end

  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user

      redirect_to feed_url
    else
      @error = 'Wrong email or password'

      render 'new'
    end
  end

  def destroy
    super
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end

  def find_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])

    if @user.nil?
      @error = 'Wrong email or password'

      render 'new'
    end
  end
end
