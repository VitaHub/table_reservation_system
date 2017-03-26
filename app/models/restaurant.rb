class Restaurant < ApplicationRecord
  validates :name, presence: true
  has_many :tables, dependent: :destroy
  has_many :schedules, dependent: :destroy

  def working_time_range(day)
    schedule = self.schedules.where("day LIKE ?", "%#{day}%").last
    from = schedule.time_from
    from = from[0..1].to_i + from[3..-1].to_i/60.0
    till = schedule.time_till
    till = till[0..1].to_i + till[3..-1].to_i/60.0
    working_time = WORKING_HOURS[(from*2)..-1]
    working_time = working_time[0..(working_time[1..-1].index(till))]
  end
end
