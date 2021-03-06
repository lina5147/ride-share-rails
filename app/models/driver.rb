class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true

  validates :vin, presence: true

  def total_earnings
    if self.trips.empty?
      return 0
    else
      sum_revenue = self.trips.sum { |trip| trip.cost > 1.65 ? 0.8 * (trip.cost - 1.65) : trip.cost }

      return sum_revenue.round(2)
    end
  end

  def average_rating
    total_trips = trips.length
    if total_trips > 0
      return self.trips.sum { |trip| trip.rating.to_f }/total_trips
    else
      return 0
    end
  end

  def make_unavailable
    self.availability_status = false
    self.save
    return
  end

  def make_available
    self.availability_status = true
    self.save
    return
  end

  # TODO: implement logic for what to return in cases of no available drivers
  def self.next_available
    available_drivers = Driver.all.filter { |driver| driver.availability_status == true }
    new_drivers = available_drivers.filter { |driver| driver.trips.empty? }
    if new_drivers.length > 0
      return new_drivers.first
    else
      return available_drivers.filter { |driver| driver.trips.any? }.max do |driver|
        sorted_trips = driver.trips.sort_by { |trip| trip.date }
        Time.now.to_date - sorted_trips.last.date
      end
    end
  end

end
