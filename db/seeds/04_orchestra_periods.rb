pugliese = Orchestra.find_by(name: "Osvaldo Pugliese")
pugliese_orchestra_periods = [
  {name: "Early Pugliese", start_date: Date.new(1943,1,1), end_date: Date.new(1947,1,1)},
  {name: "Finding His Style", start_date: Date.new(1946,1,1), end_date: Date.new(1950,1,1)},
  {name: "Mature Style", start_date: Date.new(1950,1,1), end_date: Date.new(1955,1,1)},
  {name: "Maciel Period", start_date: Date.new(1955,1,1), end_date: Date.new(1968,1,1)},
  {name: "Late Pugliese", start_date: Date.new(1968,1,1), end_date: Date.new(1987,1,1)},
]

pugliese_orchestra_periods.each do |period|
  pugliese.orchestra_periods.find_or_create_by!(period)
end

darienzo = Orchestra.find_by(name: "Juan D'Arienzo")
darienzo_orchestra_periods = [
  {name: "Sexteto", start_date: Date.new(1928,1,1), end_date: Date.new(1930,1,1)},
  {name: "With Biagi", start_date: Date.new(1936,1,1), end_date: Date.new(1939,1,1)},
  {name: "Fast Tempo With Polito", start_date: Date.new(1939,1,1), end_date: Date.new(1940,1,1)},
  {name: "Slowing Down", start_date: Date.new(1940,1,1), end_date: Date.new(1945,1,1)},
  {name: "D'Arienzo Is Back", start_date: Date.new(1945,1,1), end_date: Date.new(1951,1,1)},
  {name: "Salamanca After 50", start_date: Date.new(1950,1,1), end_date: Date.new(1957,1,1)},
  {name: "Polito Is Back", start_date: Date.new(1957,1,1), end_date: Date.new(1961,1,1)},
  {name: "Late D'Arienzo", start_date: Date.new(1961,1,1), end_date: Date.new(1976,1,1)},
]

darienzo_orchestra_periods.each do |period|
  darienzo.orchestra_periods.find_or_create_by!(period)
end

troilo = Orchestra.find_by(name: "Aníbal Troilo")
troilo_orchestra_periods = [
  {name: "Energetic Period", start_date: Date.new(1938,1,1), end_date: Date.new(1942,1,1)},
  {name: "Sentimental Golden Age", start_date: Date.new(1942,1,1), end_date: Date.new(1950,1,1)},
  {name: "TK Years", start_date: Date.new(1950,1,1), end_date: Date.new(1957,1,1)},
  {name: "Late Troilo", start_date: Date.new(1957,1,1), end_date: Date.new(1969,1,1)},
]

troilo_orchestra_periods.each do |period|
  troilo.orchestra_periods.find_or_create_by!(period)
end

disarli = Orchestra.find_by(name: "Carlos Di Sarli")
disarli_orchestra_periods = [
  {name: "Sexteto", start_date: Date.new(1928,1,1), end_date: Date.new(1932,1,1)},
  {name: "Energetic Period", start_date: Date.new(1939,1,1), end_date: Date.new(1942,1,1)},
  {name: "Melodic", start_date: Date.new(1942,1,1), end_date: Date.new(1948,1,1)},
  {name: "Early 50s", start_date: Date.new(1951,1,1), end_date: Date.new(1956,1,1)},
  {name: "Late 50s", start_date: Date.new(1956,1,1), end_date: Date.new(1959,1,1)},
]

disarli_orchestra_periods.each do |period|
  disarli.orchestra_periods.find_or_create_by!(period)
end
