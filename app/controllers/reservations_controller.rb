class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = current_user.rooms
  end

  def create
    room = Room.find_by id: params[:room_id]

    if current_user == room.user
      return redirect_back fallback_location: request.referer,
        alert: t("noti_self_book")
    end
    days = get_days

    @reservation = current_user.reservations.build reservation_params
    @reservation.room = room
    @reservation.price = room.price
    @reservation.total = room.price * days
    @reservation.save

    flash[:notice] = t "noti_book_success"
    redirect_to room
  end

  private
  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date)
  end

  def get_days
    start_date = Date.parse(reservation_params[:start_date])
    end_date = Date.parse(reservation_params[:end_date])
    ReservationsService.new(start_date, end_date).days
  end
end
