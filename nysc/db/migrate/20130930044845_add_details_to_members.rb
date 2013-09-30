class AddDetailsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :day, :integer
    add_column :members, :month, :integer
    add_column :members, :year, :integer
    add_column :members, :gender, :string
    add_column :members, :address, :string
    add_column :members, :city, :string
    add_column :members, :postalcode, :string
    add_column :members, :phone, :string
    add_column :members, :email, :string

  end
end
