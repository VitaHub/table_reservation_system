class Table < ApplicationRecord
  belongs_to :restaurant
  validates :restaurant, :name, presence: true
  has_many :reservations

  def not_reserved_time(day)
    week_day = day.strftime("%a")
    restaurant_working_time = self.restaurant.working_time_range(week_day)
    p restaurant_working_time

    reserved_time = []
    self.reservations.where(date: day).each do |r|
      time = r.time
      time = time[0..1].to_i + time[3..-1].to_i/60.0
      reserved_time << time
      duration = r.duration.to_i
      (duration / 30 - 1).times do |n|
        reserved_time << time + 0.5 * (n + 1)
      end
    end
    p reserved_time
    restaurant_working_time - reserved_time
  end
end
