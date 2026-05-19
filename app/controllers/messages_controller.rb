class MessagesController < ApplicationController

  def create
    @chat = Chat.find(params[:chat_id])
    @challenge = @chat.challenge

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    # this message is what the user asked in the form
    if @message.save
      # get a response from the ruby_llm
      chat = RubyLLM.chat
      chat.with_instructions("#{Message.system_prompt}\n#{challenge_context}")
      response = chat.ask(@message.content)
      Message.create(
        role: 'assistant',
        content: response.content,
        chat: @chat
      )

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def challenge_context
    " Here is the challenge I'm currently on: #{@challenge.content}"
  end
end
