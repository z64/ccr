module Ccr
  macro user_not_found
    next BOT.create_message(payload.channel_id, "`user not found`") unless user
  end

  # Base command is the same as ccr.standard
  BOT.command("ccr") do |payload, args|
    args = payload.author.username if args.empty?
    user = OSU.user args
    user_not_found

    BOT.create_message(payload.channel_id, "**#{user.username}** [`standard`]", user.embed)
  end

  # Creates commands for each game mode stat pull
  {% for mode in ["standard", "taiko", "ctb", "mania"] %}
    BOT.command("ccr.{{mode.id}}") do |payload, args|
      args = payload.author.username if args.empty?
      user = OSU.user args, Osu::Mode::{{mode.capitalize.id}}
      user_not_found

      BOT.create_message(payload.channel_id, "**#{user.username}** [`{{mode.id}}`]", user.embed)
    end
  {% end %}

  BOT.command("ccr.ranks") do |payload, args|
    args = payload.author.username if args.empty?
    stats = OSU.user args, [Osu::Mode::Standard, Osu::Mode::Taiko, Osu::Mode::Ctb, Osu::Mode::Mania]
    next BOT.create_message(payload.channel_id, "`user not found`") unless stats.all.values.any?

    string = String.build do |str|
      Osu::Mode.each do |flag, v|
        str << "**#{flag.to_s.downcase}:** #{stats[flag].try &.rank.pp.try &.to_cspv} (`#{stats[flag].try &.pp_raw.try &.to_cspv}`)\n"
      end
    end

    user = stats.standard.as(Osu::User)

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

