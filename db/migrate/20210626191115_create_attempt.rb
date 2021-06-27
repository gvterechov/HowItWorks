class CreateAttempt < ActiveRecord::Migration[6.1]
  def change
    create_table :attempts do |t|
      t.string :student_name, default: ''
      t.integer :total_steps, default: 0
      t.integer :error_steps, default: 0
      t.boolean :done, default: false
      t.references :task, polymorphic: true
      t.timestamps
    end
  end
end
