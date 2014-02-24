class RatingsController < ApplicationController	

  def index
    @top_beers = Beer.top 3
    @top_breweries = Brewery.top 3
    @top_styles = Style.top 3
    @recent_ratings = Rating.recent
    @top_users = User.top(3)
  end

  def new
  	@rating = Rating.new
    @beers = Beer.all
  end

  def create
  	@rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    if current_user and @rating.save
      current_user.ratings << @rating
      update_averages(@rating.beer, @rating.user)
      redirect_to ratings_path
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    if current_user == rating.user
      beer = rating.beer
      user = rating.user
      rating.delete
      update_averages(beer, user)
    end
    redirect_to :back
  end

  private

  def update_averages(beer, user)
    update_averages_for(beer)
    update_averages_for(beer.style)
    update_averages_for(beer.brewery)

    user.rating_count = user.ratings.count
    user.save
  end

  # Object should have ratings and average_rating
  def update_averages_for(object)
    sum = 0
    object.ratings.each do |rating|
      sum += rating.score
    end
    unless object.ratings.count == 0
      object.average_rating = sum / object.ratings.count
    else
      object.average_rating = 0
    end
    object.save
  end

end
