# frozen_string_literal: true

class AllowTransactionsSelfRefence < ActiveRecord::Migration[7.0]
  def change
    add_reference :transactions, :reference,
                  type: :uuid,
                  foreign_key: { to_table: :transactions }
  end
end
