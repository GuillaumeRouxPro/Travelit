require 'date'

class BookingsController < ApplicationController
  include Pundit
  skip_before_action :authenticate_user!

  def index
    @bookings_as_traveler = policy_scope(Booking.all.order(:start_date))
    @bookings_as_guide = policy_scope(Booking.joins(:tour).where(tours: { user_id: current_user.id }).order(:start_date))
    @bookings = @bookings_as_traveler.to_a + @bookings_as_guide.to_a
    @review = Review.new
  end

  def new
    @booking = Booking.new
    @flat = Tour.find(params[:tour_id])
    @booking.user = current_user
    @booking.flat = @flat
    authorize @booking
  end

  def create
    @tour = Tour.find(params[:booking][:tour_id])
    start_date, end_date = params[:booking][:date_range].split(" to ")
    @booking = Booking.new(tour_id: params[:booking][:tour_id])
    @booking.start_date = start_date
    @booking.end_date = end_date
    @booking.user = current_user
    @booking.tour = @tour
    @booking.confirmation = false
    authorize @booking
    check = check_available2(@booking)
    if check == false
      redirect_back(fallback_location: tour_path(@booking.tour), notice: "Ce tour est déjà réservé !")
    else @booking.save
      redirect_to bookings_path(@booking, @tour), notice: "La réservation a bien été effectuée !"

      # redirect_back(fallback_location: flat_path(@booking.flat), notice: "La réservation a bien été effectuée !")
    # else
    #   redirect_to tour_path(@tour), notice: "Vous ne pouvez pas demander la réservation à ces dates.", status: :unprocessable_entity
      # redirect_back(fallback_location: flat_path(@booking.flat), notice: "Cet appartement est déjà réservé à ces dates.")
    end
  end

  def edit
    @booking = Booking.find(params[:id])
    @tour = @booking.tour
    authorize @booking
  end

  def update
    @booking = Booking.find(params[:id])
    new_booking = Booking.new(booking_params)
    new_booking.tour = @booking.tour
    @tour = @booking.tour
    authorize @booking
    check = check_available(new_booking)
    if check
      redirect_back(fallback_location: tour_path(@booking.tour), notice: "Ce tour est déjà réservé à ces dates.")
    elsif @booking.update(booking_params)
      redirect_to tour_path(@tour), notice: "Votre réservation a bien été mise à jour !"
    else
      redirect_to tour_path(@tour), notice: "Vous ne pouvez pas demander la réservation à ces dates.", status: :unprocessable_entity

    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    @tour = @booking.tour
    @booking.destroy
    redirect_back(fallback_location: tour_path(@booking.tour), notice: "La réservation a bien été annulée !")
  end

  def accept
    @booking = Booking.find(params[:id])
    @tour = @booking.tour
    check = check_available(@booking)
    authorize @booking
    if !check
      @booking.update(confirmation: "accepted")
      redirect_back(fallback_location: tour_path(@booking.tour), notice: "La réservation a été acceptée !")
    else
      redirect_back(fallback_location: tour_path(@booking.tour), notice: "Vous ne pouvez pas accepter cette réservation")
    end
  end

  def refuse
    @booking = Booking.find(params[:id])
    @booking.update(confirmation: "refused")
    authorize @booking
    redirect_back(fallback_location: tour_path(@booking.tour), notice: "La réservation a été refusée !")
  end

  private

  def check_available2(booking)
    check = true # we assume that the booking is availaible at first
    # raise
    reservations = Booking.where(tour_id: booking.tour_id)
    if reservations.empty?
      check = true
    else
      check = false # no reservation availaible
    end
    check
  end
  def check_available(booking)
    check = false
    list_of_reservations = []
    reservations = Booking.where(tour: booking.tour, confirmation: "accepted")
    reservations.each do |reservation|
      list_of_reservations << [reservation.start_date, reservation.end_date]
    end

    if current_user != booking.tour.user then
      my_reservations = Booking.where(tour: booking.tour, confirmation: "pending", user: current_user)
      my_reservations.each do |reservation|
        list_of_reservations << [reservation.start_date, reservation.end_date]
      end
    end
    # raise
    list_of_reservations.each do |reservation|
      if (booking.start_date > reservation[0] && booking.start_date < reservation[1]) || (booking.end_date > reservation[0] && booking.end_date < reservation[1]) || (booking.start_date <= reservation[0] && booking.end_date >= reservation[1])
        check = true
        break
      end
    end

    return check
  end

  def booking_params
    params.require(:booking).permit(:date_range , :tour_id)
  end
end
