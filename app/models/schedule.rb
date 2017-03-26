class Schedule < ApplicationRecord
  belongs_to :restaurant
  validates :restaurant, :day, :time_from, :time_till, presence: true
  validates :time_from, :time_till, 
    format: { with: TIME_FORMAT,
    message: "Not allowed format. Please try again. " +
             "Example: '12:30' or '00.00'" }
  validates :day, 
    format: { with: /Sun|Mon|Tue|Wed|Thu|Fri|Sat|20\d{2}-[0-1]\d-[0-3]\d/,
    message: "Not allowed format. Please try again. " +
             "Example: 'Mon, Tue, Wed, Thu, Fri, Sat, Sun' or '2017-05-01'" }
  validate :date_format

  private

      # проверка, является ли дата настоящей
    def date_format
      if self.day =~ /20\d{2}-[0-1]\d-[0-3]\d/
        begin
          Date.parse(self.day)
        rescue ArgumentError
          errors.add(:day, "Invalid day format")
        end
      end
    end
end
