class UsersController < ApplicationController
  before_action :logged_in_user, :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

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
      log_in @user
      flash[:success] = t "well_come"
      redirect_to @user
    else
      flash[:danger] = t ".cannot_create"
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t "no_user"
    redirect_to root_url
  end

  def edit
    @user = User.find_by params[:id]
  end

  def update
    @user = User.find_by params[:id]

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
    unless logged_in?
      store_location
      flash[:danger] = t ".please_log_in"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
