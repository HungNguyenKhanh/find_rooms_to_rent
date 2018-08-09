class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def index
    if current_user == @conversation.sender || current_user == @conversation.recipient
      @other = current_user == @conversation.sender ? 
        @conversation.recipient : @conversation.sender
      @messages = @conversation.messages.order("created_at ASC")
    else
      flash[:alert] = t "noti_permission"
      redirect_to conversations_path
    end
  end

  def create
    @message = @conversation.messages.new message_params

    if @message.save
      ActionCable.server.broadcast "conversation_#{@conversation.id}",
        message: render_message(@message)
      redirect_to conversation_messages_path @conversation
    end
  end

  private

  def render_message message
    self.render(partial: "messages/message", locals: {message: message})
  end

  def set_conversation
    @conversation = Conversation.find_by id: params[:conversation_id]
    return if @conversation
    flash[:alert] = t("noti_not_found")
    redirect_back fallback_location: request.referer
  end

  def message_params
    params.require(:message).permit :context, :user_id
  end
end
