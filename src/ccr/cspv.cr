{% for typ in {Int32, UInt32, UInt64, Float32, Float64} %}
  struct {{typ}}
    def to_cspv
      self.to_s.reverse.gsub(/(\d{3})(?=\d)/, "\\1,").reverse
    end
  end
{% end %}
