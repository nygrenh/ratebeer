require 'spec_helper'

describe "Places" do
	it "if one is returned by the API, it is shown at the page" do
		BeermappingApi.stub(:places_in).with("kumpula").and_return(
			[ Place.new(:name => "Oljenkorsi") ]
			)

		visit places_path
		fill_in('city', with: 'kumpula')
		click_button "Search"

		expect(page).to have_content "Oljenkorsi"
	end

	it "shows all results on the page" do
		BeermappingApi.stub(:places_in).with("kumpula").and_return(
			[ Place.new(:name => "Oljenkorsi"),
				Place.new(:name => "Drunken Rat") ]
				)

		visit places_path
		fill_in('city', with: 'kumpula')
		click_button "Search"

		expect(page).to have_content "Oljenkorsi"
		expect(page).to have_content "Drunken Rat"
	end

	it "answers with 'no locations' if there's no results" do
		BeermappingApi.stub(:places_in).with("Morgoth").and_return([])

		visit places_path
		fill_in('city', with: 'Morgoth')
		click_button "Search"
		expect(page).to have_content "No locations in Morgoth"
	end
end