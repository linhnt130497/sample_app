class UsersController < ApplicationController
  before_action :logged_in_user, :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  before_action :user_action, only: %i(show edit)
  def index
    @users = User.select_name_email.order_by_date.paginate page: params[:page],
      per_page: Settings.users_controller.for_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = t "check_activate"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    return if @user
    flash[:danger] = t "no_user"
    redirect_to root_url
  end

  def edit;  end

  def update
    @user = User.find_by id: params[:id]

    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find_by(params[:id]).destroy
    flash[:success] = t "user_deleted"
    redirect_to users_url
  end

  private

  def user_params
  params.require(:user).permit :name, :email, :password,
    :password_confirmation
  end

  def logged_in_user
    return if logged_in?
      store_location
      flash[:danger] = t ".please_log_in"
      redirect_to login_url
  end

  def correct_user
    @user = User.find_by params[:id]
    redirect_to root_url unless current_user.current_user? @user
  end

  def verify_admin!
    redirect_to root_url unless current_user.admin?
  end

  def user_action
    @user = User.find_by id: params[:id]
  end
end
