class CreateChallengeTool < RubyLLM::Tool
  # this is telling the AI when to use the tool
  description <<~TXT
    ALWAYS call this tool when the user wants to create, generate, add, or build a new coding challenge.
    Do NOT just write the challenge as text — you MUST call this tool to save it to the database.
    This applies to any request like "create a challenge about X", "make a new challenge for Y", "add a challenge that does Z", etc.

    After creation, give the link to the challenge to the user. Include the link as a markdown link to that URL: /challenges/{challenge_id}
  TXT

  # this are the attributes the tool needs in order to run
  param :name, desc: "This is the name of the challenge"
  param :module_name, desc: "This is the module that the challenge belongs to (eg. Ruby, OOP, DB, Rails, Front-end)"
  param :instructions, desc: <<~TXT
    This is the instructions for the challenge.
    You should create a custom challenge based on the user's request in Markdown. It MUST be broken into multiple sections: Background & Objectives, Spec, and Further Learning.
    Here is a example of how other challenges are formatted:
    ```
    ## Background & Objectives\n\nLet’s keep practicing blocks in this challenge. We will code another method that should be called with a block, and this time we will see how blocks enable nesting method calls, and how this can be useful in a real-life example. We will also discover how we can define methods with a second optional parameter, which happens frequently!\n\n## Specs\n\nImplement the #tag method that builds the HTML tags around the content we give it in the block. For instance:\n```ruby\ntag(\"h1\") do\n  \"Some Title\"\nend\n#=> \"<h1>Some Title</h1>\"\n```\n\nThis method accepts a second optional parameter (see section below on arguments with default value), enabling to pass an array with one HTML attribute name and its value, like [\"href\", \"www.google.com\"].\n```ruby\ntag(\"a\", [\"href\", \"www.google.com\"]) do\n  \"Google it\"\nend\n#=> '<a href=\"www.google.com\">Google it</a>'\n```\n\nYou may need to know that to include a \" symbol inside a string delimited by double quotes,\nyou need to escape this character with an antislash: \".\n\nThe cool thing about this method is that you can nest method calls:\n\n```ruby\ntag(\"a\", [\"href\", \"www.google.com\"]) do\n  tag(\"h1\") do\n    \"Google it\"\n  end\nend\n# => '<a href=\"www.google.com\"><h1>Google it</h1></a>'\n```\n\nCool right?\nArguments with default value\n\nIn Ruby you can supply a default value for an argument. This means that if a value for the argument isn’t supplied, the default value will be used instead, e.g.:\n\n```ruby\ndef sum(a, b, c = 0)\n  return a + b + c\nend\n\nsum(3, 6, 1) # => 10\nsum(4, 2)    # => 6\n```\n\nHere, the third argument is worth 0 if we call sum with only two arguments.
    ```
  TXT

  # the AI will have to give me these arugment when it uses the tool
  def execute(name:, module_name:, instructions:)
    challenge = Challenge.new(
      name: name,
      module: module_name,
      content: instructions
    )
    if challenge.save
      # telling the AI we created a new instance of a challenge
      { success: true, challenge_id: challenge.id }
    else
      # telling the AI how the creation went wrong
      { success: false, errors: challenge.errors.full_messages }
    end
  end
end
