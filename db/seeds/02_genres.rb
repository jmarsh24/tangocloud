["Tango", "Vals", "Milonga"].map do |name|
  Genre.find_or_create_by!(name:)
end
