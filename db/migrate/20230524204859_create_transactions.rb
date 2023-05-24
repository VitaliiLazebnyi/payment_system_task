# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.integer :amount, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.citext  :customer_email, null: false
      t.citext  :customer_phone, null: false
      t.timestamps
    end
  end
end
