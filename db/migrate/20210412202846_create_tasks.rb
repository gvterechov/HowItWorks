class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :expression, null: false
      t.string :task_lang, null: false
      t.string :token, null: false
      t.integer :views_count, default: 0
      t.timestamps
    end
  end
end
