class CreateLessonUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :lesson_users do |t|
      t.references :lesson, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :complete

      t.timestamps
    end
  end
end
