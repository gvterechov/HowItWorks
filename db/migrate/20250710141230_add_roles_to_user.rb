class AddRolesToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :roles, :string, default: [], null: false, array: true
  end
end
