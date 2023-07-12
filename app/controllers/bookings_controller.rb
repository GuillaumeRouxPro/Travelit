require 'date'

class BookingsController < ApplicationController
  include Pundit

  def index
    @bookings_as_traveler = policy_scope(Booking.where(user_id: current_user).order(:start_date))
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
    start_date = params[:booking][:Start]
    end_date = params[:booking][:End]
    @booking = Booking.new(tour_id: params[:booking][:tour_id])
    @booking.start_date = start_date
    @booking.end_date = end_date
    @booking.user = current_user
    @booking.tour = @tour
    @booking.confirmation = false
    authorize @booking
    @booking.save
    @tour.bookings << @booking
    @tour.save
    redirect_to bookings_path, notice: "The reservation has been submitted !"
  end

  def edit
    @booking = Booking.find(params[:id])
    @tour = @booking.tour
    authorize @booking
  end

  def update
    @booking = Booking.find(params[:id])
    authorize @booking
    check = check_dates(booking_params[:start_date], booking_params[:end_date])
    if check[:success]
      @booking.update(booking_params)
      flash[:notice] = check[:message]
      redirect_to bookings_path
    else
      flash[:error] = check[:message]
      redirect_to bookings_path, status: :unprocessable_entity
    end
  end


  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.destroy
    redirect_back(fallback_location: bookings_path)
  end

  def accept_refuse
    @booking = Booking.find(params[:update][:booking_id].to_i)
    authorize @booking
    if params[:commit] == "Accept"
      @booking.update(confirmation: true)
      redirect_to my_tours_tours_path, notice: "The reservation has been accepted !"
    else
      @booking.destroy
      redirect_to my_tours_tours_path, notice: "The booking has been deleted"
    end
  end

  private

  def check_dates(start, end_d)
    start = Date.parse(start)
    end_d = Date.parse(end_d)

    if start < Date.today || end_d < Date.today
      { success: false, message: "End date or Start dates can't be in the past." }
    elsif end_d < start
      { success: false, message: "End date Must be later than start date." }
    else
      { success: true, message: "Your reservation has been updated !" }
    end
  end
  def check_available2(booking)
    check = true # we assume that the booking is availaible at first
    reservations = Booking.where(user_id: booking.user)
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
    params.require(:update).permit(:start_date, :end_date)
  end

end
