class AddStatusColunToCart < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :status, :integer, default: 10
  end
end
