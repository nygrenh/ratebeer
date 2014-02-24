class User < ActiveRecord::Base
	require 'securerandom'
	include RatingAverage

	has_secure_password

	validates :username, uniqueness: true, length: { in: 3..57  }
	validates :password, length: { minimum: 4 }
	validate :password_complexity

	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	has_many :memberships, -> { confirmed }, dependent: :destroy
	has_many :membership_applications, -> { unconfirmed }, class_name: 'Membership', dependent: :destroy

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

	def self.from_omniauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
	    user.provider = auth.provider
	    user.uid = auth.uid
	    user.username = auth.info.name
	    user.oauth_token = auth.credentials.token
	    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
	    password = SecureRandom.base64 + "1A" # for complexity requirements
	    user.password = password 
	    user.password_confirmation = password
	    user.save!
	  end
	end

	def self.top(n)
		User.order(rating_count: :desc).limit(n)
	end

	private

	def password_complexity
		if password.present? and not password.match(/\A(?=.*[A-Z])(?=.*\d).+\z/)
			errors.add :password, "was just awful"
		end
	end

end
