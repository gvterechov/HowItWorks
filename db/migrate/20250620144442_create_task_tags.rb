class CreateTaskTags < ActiveRecord::Migration[6.1]
  def change
    create_table :task_tags do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
