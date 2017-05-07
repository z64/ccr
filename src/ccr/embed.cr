module Osu
  OSU_ICON  = "http://vignette2.wikia.nocookie.net/fantendo/images/1/12/Osu!_logo.png"
  OSU_COLOR = 0xff69b4u32

  struct User
    def embed
      e = Discord::Embed.new(
        author: Discord::EmbedAuthor.new(name: "View Profile", icon_url: OSU_ICON),
        url: profile_url,
        timestamp: Time.now,
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

      e
    end
  end

  struct Beatmap
    def embed
      e = Discord::Embed.new(
        author: Discord::EmbedAuthor.new(name: "View Beatmap", icon_url: OSU_ICON),
        url: url,
        timestamp: Time.now,
        colour: OSU_COLOR,
        description: <<-data
        Mapped by: **#{creator}** `[#{mode} | #{approval}]`
        Last Update: `#{last_update}`
        #{beatmapset_id.nil? ? "" : "[View Beatmap Set](#{beatmap_set_url})"}
        data
      )

      total_length_str = Time.parse(total_length.as(UInt32).to_s, "%s").to_s "%M:%S"
      hit_length_str = Time.parse(hit_length.as(UInt32).to_s, "%s").to_s "%M:%S"

      e.fields = [
        Discord::EmbedField.new(
          name: "Difficulty",
          inline: true,
          value: <<-data
          Overall: **#{difficulty.overall}**
          Star Difficulty: **#{difficulty.rating.as(Float32).round(2)}**
          Circle Size: **#{difficulty.size}**
          HP Drain: **#{difficulty.drain}**
          Approach Rate: **#{difficulty.approach}**
          data
        ),
        Discord::EmbedField.new(
          name: "Stats",
          inline: true,
          value: <<-data
          Length: `#{total_length_str}` (`#{hit_length_str}` drain) @ #{bpm} BPM
          Max Combo: **#{max_combo}**
          Pass Count: **#{passcount.as(UInt32).to_cspv} / #{playcount.as(UInt32).to_cspv}** (#{(passcount.as(UInt32).to_f / playcount.as(UInt32).to_f).round(2)}%)
          Favorited by **#{favourite_count.as(UInt32).to_cspv}** players
          data
        ),
      ]

      e
    end
  end

  struct BeatmapSet
    def embed
      e = Discord::Embed.new(
        author: Discord::EmbedAuthor.new(name: "View Beatmap Set", icon_url: OSU_ICON),
        url: url,
        timestamp: Time.now,
        colour: OSU_COLOR,
      )

      map_strings = beatmaps.map do |m|
        length = Time.parse(m.total_length.as(UInt32).to_s, "%s").to_s "%M:%S"
        "▫️[#{m.version}](#{m.url}) (#{m.mode}, diff: **#{m.difficulty.overall}** / combo: **#{m.max_combo}** / `#{length}`)"
      end

      e.description = <<-DATA
      **Maps in this set**

      #{map_strings.join("\n")}
      DATA

      e
    end
  end
end
