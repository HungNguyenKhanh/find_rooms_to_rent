class Reservation < ApplicationRecord
  scope :most_recent, ->{order start_date: :asc}

  scope :preload_list, lambda do |date|
    where "start_date >= ? or end_date >= ?", date, date
  end

  scope :conflict_list, lambda do |start_date, end_date|
    where "? < start_date AND end_date < ?", start_date, end_date
  end

  scope :check_guest_reservation, lambda do |reservation_id, room_id|
    where id: reservation_id, room_id: room_id
  end

  scope :check_host_reservation, lambda do |reservation_id, room_id, guest_id|
    where id: reservation_id, room_id: room_id, user_id: guest_id
  end

  belongs_to :user
  belongs_to :room
end
