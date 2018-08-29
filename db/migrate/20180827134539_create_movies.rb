class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.integer :tmdb_id
      t.string :title
      t.integer :vote_count
      t.float :vote_average
      t.text :overview
      t.string :poster_path
      t.string :release_date

      t.timestamps
    end
  end
end
