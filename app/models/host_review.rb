class HostReview < Review
  belongs_to :host, class_name: User.name
  scope :reviewed, ->(reservation_id, guest_id){
    where reservation_id: reservation_id, guest_id: guest_id}
end
