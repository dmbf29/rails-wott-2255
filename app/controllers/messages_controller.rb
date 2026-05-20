class MessagesController < ApplicationController

  def create
    @chat = Chat.find(params[:chat_id])
    @challenge = @chat.challenge

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    # this message is what the user asked in the form
    if @message.save
      response = fetch_llm_response
      Message.create(
        role: 'assistant',
        content: response.content,
        chat: @chat
      )

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

  def fetch_llm_response
    # get a response from the ruby_llm
    ruby_llm_chat = RubyLLM.chat
    # also need to give the chat the previous messsages
    @chat.messages.each do |message|
      ruby_llm_chat.add_message(message)
    end
    ruby_llm_chat.with_instructions("#{Message.system_prompt}\n#{challenge_context}")
    return ruby_llm_chat.ask(@message.content)
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def challenge_context
    " Here is the challenge I'm currently on: #{@challenge.content}"
  end
end
