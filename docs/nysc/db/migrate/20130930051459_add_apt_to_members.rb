class AddAptToMembers < ActiveRecord::Migration
  def change
    add_column :members, :apt, :integer
  end
end
