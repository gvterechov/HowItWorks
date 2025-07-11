class DropExpressionTaskTags < ActiveRecord::Migration[6.1]
  def change
    drop_table :expression_task_tags do |t|
      t.references :expression_task, null: false, foreign_key: true
      t.references :task_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
