require 'spec_helper'

describe Beer do
	it "is saved if it has a name and style" do
		beer = Beer.create name:"Test", style_id:1
		expect(beer).to be_valid
	end

	it "is not saved without name" do
		beer = Beer.create style_id:1
		expect(beer).not_to be_valid
	end

	it "is not saved without style" do
		beer = Beer.create name:"Test"
		expect(beer).not_to be_valid
	end
end
