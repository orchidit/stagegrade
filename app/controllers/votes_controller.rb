class VotesController < ApplicationController
  # Here: show, new, edit, create, update
  before_filter :require_user

  def create

  end

  def update
    store_location
    
    user = current_user
    up = (params[:up] == "true")
    
    @vote = Production.find_by_id_and_user_id(params[:vote][:id], user.id)
    @vote.up = up unless @vote.nil?
    
    if !@vote.nil? and @vote.save
      flash[:notice] = "Vote updated!"
    else
      flash[:notice] = "Couldn't update vote."
    end
    format.html { redirect_back_or_default(production_path(@vote.user_review.production) + "#show=community") }
  end
end