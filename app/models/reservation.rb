class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :table
  belongs_to :user
  validates :restaurant, :table, :user, :date, :time, :duration, presence: true
  validates :time, 
    format: { with: TIME_FORMAT,
    message: "Not allowed format. Please try again. " +
             "Example: '12:30' or '00.00'" }
  validate :duration_format, :working_and_free_time

  private

      # проверка длительность резервирования
      # должно быть кратно 30 минутам
    def duration_format
      duration = self.duration.to_i
      unless duration%30 == 0
        errors.add(:duration, "User can reserve table only for" +
                              " 30, 60, 90 etc. minutes.")
        return
      end
    end

    def working_and_free_time
      reservation_time = reservation_time_arr(self.time, self.duration)
      working_time = self.restaurant.working_time_range(self.date)

        # проверка работы ресторана в день резервирования
      if working_time.nil?
        errors.add(:date, "The restaurant '#{self.restaurant.name}'" +
                          " does not work this day.")   
      else
          # проверка работы ресторана в часы резервирования
        able_to_reserve = (working_time & reservation_time)
        unless able_to_reserve == reservation_time
          errors.add(:time, "The restaurant '#{self.restaurant.name}'" +
            " does not work at " + 
            "#{arr_to_time(reservation_time - able_to_reserve)}" +
            " this day.")    
        else
            # проверка невозможности пересечения времени резервирований
          not_reserved_time = self.table.not_reserved_time(self.date)
          able_to_reserve = (not_reserved_time & reservation_time)
          unless reservation_time == able_to_reserve
            errors.add(:time, "This table is already reserved at " +
              "#{arr_to_time(reservation_time - able_to_reserve, working_time)}.")
          end
        end
      end
    end

end
