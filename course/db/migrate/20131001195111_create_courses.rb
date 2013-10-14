class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :courseName
      t.string :courseCode
      t.string :instructor
      t.string :description
      t.string :intensity
      t.string :additional
      t.date :startDate
      t.date :endDate
      t.time :startTime
      t.time :endTime
      t.string :duration
      t.integer :earlybirdPrice
      t.integer :memberPrice
      t.integer :nonmemberPrice

      t.timestamps
    end
  end
end
