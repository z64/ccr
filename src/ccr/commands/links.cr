module Ccr
  # A collection of Context for matching against
  # osu links posted in chat
  module Links
    USER            = /#{Osu::API::BASE_URL}\/u\/\d+/
    USER_CTX        = Ctx::Context.message_create { |m| !m.content[USER]?.nil? }
    BEATMAP         = /#{Osu::API::BASE_URL}\/b\/\d+/
    BEATMAP_CTX     = Ctx::Context.message_create { |m| !m.content[BEATMAP]?.nil? }
    BEATMAP_SET     = /#{Osu::API::BASE_URL}\/s\/\d+/
    BEATMAP_SET_CTX = Ctx::Context.message_create { |m| !m.content[BEATMAP_SET]?.nil? }
  end

  # User link
  BOT.message_create(Links::USER_CTX) do |payload|
    user_id = payload.content[Links::USER]?.as(String)[/\d+/].to_i32

    user = OSU.user user_id
    next unless user
    user = user.as(Osu::User)

    BOT.create_message(payload.channel_id, "**#{user.username}** [`standard`]", user.embed)
  end

  # Beatmap link
  BOT.message_create(Links::BEATMAP_CTX) do |payload|
    beatmap_id = payload.content[Links::BEATMAP]?.as(String)[/\d+/].to_i32

    beatmap = OSU.beatmap beatmap_id
    next unless beatmap
    beatmap = beatmap.as(Osu::Beatmap)

    BOT.create_message(payload.channel_id, "**#{beatmap.artist} - #{beatmap.title}** (#{beatmap.version})", beatmap.embed)
  end

  # Beatmapset link
  BOT.message_create(Links::BEATMAP_SET_CTX) do |payload|
    set_id = payload.content[Links::BEATMAP_SET]?.as(String)[/\d+/].to_i32

    beatmap_set = OSU.beatmap_set set_id
    next unless beatmap_set
    beatmap_set = beatmap_set.as(Osu::BeatmapSet)

    if beatmap_set.beatmaps.size == 1
      beatmap = beatmap_set.beatmaps.first
      BOT.create_message(payload.channel_id, "**#{beatmap.artist} - #{beatmap.title}** (#{beatmap.version})", beatmap.embed)
    else
      BOT.create_message(payload.channel_id, "**#{beatmap_set.artist} - #{beatmap_set.title}**", beatmap_set.embed)
    end
  end
end
