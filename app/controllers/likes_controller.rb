class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[ create destroy ]

  def create
    @message_id = params[:message_id]
    @user_id = current_user.id

    @previous_like = current_user.likes.find_by(user_id: @user_id, message_id: @message_id)
    if @previous_like.nil?
      @like = Like.new(user_id: @user_id, message_id: @message_id)

      respond_to do |format|
        if @like.save
          format.html { redirect_to root_path, notice: "Like was successfully created." }
          format.json { render :show, status: :created, location: @like }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @like.errors, status: :unprocessable_entity }
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
