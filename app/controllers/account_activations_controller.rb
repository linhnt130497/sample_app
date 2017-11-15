class AccountActivationsController < ApplicationController
   def edit
    user = User.find_by email: params[:email]

    if user && !user.activated? && user.authenticated? :activation, params[:id]
      user.update_attributes :activated, true
      user.update_attributes :activated_at, Time.zone.now
      log_in user
      flash[:success] = t "account_active"
      redirect_to user
    else
      flash[:danger] = t "invalid_link"
      redirect_to root_url
    end
  end
end
