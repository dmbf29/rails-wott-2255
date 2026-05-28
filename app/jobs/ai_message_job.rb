include ActionView::RecordIdentifier
class AiMessageJob < ApplicationJob
  queue_as :default

  # .perform_now   -> syncronously (runs and we wait to finish one at a time)
  # .perform_later -> async.       (run mulitple processes)
  def perform(user_message, assistant_message)
    chat = user_message.chat
    challenge = chat.challenge
    challenge_context = " Here is the challenge I'm currently on: #{challenge.content}"
    # get a response from the ruby_llm
    ruby_llm_chat = RubyLLM.chat
    ruby_llm_chat.with_tool(CreateChallengeTool)
    # also need to give the chat the previous messsages
    chat.messages.each do |message|
      ruby_llm_chat.add_message(message)
    end
    ruby_llm_chat.with_instructions("#{Message.system_prompt}\n#{challenge_context}")
    response = ruby_llm_chat.ask(user_message.content)
    # does this refresh the page?
    assistant_message.update(content: response.content)
    # Tell whoever is on this chat that the message has been updated
    # send the message partial to the front-end
    # where? what are we targeting? and what are we sending?
    Turbo::StreamsChannel.broadcast_replace_to(
      chat,
      target: dom_id(assistant_message),
      partial: 'messages/message', locals: { message: assistant_message}
    )
  end
end
