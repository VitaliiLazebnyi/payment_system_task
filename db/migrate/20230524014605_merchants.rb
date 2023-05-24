# frozen_string_literal: true

class Merchants < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'citext'
    enable_extension 'plpgsql'
    enable_extension 'pgcrypto'

    create_table 'merchants', id: :uuid, force: :cascade do |t|
      t.text 'name', null: false
      t.text 'description', null: false
      t.citext 'email', null: false, index: { unique: true }
      t.boolean 'active', null: false, default: true
      t.integer 'total_transaction_sum', null: false, default: 0
      t.timestamps
    end
  end
end
