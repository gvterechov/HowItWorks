class AddTeacherFeedback < ActiveRecord::Migration[6.1]
  def change
    create_table :teacher_feedbacks do |t|
      t.string :full_name, null: false
      t.string :institution, null: false
      t.string :position, null: false
      t.string :feedback
      t.timestamps
    end
  end
end
