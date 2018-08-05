class RoomsController < ApplicationController
  before_action :load_room, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorised?, only: [:update]

  def show
    unless @room&.active then
      flash[:alert] = t("noti_not_found")
      redirect_to root_path
    end
    @photos = @room.photos
    @guest_reviews = @room.guest_reviews
    @near_by_rooms = @room.nearbys(10).activated
  end

  def index
    @rooms = current_user.rooms
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build room_params
    if @room.save
      redirect_to listing_room_path(@room), notice: t("noti_saved")
    else
      flash[:alert] = t("noti_error")
      render :new
    end
  end

  def update
    if @room.update room_params
      if room_params[:active] == "true"
        flash[:notice] = t("noti_saved")
        redirect_to room_path
      else
        redirect_back fallback_location: request.referer
      end
      flash[:notice] = t("noti_saved")
    else
      flash[:alert] = t("noti_error")
      redirect_back fallback_location: request.referer
    end
  end

  def photo_upload
    @photos = @room.photos
  end

  def preload
    today = Date.today
    reservations = @room.reservations.preload_list today
    render json: reservations
  end

  def preview
    start_date = Date.parse params[:start_date]
    end_date = Date.parse params[:end_date]
    output = {
      conflict: is_conflict(start_date, end_date, @room)
    }
    render json: output
  end

  private
  def load_room
    @room = Room.find_by id: params[:id]
    return if @room
    flash[:alert] = t("noti_not_found")
    redirect_to new_room_path
  end

  def room_params
    params.require(:room).permit :home_type, :room_type, :accommodate,
      :bed_room, :bath_room, :name, :summary, :address, :is_tv, :is_kitchen,
      :is_air, :is_heating, :is_internet, :price, :active
  end

  def is_authorised?
    redirect_to root_path, alert: t("noti_permission") unless
    current_user.id == @room.user_id
  end

  def is_conflict start_date, end_date, room
    check = room.reservations.conflict_list start_date, end_date
    check.size > 0? true : false
  end
end
