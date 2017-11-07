class UsersController < ApplicationController

  def show
  @user = User.find_by id: params[:id]
    unless @user
    flash[:danger] = "NIL"
    redirect_to root_url
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t("well_come")
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
      params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
    end
    
end
