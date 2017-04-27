module Ccr
  default_command = Ctx::Context.message_create { |m| (m.content == "ccr") || (m.content.starts_with? "ccr ") }

  # Base command is the same as ccr.standard
  BOT.message_create(default_command) do |payload|
    args = if payload.content == "ccr"
             payload.author.username
           else
             payload.content[4..-1]
           end
    user = OSU.user args
    user_not_found

    BOT.create_message(payload.channel_id, "**#{user.username}** [`standard`]", user.embed)
  end
end
