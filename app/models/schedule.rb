class Schedule < ApplicationRecord
  belongs_to :restaurant
  validates :restaurant, :day, :time_from, :time_till, presence: true
  validates :time_from, :time_till, 
    format: { with: /[0-2]\d[.:][03]0/,
    message: "Not allowed format. Please try again. " +
      "Example: '12:30' or '07.00'" }

  validates :day, 
    format: { with: /Sun|Mon|Tue|Wed|Thu|Fri|Sat|20\d{2}-[0-1]\d-[0-3]\d/,
    message: "Not allowed format. Please try again. " +
      "Example: 'Mon, Tue, Wed, Thu, Fri, Sat, Sun' or '2017-05-01'" }
end
