class Room < ApplicationRecord
  belongs_to :user
  has_many :photos
  has_many :reservations
  has_many :guest_reviews

  scope :activated, ->{where(active: true)}
  scope :by_prices, ->(min_p, max_p){where(price: min_p..max_p) if
    min_p.present? && max_p.present?}
  scope :filter_by, ->(key, value){where("#{key}": value)}
  scope :near_by, ->(address, km){near(address, km, order: "distance") if 
    address.present?}

  delegate :name, to: :user, allow_nil: true, prefix: true

  validates :home_type, presence: true
  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def cover_photo size
    return photos[0].image.url size unless photos.empty?
    "blank.jpg"
  end

  def average_rating
    guest_reviews.count == 0 ? 0 : guest_reviews.average(:star).round(2).to_i
  end

  def available? start_date, end_date
    reservations.where(
      "(? <= start_date AND start_date <= ?)
      OR (? <= end_date AND end_date <= ?)
      OR (start_date < ? AND ? < end_date)",
      start_date, end_date,
      start_date, end_date,
      start_date, end_date
    ).limit(1).length == 0
  end
end
