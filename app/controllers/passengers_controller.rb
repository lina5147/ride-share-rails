class PassengersController < ApplicationController

  def index
    @passengers = Passenger.all.order(:id)
  end

  def show
    passenger_id = params[:id].to_i
    @passenger = Passenger.find_by(id: passenger_id)

    if @passenger.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
      return
    end

  end

  def new
    @passenger = Passenger.new
  end

  def create
    @passenger = Passenger.new(passenger_params)

    if @passenger.save
      redirect_to passenger_path(@passenger.id)
      return
    else
      render :new
      return
    end

  end

  def edit
    passenger_id = params[:id]
    @passenger = Passenger.find_by(id: passenger_id)

    if @passenger.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
      return
    end
  end

  def update
    passenger_id = params[:id]
    @passenger = Passenger.find_by(id: passenger_id)

    if @passenger.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
      return
    elsif @passenger.update(passenger_params)
      redirect_to passenger_path(@passenger.id)
      return
    else
      render :edit
      return
    end
  end

  def destroy
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      render file: "#{Rails.root}/public/404.html", status: :not_found
      return
    end

    @passenger.trips.delete_all

    if @passenger.destroy
      redirect_to passengers_path
      return
    else #if .destroy fails
      redirect_to passenger_path(@passenger.id)
      return
    end
  end

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_number)
  end

end
