# frozen_string_literal: true

class RemoveTransactionConstrains < ActiveRecord::Migration[7.0]
  def change
    change_column_default :transactions, :amount, from: 0, to: nil
    change_column_null :transactions, :status, true
    change_column_null :transactions, :customer_email, true
    change_column_null :transactions, :customer_phone, true
  end
end
