module Ccr
  # Preloads user objects in anticipation of default commands.
  # Gotta go fast.
  BOT.on_typing_start do |payload|
    user_id = REDIS.get("ccr:#{payload.user_id}:me")
    next unless user_id

    results = OSU.user(user_id.to_i32, Osu::Mode.values).not_nil!

    results.all.each do |mode, user|
      REDIS.set("ccr:preload:#{user.try &.user_id}:#{mode}", user.to_json, 30)
    end
  end
end
