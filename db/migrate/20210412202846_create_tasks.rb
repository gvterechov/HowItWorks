class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :expression_tasks do |t|
      t.string :expression, null: false
      t.string :task_lang, null: false
      t.string :token, null: false
      t.integer :views_count, default: 0
      t.timestamps
    end

    create_table :algorithm_tasks do |t|
      t.string :data, null: false
      t.string :token, null: false
      t.integer :views_count, default: 0
      t.timestamps
    end
  end
end
