require 'date'

class ToursController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_tour, only: [:show, :edit, :update, :destroy]

  def index
    @tours = policy_scope(Tour)
    range = params.dig(:tour, :range)&.to_i || 10
    lieu = params.dig(:tour, :lieu)

    if lieu.present?
      @tours = Tour.near("%#{lieu}%", range)
    end

    @markers = @tours.geocoded.map do |flat|
      {
        lat: tour.latitude,
        lng: tour.longitude,
        info_window: render_to_string(partial: "index_info_window", locals: { tour: tour }),
        marker_html: render_to_string(partial: "index_marker", locals: { tour: tour })
      }
    end
  end

  def show
    @review = Review.new
    @bookings = Booking.all

    @my_bookings_of_this_tour = @bookings.order(:start_date).select { |booking| booking.user == current_user && booking.tour == @tour }
    # Je veux afficher les réservations d'autres personnes de mon appartement si je suis sur la page de mon appartement
    # Seulement pour le propriétaire de l'appartement
    @other_bookings_for_my_tour = @bookings.order(:start_date).select { |booking| @tour.user == current_user && booking.flat == @flat }
    @past_bookings = @my_bookings_of_this_tour.select { |booking| booking.end_date <= Date.today }
    @reviews = @tour.reviews
    @number_of_reviews = @reviews.size
    @average_rating = @reviews.average(:rating)
    @tour_hobbies = @tour.hobbies
    @marker = [{ lat: @tour.latitude,
                 lng: @tour.longitude,
                 info_window: render_to_string(partial: "show_info_window", locals: { tour: @tour }),
                 marker_html: render_to_string(partial: "show_marker", locals: { tour: @tour }) }]
    @booking = Booking.new
  end

  def new
    @tour = Tour.new
    authorize @tour
  end

  def create
    @tour = Tour.new(params_tour)
    @tour.user = current_user
    @tour.hobbies = Hobby.where(id: params[:tour][:hobby_ids])
    params[:tour][:photos].each do |photo|
      @tour.photos.attach(photo)
    end
    authorize @tour
    if @tour.save
      redirect_to tours_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @tour.hobbies = Hobby.where(id: params[:tour][:hobby_ids])

    params[:tour][:photos].each do |photo|
      @tour.photos.attach(photo)
    end

    if @tour.update(params_tour)

      redirect_to tour_path(@tour)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tour.destroy
    redirect_to tours_path
  end

  private

  def set_flat
    @tour = Tour.find(params[:id])
    authorize @tour
  end

  def params_tour
    params.require(:tour).permit(:name, :address, :description, :price, :number_of_guests, hobby_ids: [], photos: [])
  end

  def search
    @tours = Tour.search(params[:hobbies], params[:city], params[:date], params[:num_travelers])
  end

end
