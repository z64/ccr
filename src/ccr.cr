require "ctx"
require "osu/client"
require "./ccr/*"

module Ccr
  CONFIG = Config.from_file("config.yml")

  BOT = Ctx::Bot.new(
    CONFIG.token,
    CONFIG.client_id
  )

  OSU = Osu::Client.new CONFIG.osu_token

  BOT.run
end
