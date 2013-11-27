class AddToEnrollment < ActiveRecord::Migration
  def change
	remove_column :enrollments, :waitlist_price, :integer
	add_column :enrollments, :price_paid, :integer
	add_column :enrollments, :price_owed, :integer
  end
end
