class AddAverageRatingToBeer < ActiveRecord::Migration
  def change
  	add_column :beers, :average_rating, :integer
  end
end
