# frozen_string_literal: true

class AddValidationErrorsToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :validation_errors, :text
  end
end
