class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.all
    # render 'index.html.erb' (by default)
    # format -> html, json, text...
    respond_to do |format|
      format.json { render json: @challenges.to_json }
      format.html # follow the normal Rails flow of looking for an index view
    end
  end

  def show
    @challenge = Challenge.find(params[:id])
    @chats = @challenge.chats.where(user: current_user)
  end
end
