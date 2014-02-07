class User < ActiveRecord::Base
	include RatingAverage

	has_secure_password

	validates :username, uniqueness: true, length: { in: 3..15  }
	validates :password, length: { minimum: 4 }
	validate :password_complexity

	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships

	def favorite_beer
		return nil if ratings.empty?
		ratings.order(score: :desc).limit(1).first.beer
	end

	def favorite_brewery
		return nil if ratings.empty?
		breweries = ratings.map { |r| r.beer.brewery_id }.uniq
		id = breweries.max_by do |brewery|
			rating_count = ratings.select{ |r| r.beer.brewery_id == brewery}.count
			rating_sum = ratings.select{ |r| r.beer.brewery_id == brewery}.map {|r| r.score }.sum
			rating_sum/rating_count
		end
		Brewery.find_by id:id
	end

	def favorite_style
		return nil if ratings.empty?
		styles = ratings.map { |r| r.beer.style }.uniq
		styles.max_by do |style|
			style_count = ratings.select{ |r| r.beer.style == style}.count
			style_sum = ratings.select{ |r| r.beer.style == style}.map {|r| r.score }.sum
			style_sum/style_count
		end
	end

	private

	def password_complexity
		if password.present? and not password.match(/\A(?=.*[A-Z])(?=.*\d).+\z/)
			errors.add :password, "was just awful"
		end
	end

end
