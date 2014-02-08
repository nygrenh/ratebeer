require 'spec_helper'
include OwnTestHelper

describe 'Beer' do 
	before :each do
		FactoryGirl.create(:brewery)
		FactoryGirl.create :user
		sign_in(username:"Pekka", password:"Foobar1")
	end

	it "is created with a valid name" do
		visit new_beer_path
		fill_in('beer_name', with: 'Test')
		expect{
			click_button('Create Beer')
			}.to change{Beer.count}.by(1)
	end

	it "is not created without name" do
		visit new_beer_path
		expect{
			click_button('Create Beer')
			}.not_to change{Beer.count}
		expect(page).to have_content('Name can\'t be blank')
	end
end