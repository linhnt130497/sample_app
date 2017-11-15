class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      
      if user.activated?
        log_in user
        params[:session][:remember_me] == Settings.sessions_controller.num ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = t("account_active")
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash[:danger] = t "controllers.sessions_controller.notify_invalid"
      render :new
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
end
