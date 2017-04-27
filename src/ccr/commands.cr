module Ccr
  macro user_not_found
    next BOT.create_message(payload.channel_id, "`user not found`") unless user
  end
end

require "./commands/*"
