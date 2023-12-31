class MessagesController < ApplicationController
  before_action :set_message, only: %i[ mine show edit update destroy ]
  before_action :authenticate_user!, except: %i[ show ]
  before_action :has_already_made_in_hour
  before_action :correct_user, only: %i[ edit update destroy ]

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages
  def index
    @messages = current_user.messages
  end

  def correct_user
    @owner = current_user.messages.find_by(id: params[:id])
    redirect_to messages_path, notice: "cacat" if @message.nil?
  end

  def has_already_made_in_hour
    an_hour_ago = (Time.now.utc - 1*60*60).strftime("%d/%m/%Y %H:%M:%S %Z")
    messages = Message.find_by(user_id: current_user.id, created_at: an_hour_ago..)
    @has_already_made_in_hour = !messages.nil?
  end

  # GET /messages/new
  def new
    @message = current_user.messages.build
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages or /messages.json
  def create
    #@message = Message.new(message_params)
    @message = current_user.messages.build(message_params)
    #@message.user_id = current_user.id

    respond_to do |format|
      if @message.save
        format.html { redirect_to message_url(@message), notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:message)
    end
end
