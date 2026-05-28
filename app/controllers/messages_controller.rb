class MessagesController < ApplicationController

  def create
    @chat = Chat.find(params[:chat_id])
    @challenge = @chat.challenge

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    # this message is what the user asked in the form
    if @message.save
      # call the background job thats doing the AI calls
      assistant_message = Message.create(
        role: 'assistant',
        content: '<i class="fa-solid fa-ellipsis fa-beat-fade"></i>',
        chat: @chat
      )
      AiMessageJob.perform_later(@message, assistant_message)

      # we dont want to re-render the WHOLE page, just the 2 new messages
      respond_to do |format|
        format.html { redirect_to chat_path(@chat) }
        format.turbo_stream # render create.turbo_stream.erb
      end
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
