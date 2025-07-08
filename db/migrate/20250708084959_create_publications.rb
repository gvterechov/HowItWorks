class CreatePublications < ActiveRecord::Migration[6.1]
  def change
    create_table :publications do |t|

      t.timestamps
    end
  end
end
