class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :courseID
      t.date :startDate
      t.string :title
      t.string :instructor
      t.string :description
      t.integer :intensity
      t.string :additional
      t.string :duration
      t.time :startTime
      t.time :endTime
      t.string :dayOfWeek
      t.integer :earlybirdPrice
      t.integer :memberPrice
      t.integer :nonmemberPrice
      t.integer :size

      t.timestamps
    end
  end
end
