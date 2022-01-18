class AddHintsToExpressionTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :expression_tasks, :enable_hints, :boolean, default: false
    add_column :expression_tasks, :max_hints_count, :integer, default: 0

    add_column :attempts, :hint_steps, :integer, default: 0
  end
end
