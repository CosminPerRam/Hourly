class LikesController < ApplicationController
  before_action :authenticate_user!, only: %i[ create destroy ]

  def create
    @message_id = params[:message_id]
    @user_id = current_user.id
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
  end

  # DELETE /likes/1 or /likes/1.json
  def destroy
    @like.destroy

    respond_to do |format|
      format.html { redirect_to likes_url, notice: "Like was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end
end
