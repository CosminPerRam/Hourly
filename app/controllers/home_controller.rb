class HomeController < ApplicationController
  def index
    @an_hour_ago = (Time.now.utc - 1*60*60).strftime("%d/%m/%Y %H:%M:%S %Z")

    @messages = Message.where(created_at: @an_hour_ago..)
    @likes = Like.all
  end
end
