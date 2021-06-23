class AddTitleToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :algorithm_tasks, :title, :string, default: ''
    add_column :expression_tasks, :title, :string, default: ''
  end
end
