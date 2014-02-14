class RemoveOldStylesFromBeer < ActiveRecord::Migration
  def change
  	change_table :beers do |t|
  		t.remove :oldstyle
  	end
  end
end
