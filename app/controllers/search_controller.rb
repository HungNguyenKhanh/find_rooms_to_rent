class SearchController < ApplicationController
  def index
    @rooms = Room.activated.near_by(params[:search_address], 5)
      .by_prices(params[:price_min], params[:price_max])
    filtering_params(params).each do |key, value|
      @rooms = @rooms.filter_by(key, value) if value.present?
    end

    @arr_rooms = @rooms.to_a
    only_available_rooms
  end

  private

  def filtering_params params
    params.slice :room_type, :home_type, :accommodate, :bed_room, :bath_room,
      :is_tv, :is_air, :is_kitchen, :is_heating, :is_internet
  end

  def only_available_rooms
    return unless params[:start_date].present? && params[:end_date].present?
    start_date = Date.parse params[:start_date]
    end_date = Date.parse params[:end_date]
    @rooms.each do |room|
      @arr_rooms.delete room unless room.available? start_date, end_date
    end
  end
end
