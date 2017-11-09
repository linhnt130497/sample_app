class UsersController < ApplicationController
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
      flash[:success] = t "well_come"
      redirect_to @user
    else
      flash[:error] = t "cannot_create"
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]

    return if @user
      flash[:danger] = t("no_user")
        redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
