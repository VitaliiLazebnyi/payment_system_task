# frozen_string_literal: true

class UserHasManyTransactions < ActiveRecord::Migration[7.0]
  def change
    add_reference :transactions, :user
  end
end
