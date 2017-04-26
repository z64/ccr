module Ccr
  macro user_not_found
    next BOT.create_message(payload.channel_id, "`user not found`") unless user
  end

  # Base command is the same as ccr.standard
  BOT.command("ccr ") do |payload, args|
    user = OSU.user args
    user_not_found

    BOT.create_message(payload.channel_id, "**#{user.username}** [`standard`]", user.embed)
  end

  # Creates commands for each game mode stat pull
  {% for mode in ["standard", "taiko", "ctb", "mania"] %}
    BOT.command("ccr.{{mode.id}}") do |payload, args|
      user = OSU.user args, Osu::Mode::{{mode.capitalize.id}}
      user_not_found

      BOT.create_message(payload.channel_id, "**#{user.username}** [`{{mode.id}}`]", user.embed)
    end
  {% end %}

  BOT.command("ccr.ranks") do |payload, args|
    stats = OSU.user args, [Osu::Mode::Standard, Osu::Mode::Taiko, Osu::Mode::Ctb, Osu::Mode::Mania]
    next BOT.create_message(payload.channel_id, "`user not found`") unless stats.any?

    string = String.build do |str|
      Osu::Mode.each do |flag, v|
        str << "**#{flag.to_s.downcase}:** #{stats[v].try &.rank.pp} (#{stats[v].try &.pp_raw})\n"
      end
    end

    user = stats.first.as(Osu::User)

    BOT.create_message(
      payload.channel_id, 
      "**#{user.username}'s Ranks**",
      Discord::Embed.new(
        description: string, 
        colour: Osu::OSU_COLOR
      ).tap { |e| e.thumbnail = Discord::EmbedThumbnail.new(user.avatar_url) }
    )
  end
end

