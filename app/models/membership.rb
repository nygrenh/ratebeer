class Membership < ActiveRecord::Base
	validates_uniqueness_of :beer_club_id, :scope => :user_id, message:  '- you already belong to this group'

	belongs_to :user
	belongs_to :beer_club
end
