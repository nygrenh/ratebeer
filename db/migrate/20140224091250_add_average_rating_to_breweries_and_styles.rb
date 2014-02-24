class AddAverageRatingToBreweriesAndStyles < ActiveRecord::Migration
  def change
  	add_column :breweries, :average_rating, :integer
  	add_column :styles, :average_rating, :integer
  end
end
