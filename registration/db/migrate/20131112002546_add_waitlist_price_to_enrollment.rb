class AddWaitlistPriceToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :waitlist_price, :integer
  end
end
