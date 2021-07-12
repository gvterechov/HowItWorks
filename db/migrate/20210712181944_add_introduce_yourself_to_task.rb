class AddIntroduceYourselfToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :algorithm_tasks, :introduce_yourself, :boolean, default: true
    add_column :expression_tasks, :introduce_yourself, :boolean, default: true
  end
end
