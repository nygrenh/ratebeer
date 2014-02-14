class BeerClub < ActiveRecord::Base
	has_many :memberships
	has_many :members, through: :memberships, source: :user

	def is_a_member(user_id)
		membership = Membership.all.find_by beer_club_id:id, user_id:user_id
		not membership.nil?
	end
end
