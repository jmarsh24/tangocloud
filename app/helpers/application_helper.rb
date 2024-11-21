module ApplicationHelper
  def genre_color(genre_name)
    case genre_name.downcase
    when "tango"
      "#111111"
    when "milonga"
      "#2A9D8F" # Teal for Milonga
    when "vals"
      "#E9C46A" # Orangish Yellow for Vals
    else
      "#6C757D" # Neutral Gray as a fallback
    end
  end
end
