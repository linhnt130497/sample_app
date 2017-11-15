class UsersController < ApplicationController
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
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
    @user = User.find_by params[:id]
    @microposts = @user.microposts.paginate page: params[:page]
  end

  def edit;  end

  def update
    @user = User.find_by id: params[:id]

    return if @user
      flash[:danger] = t "no_user"
        redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
    :password_confirmation
  end

  def correct_user
    @user = User.find_by params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def user_action
    @user = User.find_by id: params[:id]
  end

end
