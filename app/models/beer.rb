class Beer < ActiveRecord::Base
	include RatingAverage

	validates :name, presence: true

	validates_presence_of :style_id

	belongs_to :brewery
	belongs_to :style
	has_many :ratings, dependent: :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user

	def to_s
		"#{brewery.name} - #{name}"
	end

	def self.top(n)
		sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) } 
		sorted_by_rating_in_desc_order.take(3)
	end
end
