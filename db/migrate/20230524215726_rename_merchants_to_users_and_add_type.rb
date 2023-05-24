# frozen_string_literal: true

class RenameMerchantsToUsersAndAddType < ActiveRecord::Migration[7.0]
  def change
    rename_table :merchants, :users
    add_column :users, :type, :string
  end
end
