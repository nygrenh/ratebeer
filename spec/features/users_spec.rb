require 'spec_helper'
include OwnTestHelper

describe "User" do
  before :each do
    FactoryGirl.create :user
    FactoryGirl.create :user2
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
      }.to change{User.count}.by(1)
  end

  describe "who has signed in" do
      before :each do
        sign_in(username:"Pekka", password:"Foobar1")
        @user = User.find_by username:"Pekka"
        beer = FactoryGirl.create(:beer, name:"Test Beer")
        @beer2 = FactoryGirl.create(:beer2, name:"Frosty")
        FactoryGirl.create(:rating, user:@user, beer:beer)
        FactoryGirl.create(:rating2, user:@user, beer:@beer2)

      end

      it "is shown their own ratings on user's page" do
        visit user_path(@user)
        expect(page).to have_content 'Test Beer'
        expect(page).to have_content 'Frosty'
      end

      it "is not shown ratings created by other users on user's page" do
        user2 = User.find_by username:"Admin"
        FactoryGirl.create(:rating, user:user2, beer:@beer2, score:14)
        visit user_path(@user)
        expect(page).not_to have_content 'Frosty 14'
      end

      it "can delete their rating" do
        visit user_path(@user)
        expect {
        page.find('li', :text => 'Test Beer').click_link('delete')
        }.to change{@user.ratings.count}.by(-1)
      end

      it "is shown their favorite brewery on user's page" do 
        visit user_path(@user)
        expect(page).to have_content 'favorite brewery: anonymous'
      end

      it "is shown their favorite style on user's page" do 
        visit user_path(@user)
        expect(page).to have_content 'favorite style: Lager'
      end
  end
end
