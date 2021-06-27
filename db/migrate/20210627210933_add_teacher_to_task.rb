class AddTeacherToTask < ActiveRecord::Migration[6.1]
  def change
    add_reference :expression_tasks, :user, foreign_key: true
    add_reference :algorithm_tasks, :user, foreign_key: true
  end
end
