class HomeController < ApplicationController
  def index
    @messages = Message.all
    @likes = Like.all
  end
end
