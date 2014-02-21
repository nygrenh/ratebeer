class BeerClub < ActiveRecord::Base
	has_many :memberships, -> { confirmed }
	has_many :members, through: :memberships, source: :user
	has_many :membership_applications, -> { unconfirmed }, class_name: 'Membership'
	has_many :applicants, through: :membership_applications, source: :user


	def is_a_member(user_id)
		membership = Membership.all.find_by beer_club_id:id, user_id:user_id, confirmed: true
		not membership.nil?
	end

	def has_applied(user_id)
		applications = Membership.all.find_by beer_club_id:id, user_id:user_id, confirmed: [false, nil]
		not applications.nil?
	end
end
