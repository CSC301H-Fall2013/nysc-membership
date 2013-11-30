class AddRefundBackToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :refund_back, :integer
  end
end
