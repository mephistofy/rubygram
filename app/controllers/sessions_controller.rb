class SessionsController < Devise::SessionsController
  before_action :find_user, only: :create

  def new
  end

  def create 
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      
      action = redirect_to feed_url
      data = { email: @user.email, id: @user.id }
      succesful_response(:created, action, data)

    else
      @error =  'Wrong email or password'

      action = render 'new'
      failed_response(@error, :unauthorized, action)
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

    if @user == nil
      @error =  'Wrong email or password'

      action = render 'new'
      failed_response(@error, :unauthorized, action)
    end
  end
end
