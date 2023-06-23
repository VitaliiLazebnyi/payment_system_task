# frozen_string_literal: true

class AddPasswordToUser < ActiveRecord::Migration[7.0]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_column :users, :password_digest, :string, null: false
    # rubocop:enable Rails/NotNullColumn
  end
end
