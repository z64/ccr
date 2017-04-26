module Osu
  OSU_ICON = "http://vignette2.wikia.nocookie.net/fantendo/images/1/12/Osu!_logo.png"
  OSU_COLOR = 0xff69b4u32

  struct User
    def embed
      e = Discord::Embed.new(
        author: Discord::EmbedAuthor.new(icon_url: OSU_ICON),
        title: "View Profile",
        url: profile_url,
        colour: OSU_COLOR
      )

      stats_field = Discord::EmbedField.new( 
        name: "Stats",
        value: <<-DATA
        **PP Rank:** #{rank.pp} (`#{pp_raw}`) / **Country (#{country}):** #{rank.country}
        **SS** `x#{rank.ss}` / **S** `x#{rank.s}` / **A** `x#{rank.a}`

        **Accuracy:** `#{accuracy.try &.round(2)}%`
        300 `x#{count300}` / 100 `x#{count100}` / 50 `x#{count50}`

        **Level #{level}**
        **Total Score:** #{total_score} / **Ranked:** `#{ranked_score}`
        **Playcount:** `x#{playcount}`
        DATA
      )
      
      e.fields = [stats_field]
      e.thumbnail = Discord::EmbedThumbnail.new(avatar_url) 
      e.timestamp = Time.now

      e
    end
  end
end
