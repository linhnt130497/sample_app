class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]

    return if @user
      flash[:danger] = t("no_user")
        redirect_to root_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      redirect_to @user
    else
      render :new
    end
  end
  
  def index
    @users = User.select_name_email
  end

  private
  
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
