class SessionsController < Devise::SessionsController
  before_action :find_user, only: :create

  def new
  end

  def create 
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      
      respond_to do |format| 
        format.html {
          redirect_to my_posts_url
        }
        format.json {
          render json: { email: @user.email, id: @user.id }, status: :created
        } 
      end
    
    else
      @error =  'wrong email or password or both'

      respond_to do |format| 
        format.html {
          render 'new' 
        }
        format.json {
          render json: { error: @error }, status: :unauthorized
        }
      end
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
      @error =  'wrong email/username or password or both'

      respond_to do |format| 
        format.html {
          render 'new'
        }
        format.json {
          render json: { error: @error }, status: 404 #no such user
        } 
      end
    end
  end
end
