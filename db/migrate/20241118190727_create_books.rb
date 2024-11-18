class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.datetime :publication_date, null: false
      t.integer :rating, default: 0, null: false
      t.string :status, default: :available, null: false

      t.timestamps
    end
  end
end
