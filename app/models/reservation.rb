class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :table
  belongs_to :user
  validates :restaurant, :table, :user, :date, :time, :duration, presence: true
  validates :time, 
    format: { with: /[0-2]\d[.:][03]0/,
    message: "Not allowed format. Please try again. " +
      "Example: '12:30' or '07.00'" }
end
