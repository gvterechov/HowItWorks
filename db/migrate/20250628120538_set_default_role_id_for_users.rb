class SetDefaultRoleIdForUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :role_id, 3
  end
end
