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
    end

    if @review.new
      redirect_to root_path, notice: "Your review has been created!"
    else
      render 'tours/show', status: :unprocessable_entity
    end


    if @review.new
      redirect_to root_path, notice: "Your review has been created!"
    else
      # Gérez les erreurs de validation
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating, :booking_id, :user)
  end
end
