# frozen_string_literal: true

class AllowNilAmountForTransactions < ActiveRecord::Migration[7.0]
  def change
    change_column_null :transactions, :amount, true
  end
end
