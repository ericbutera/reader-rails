class SessionsController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]

  def new
    render :layout => "login"
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    render :layout => "login"
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end

