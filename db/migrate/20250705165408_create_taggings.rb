class CreateTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|
      t.references :task_tag, null: false, foreign_key: true
      t.references :taggable, polymorphic: true, null: false
      t.timestamps
    end

    add_index :taggings, [:taggable_type, :taggable_id, :task_tag_id], unique: true, name: 'index_taggings_on_taggable_and_tag'
  end
end
