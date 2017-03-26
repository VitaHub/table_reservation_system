class Table < ApplicationRecord
  belongs_to :restaurant
  validates :restaurant, :name, presence: true
  validate :uniqueness_for_table_name_per_restaurant
  has_many :reservations

    # незарезервированное время на определенную дату
  def not_reserved_time(date)
    restaurant_working_time = self.restaurant.working_time_range(date)
    return nil if restaurant_working_time.nil?

    reserved_time = []
    self.reservations.where(date: date).each do |r|
      time = r.time
      time = time[0..1].to_i + time[3..-1].to_i/60.0
      reserved_time << time
      duration = r.duration.to_i
      (duration / 30 - 1).times do |n|
        reserved_time << time + 0.5 * (n + 1)
      end
    end
    
    free_time = restaurant_working_time - reserved_time
    return nil if free_time.empty?
    free_time
  end

  private

      # проверяет уникальность названия столика для ресторана
    def uniqueness_for_table_name_per_restaurant
      if self.class.exists?(restaurant_id: restaurant_id, name: name)
        errors.add(:table, 'already exists.')
      end
    end
end
