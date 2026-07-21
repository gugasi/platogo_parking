class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.string :barcode, null: false, limit: 16
      t.datetime :issued_at, null: false
      t.datetime :paid_at
      t.string :payment_method
      t.datetime :exited_at

      t.timestamps
    end

    # Enforce uniqueness at the database level for fast lookups
    add_index :tickets, :barcode, unique: true
    
    # Index for fast counting of active cars in the lot
    add_index :tickets, :exited_at
  end
end