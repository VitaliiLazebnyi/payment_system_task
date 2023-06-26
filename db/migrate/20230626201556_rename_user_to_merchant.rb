class RenameUserToMerchant < ActiveRecord::Migration[7.0]
  def change
    rename_column :transactions, :user_id, :merchant_id
  end
end
