class ReviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  include Pundit


  def index
    @reviews = Review.all
    authorize @review
  end

  def new
    @review = Review.new
    authorize @review
  end

  def create
    @tour = Tour.find(params[:tour_id])
    @review = Review.new(review_params)
    @review.user = current_user
    @review.booking_id = Booking.where(tour_id: params['tour_id'], user_id: current_user.id)[0].id
    authorize @review
    if @review.save
      redirect_to tour_path(params['tour_id']), notice: "La review a été créée avec succès."
    else # ATTENTION A CORRIGER, il n'y a pas les erreurs de validation
      render 'tours/show(@tour)', status: :unprocessable_entity
      # @bookings = policy_scope(Booking.where(user_id: current_user.id))
      # render 'bookings/index', status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating, :booking_id, :user)
  end
end
