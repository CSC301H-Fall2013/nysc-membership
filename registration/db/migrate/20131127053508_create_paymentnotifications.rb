class CreatePaymentnotifications < ActiveRecord::Migration
  def change
    create_table :paymentnotifications do |t|
      t.text :params
      t.integer :cart_id
      t.string :status
      t.string :transaction_id

      t.timestamps
    end
  end
end
