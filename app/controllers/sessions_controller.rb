class SessionsController < ApplicationController
  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
    		log_in(@user)
    		remember @user if params[:session][:remember_me] == '1'
    		redirect_back_or @user
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_path
      end
  	else
  		flash.now[:danger] = "Invalid email/password combination!"
  		render :new
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_path
  end
  
end
