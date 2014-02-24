class Style < ActiveRecord::Base
	include RatingAverage
	
	has_many :beers
	has_many :ratings, through: :beers

	def to_s
		name
	end

	def self.top(n)
		Style.order(average_rating: :desc).limit(n)
	end
end
