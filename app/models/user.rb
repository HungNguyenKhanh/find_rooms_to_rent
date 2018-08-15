class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  attr_accessor :remember_token

  has_many :rooms
  has_many :reservations

  has_many :guest_reviews, class_name: GuestReview.name, foreign_key: :guest_id
  has_many :host_reviews, class_name: HostReview.name, foreign_key: :host_id

  validates :name, presence: true,
    length: {maximum: Settings.user.name.MAX_LENGTH}

  class << self
    def from_omniauth auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name
        user.image = auth.info.image
        user.uid = auth.uid
        user.provider = auth.provider
        user.skip_confirmation!
      end
    end
  end
end
