class AddColumnToReview < ActiveRecord::Migration[5.2]
  def change
    add_reference :reviews, :movie, foreign_key: true
  end
end