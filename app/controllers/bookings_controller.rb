class BookingsController < ApplicationController
  before_action :find_user, only: :show
  before_action :find_planet, only: [:new, :create, :show, :confirm_booking]
  before_action :find_booking, only: [:edit, :update, :show, :destroy, :confirm_booking]

  def index
    my_planets = Planet.where(user_id: current_user.id)
    @my_planets_bookings = Booking.where(planet_id: my_planets.map(&:id))

    @my_booking_requests = Booking.where(user_id: current_user.id).order(status: :desc)
  end

  def show
  end

  def new
    @user = current_user
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.planet = @planet
    @booking.user = current_user
    if @booking.save
      @booking.save!
      redirect_to user_bookings_path(current_user)
    else
      render "form"
    end
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      flash[:success] = "Your booking was successfully updated"
      redirect_to booking_path(@booking)
    else
      flash[:error] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    if @booking.destroy
      flash[:success] = "Your booking has been deleted"
      redirect_to bookings_path
    else
      flash[:error] = "Something went wrong"
      redirect_to bookings_path
    end
  end

  def confirm_booking
    @booking.confirm
    redirect_to user_bookings_path(current_user)
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :message)
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_planet
    @planet = Planet.find(params[:planet_id])
  end

  def find_booking
    @booking = Booking.find(params[:id])
  end
end
