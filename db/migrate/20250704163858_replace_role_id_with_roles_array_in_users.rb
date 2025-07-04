class ReplaceRoleIdWithRolesArrayInUsers < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :users, :roles
    remove_index :users, :role_id
    remove_column :users, :role_id

    add_column :users, :roles, :string, array: true, default: [], null: false

    drop_table :roles
  end
end
