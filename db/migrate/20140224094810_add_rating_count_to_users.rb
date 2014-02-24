class AddRatingCountToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :rating_count, :integer
  end
end
