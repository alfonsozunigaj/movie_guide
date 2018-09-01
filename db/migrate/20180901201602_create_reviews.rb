class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :critics_pick
      t.string :headline
      t.string :summary
      t.string :url
      t.string :image

      t.timestamps
    end
  end
end
