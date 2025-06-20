class CreateJoinTableExpressionTaskTaskTag < ActiveRecord::Migration[6.1]
  def change
    create_table :expression_task_tags do |t|
      t.references :expression_task, null: false, foreign_key: true
      t.references :task_tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :expression_task_tags, [:expression_task_id, :task_tag_id], unique: true, name: 'index_expr_task_tag_on_expr_task_id_and_task_tag_id'
  end
end
