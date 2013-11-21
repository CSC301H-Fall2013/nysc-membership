class AddRoleToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :role, :boolean
  end
end
