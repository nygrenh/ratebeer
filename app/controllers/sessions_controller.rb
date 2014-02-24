class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user.nil? or not user.authenticate params[:password]
      redirect_to :back, notice: "username and password do not match"
    else
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    end
  end

  def create_fb
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to user, notice: "Welcome back!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end