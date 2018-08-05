class GuestReviewsController < ApplicationController
  before_action :check_reservation, :has_reviewed?, only: [:create]

  def create
    @guest_review = current_user.guest_reviews.create guest_review_params
    return flash[:alert] = t("noti_error") unless @guest_review
    flash[:success] = t "noti_create_review"
    redirect_back fallback_location: request.referer
  end

  def destroy
    @guest_review = Review.find_by id: params[:id]
    unless @guest_review
      flash[:alert] = t "noti_not_found"
      return redirect_back fallback_location: request.referer
    end
    return flash[:alert] = t("noti_error") unless @guest_review.destroy
    flash[:success] = t "noti_removed"
    redirect_back fallback_location: request.referer
  end

  private

  def guest_review_params
    params.require(:guest_review).permit :comment,
      :star, :room_id, :reservation_id, :host_id
  end

  def check_reservation
    @reservation = Reservation.check_guest_reservation(
      guest_review_params[:reservation_id],
      guest_review_params[:room_id]
    ).first
    return unless @reservation.present? &&
                  @reservation.room.user.id !=
                  guest_review_params[:host_id].to_i
    flash[:alert] = t "noti_reservation_not_found"
  end

  def has_reviewed?
    @has_reviewed = GuestReview.reviewed(@reservation.id,
      guest_review_params[:host_id]).first
    return if @has_reviewed.present?
    flash[:alert] = t "noti_reviewed_reservation"
    redirect_back fallback_location: request.referer
  end
end
