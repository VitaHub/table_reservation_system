class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.references :restaurant, foreign_key: true, null: false
      t.string :day, null: false
      t.string :time_from, null: false
      t.string :time_till, null: false

      t.timestamps
    end
  end
end
