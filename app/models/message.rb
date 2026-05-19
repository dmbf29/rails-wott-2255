class Message < ApplicationRecord
  belongs_to :chat

  # Message.system_prompt
  def self.system_prompt
    "You are an experienced software developer teaching at a bootcamp, Le Wagon.\nI am a beginner coder, looking to learn Ruby.\nHelp me break down an issue step by step, actionable steps, without giving me any code.\nProvide step-by-step instructions, using Markdown."
  end
end
