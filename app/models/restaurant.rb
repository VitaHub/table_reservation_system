class Restaurant < ApplicationRecord
  validates :name, presence: true
  has_many :tables, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :reservations


    # вывод свободных столов на определенную дату (и время)
  def free_tables(date, time = nil, duration = nil)
    unless time.nil? || duration.nil?
      reservation_time = reservation_time_arr(time, duration)
    end

    working_time = self.working_time_range(date)
    return nil if working_time.nil?

    free_tables = {}
    self.tables.each do |t|
      free_time = t.not_reserved_time(date)
      if free_time && reservation_time.nil?
        free_tables[t.name] = arr_to_time(free_time, working_time)
      elsif free_time && reservation_time
        able_to_reserve = free_time & reservation_time
        if able_to_reserve == reservation_time
          free_tables[t.name] = arr_to_time(free_time, working_time)
        end
      end
    end
    free_tables
  end

    # время работы в формате массива на определенную дату
  def working_time_range(date)
    schedule = self.schedules.where("day LIKE ?", "%#{date.to_s}%")
    if schedule.empty?
      schedule = self.schedules.where("day LIKE ?", "%#{date.strftime("%a")}%")
    end
    return nil if schedule.empty?
    schedule = schedule.last
    from = schedule.time_from
    from = time_str_to_num(from)
    till = schedule.time_till
    till = time_str_to_num(till)
    working_time = WORKING_HOURS[(from*2)..-1]
    working_time = working_time[0..(working_time[1..-1].index(till))]
  end
  
end
