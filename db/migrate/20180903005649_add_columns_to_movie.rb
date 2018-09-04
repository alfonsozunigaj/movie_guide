class AddColumnsToMovie < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :last_seen, :datetime
    add_column :movies, :visits, :integer
  end
end
