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
        **PP Rank:** #{rank.pp.try &.to_cspv} (`#{pp_raw}`) / **Country (#{country}):** #{rank.country.try &.to_cspv}
        **SS** `x#{rank.ss}` / **S** `x#{rank.s}` / **A** `x#{rank.a}`

        **Accuracy:** `#{accuracy.try &.round(2)}%`
        300 `x#{count300.try &.to_cspv}` / 100 `x#{count100.try &.to_cspv}` / 50 `x#{count50.try &.to_cspv}`

        **Level #{level}**
        **Total Score:** `#{total_score.try &.to_cspv}` / **Ranked:** `#{ranked_score.try &.to_cspv}`
        **Playcount:** `x#{playcount.try &.to_cspv}`
        DATA
      )
      
      e.fields = [stats_field]
      e.thumbnail = Discord::EmbedThumbnail.new(avatar_url) 
      e.timestamp = Time.now

      e
    end
  end
end
