class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # debuggerclear
  end

  def new
  end
end
