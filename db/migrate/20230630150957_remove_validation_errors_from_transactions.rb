# frozen_string_literal: true

class RemoveValidationErrorsFromTransactions < ActiveRecord::Migration[7.0]
  def change
    remove_column :transactions, :validation_errors, :text
  end
end
