class AddColumnsToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :score_tag, :string
  end
end
