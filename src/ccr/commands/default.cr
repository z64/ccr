module Ccr
  default_command = Ctx::Context.message_create do |m|
    (m.content == "ccr") || (m.content.starts_with? "ccr ")
  end

  # Base command is the same as ccr.standard
  BOT.message_create(default_command) do |payload|
    args = if payload.content == "ccr"
             payload.author.username
           else
             payload.content[4..-1]
           end

    # Check if preload is available, and send their preferred mode
    user_id = REDIS.get("ccr:#{payload.author.id}:me")
    mode = Osu::Mode.parse(REDIS.get("ccr:#{payload.author.id}:mode") || "Standard")
    user = if user_id
             Osu::User.from_json REDIS.get("ccr:preload:#{user_id}:#{mode}").not_nil!
           else
             OSU.user args
           end
    user_not_found

    BOT.create_message(payload.channel_id, "**#{user.username}** [`#{mode}`]", user.embed)
  end
end
