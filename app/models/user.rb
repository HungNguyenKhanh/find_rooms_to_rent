class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :rooms
  has_many :reservations

  has_many :guest_reviews, class_name: GuestReview.name, foreign_key: :guest_id
  has_many :host_reviews, class_name: HostReview.name, foreign_key: :host_id

  before_save{self.email = email.downcase}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true,
    length: {maximum: Settings.user.name.MAX_LENGTH}
  validates :email, presence: true,
    length: {maximum: Settings.user.email.MAX_LENGTH},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true, allow_nil: true,
    length: {minimum: Settings.user.password.MIN_LENGTH}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def from_omniauth auth
      user = User.where(email: auth.info.email).first
      if user
        return user
      else
        where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.email = auth.info.email
          user.password = SecureRandom.hex(6) if user.new_record?
          user.name = auth.info.name
          user.image = auth.info.image
          user.uid = auth.uid
          user.provider = auth.provider
          user.save!
        end
      end
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end
end
