class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :fname
      t.string :lname
      t.string :honorific

      t.timestamps
    end
  end
end
