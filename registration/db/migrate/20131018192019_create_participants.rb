class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :participantID
      t.string :fname
      t.string :lname
      t.integer :phone
      t.date :expirydate
      t.date :dr_note_date
      t.string :password
      t.string :email
      t.date :birthday

      t.timestamps
    end
  end
end
