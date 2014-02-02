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

	private

	def password_complexity
		if password.present? and not password.match(/\A(?=.*[A-Z])(?=.*\d).+\z/)
			errors.add :password, "was just awful"
		end
	end
end
