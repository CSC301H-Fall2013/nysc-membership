class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.string :participantID
      t.string :courseID
      t.date :startDate
      t.integer :waitlist_status

      t.timestamps
    end
  end
end
