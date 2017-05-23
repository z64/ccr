module Ccr
  # Commands for managing a user's settings
  BOT.command("ccr.me") do |payload, args|
    user = OSU.user args
    user_not_found

    REDIS.set("ccr:#{payload.author.id}:me", user.user_id)

    BOT.create_message(payload.channel_id, "`user set:` **#{user.username}**")
  end

  BOT.command("ccr.mode") do |payload, args|
    next BOT.create_message(payload.channel_id, "`invalid mode! specify standard, mania, ctb, or taiko`") unless Osu::Mode.names.includes?(args.capitalize)
    mode = Osu::Mode.parse(args)

    REDIS.set("ccr:#{payload.author.id}:mode", mode.to_s)

    BOT.create_message(payload.channel_id, "`mode set:` **#{mode}**")
  end
end
