class RenameOldStyles < ActiveRecord::Migration
  def change
  	change_table :beers do |t|
  		t.rename :style, :oldstyle
  	end
  end
end
