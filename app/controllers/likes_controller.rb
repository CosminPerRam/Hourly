class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[ create destroy ]

  def create
    @message_id = params[:message_id]
    specified_message = Message.find_by(id: @message_id)
    if specified_message.nil?
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Couldn't like." }
        format.json { render :show, status: :unprocessable_entity }
      end
      return
    else
      an_hour_ago = (Time.now.utc - 1*60*60).strftime("%d/%m/%Y %H:%M:%S %Z")
      if specified_message.created_at < an_hour_ago
        respond_to do |format|
          format.html { redirect_to root_path, notice: "Couldn't like." }
          format.json { render :show, status: :unprocessable_entity }
        end
        return
      end
    end

    @user_id = current_user.id

    @previous_like = current_user.likes.find_by(user_id: @user_id, message_id: @message_id)
    if @previous_like.nil?
      @like = Like.new(user_id: @user_id, message_id: @message_id)

      respond_to do |format|
        if @like.save
          format.html { redirect_to root_path, notice: "Like was successfully created." }
          format.json { render :show, status: :created, location: @like }
        else
          format.html { redirect_to root_path, notice: "Couldn't like." }
          format.json { render :show, status: :unprocessable_entity }
        end
      end
    else
      @previous_like.destroy

      respond_to do |format|
        format.html { redirect_to root_path, notice: "Like was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end
end
