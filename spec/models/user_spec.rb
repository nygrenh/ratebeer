require 'spec_helper'

describe User do
	it "has the username set correctly" do
		user = User.new username:"Pekka"

		user.username.should == "Pekka"
	end

	it "is not saved without a password" do
		user = User.create username:"Pekka"

		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

	it "can't have too short password" do
		user = User.create username:"Admin", password:"aA1", password_confirmation:"aA1"
		expect(user).not_to be_valid
	end

	it "can't have a password without numbers" do
		user = User.create username:"Admin", password:"Seceret", password_confirmation:"Seceret"
		expect(user).not_to be_valid
	end

	describe "with a proper password" do
		let(:user){ FactoryGirl.create(:user) }

		it "is saved" do
			expect(user).to be_valid
			expect(User.count).to eq(1)
		end

		it "and with two ratings, has the correct average rating" do
			user.ratings << FactoryGirl.create(:rating)
			user.ratings << FactoryGirl.create(:rating2)

			expect(user.ratings.count).to eq(2)
			expect(user.average_rating).to eq(15.0)
		end
	end


	describe "favorite beer" do
		let(:user){FactoryGirl.create(:user) }

		it "has method for determining one" do
			user.should respond_to :favorite_beer
		end

		it "without ratings does not have one" do
			expect(user.favorite_beer).to eq(nil)
		end

		it "is the only rated if only one rating" do
			beer = create_beer_with_rating(10, user)

			expect(user.favorite_beer).to eq(beer)
		end

		it "is the one with highest rating if several rated" do
			create_beers_with_ratings(10, 20, 15, 7, 9, user)
			best = create_beer_with_rating(25, user)

			expect(user.favorite_beer).to eq(best)
		end
	end

	describe "favorite brewery" do
		let(:user){FactoryGirl.create(:user) }

		it "has method for determining one" do
			user.should respond_to :favorite_brewery
		end

		it "without ratings does not have one" do
			expect(user.favorite_brewery).to eq(nil)
		end

		it "is the only rated if only one rating" do
			beer = create_beer_with_rating(13, user)

			expect(user.favorite_brewery).to eq(beer.brewery)
		end

		it "is the one with highest rating if several rated" do
			crappy = Brewery.create name:"Crappy", year:2001
			good = Brewery.create name:"Good", year:1983
			crappy_beer = Beer.create name:"Crappy", style:"Larger"
			good_beer = Beer.create name:"Good", style:"Larger"

			crappy.beers << crappy_beer
			good.beers << good_beer

			create_ratings_for_beer(2, 4, 5, 6, crappy_beer, user)
			create_ratings_for_beer(29, 47, 36, 44, good_beer, user)

			expect(user.favorite_brewery).to eq(good)
		end
	end

	describe "favorite style" do
		let(:user){FactoryGirl.create(:user) }

		it "has method for determining one" do
			user.should respond_to :favorite_style
		end

		it "without ratings does not have one" do
			expect(user.favorite_style).to eq(nil)
		end

		it "is the only rated if only one rating" do
			beer = create_beer_with_rating(13, user)

			expect(user.favorite_style).to eq(beer.style)
		end

		it "is the one with highest rating if several rated" do
			crappy = Brewery.create name:"Crappy", year:2001
			good = Brewery.create name:"Good", year:1983
			crappy_beer = Beer.create name:"Crappy", style:"Larger"
			good_beer = Beer.create name:"Good", style:"Weizen"

			crappy.beers << crappy_beer
			good.beers << good_beer

			create_ratings_for_beer(2, 4, 5, 6, crappy_beer, user)
			create_ratings_for_beer(29, 47, 36, 44, good_beer, user)

			expect(user.favorite_style).to eq(good_beer.style)
		end
	end

end # describe User 

def create_beers_with_ratings(*scores, user)
	scores.each do |score|
		create_beer_with_rating score, user
	end
end

def create_beer_with_rating(score,  user)
	beer = FactoryGirl.create(:beer)
	FactoryGirl.create(:rating, score:score,  beer:beer, user:user)
	beer
end  

def create_ratings_for_beer(*scores, beer, user)
	scores.each do |score|
		FactoryGirl.create(:rating, score:score, beer:beer, user:user)
	end
end