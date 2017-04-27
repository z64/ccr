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
end
