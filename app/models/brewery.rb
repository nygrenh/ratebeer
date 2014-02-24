class Brewery < ActiveRecord::Base
	include RatingAverage

	validates :name, presence: true
	validates :year, numericality: { only_integer: true, 
									greater_than_or_equal_to: 1042, 
									less_than_or_equal_to: Proc.new { Time.now.year } }

	scope :active, -> { where active:true }
	scope :retired, -> { where active:[nil,false] }

	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

	def self.top(n)
		Brewery.order(average_rating: :desc).limit(n)
	end
end
