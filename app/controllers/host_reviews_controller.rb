class HostReviewsController < ApplicationController
  before_action :check_reservation, :has_reviewed?, only: [:create]

  def create
    @host_review = current_user.host_reviews.create host_review_params
    return flash[:alert] = t("noti_error") unless @host_review
    flash[:success] = t "noti_create_review"
    redirect_back fallback_location: request.referer
  end

  def destroy
    @host_review = Review.find_by id: params[:id]
    unless @host_review
      flash[:alert] = t "noti_not_found"
      return redirect_back fallback_location: request.referer
    end
    return flash[:alert] = t("noti_error") unless @host_review.destroy
    flash[:success] = t "noti_removed"
    redirect_back fallback_location: request.referer
  end

  private

  def host_review_params
    params.require(:host_review).permit :comment,
      :star, :room_id, :reservation_id, :guest_id
  end

  def check_reservation
    @reservation = Reservation.check_host_reservation(
      host_review_params[:reservation_id],
      host_review_params[:room_id],
      host_review_params[:guest_id]
    ).first
    return if @reservation.present?
    flash[:alert] = t "noti_reservation_not_found"
    redirect_back fallback_location: request.referer
  end

  def has_reviewed?
    @has_reviewed = HostReview.reviewed(@reservation.id,
      host_review_params[:guest_id]).first
    return if @has_reviewed.present?
    flash[:alert] = t "noti_reviewed_reservation"
    redirect_back fallback_location: request.referer
  end
end
