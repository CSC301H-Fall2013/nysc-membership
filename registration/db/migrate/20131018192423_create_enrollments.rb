class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.string :participantID
      t.string :courseID
      t.date :startDate
      t.integer :waitlist_status
      t.integer :waitlist_price
      t.boolean :disclaimer
      t.boolean :ans1
      t.boolean :ans2
      t.boolean :ans3
      t.boolean :ans4
      t.boolean :ans5
      t.boolean :ans6
      t.boolean :ans7

      t.timestamps
    end
  end
end
