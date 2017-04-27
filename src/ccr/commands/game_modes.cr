module Ccr
  # Creates commands for each game mode stat pull
  {% for mode in ["standard", "taiko", "ctb", "mania"] %}
    BOT.command("ccr.{{mode.id}}") do |payload, args|
      args = payload.author.username if args.empty?
      user = OSU.user args, Osu::Mode::{{mode.capitalize.id}}
      user_not_found

      BOT.create_message(payload.channel_id, "**#{user.username}** [`{{mode.id}}`]", user.embed)
    end
  {% end %}
end
