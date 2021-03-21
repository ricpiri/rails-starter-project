class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :description
      t.string :tags
      t.integer :views, default: 0

      t.timestamps
    end
  end
end
