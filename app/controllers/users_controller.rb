class UsersController < ApplicationController
  before_action :get_user, only: %i(show edit update destroy)
  before_action :verified_user, only: %i(edit update)

  def show
    @guest_reviews = Review.guest_review @user.id
    @host_reviews = Review.host_review @user.id
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:notice] = t "noti_saved"
    else
      flash[:alert] = t "noti_error"
    end
    redirect_back fallback_location: request.referer
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :phone_number
  end

  def get_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:alert] = t "noti_not_found"
    redirect_to root_url
  end

  def verified_user
    redirect_to root_url unless current_user? @user
  end
end
