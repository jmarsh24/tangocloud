require "test_helper"

class Recording::QueryTest < ActiveSupport::TestCase
  def setup
    @juan_darienzo = orchestras(:juan_darienzo)
    @osvaldo_pugliese = Orchestra.create!(name: "Osvaldo Pugliese")

    @tango = genres(:tango)
    @milonga = genres(:milonga)
    @vals = genres(:vals)

    @slowing_down = orchestra_periods(:slowing_down)
    @darienzo_is_back = OrchestraPeriod.create!(name: "D'Arienzo is Back", start_date: "1945-01-01", end_date: "1951-12-31", orchestra: @juan_darienzo)

    @with_biagi = OrchestraPeriod.create!(name: "With Biagi", start_date: "1936-01-01", end_date: "1939-12-31", orchestra: @juan_darienzo)

    @alberto_echague = people(:alberto_echague)
    @hector_maure = Person.create!(name: "Hector Maure")

    @la_cumparsita = recordings(:la_cumparsita)
    @el_choclo = recordings(:el_choclo)
    @desde_alma = Recording.create!(composition: Composition.create!(title: "Desde Alma"), genre: @vals, recorded_date: "1979-12-27", orchestra: @osvaldo_pugliese)
    @tierrita = Recording.create!(composition: Composition.create!(title: "Tierrita"), genre: @tango, recorded_date: "1941-06-09", orchestra: @juan_darienzo)
    @recording_two_jane = RecordingSinger.create!(recording: @tierrita, person: @hector_maure)
  end

  def initialize_query(params = {})
    Recording::Query.new(
      orchestra: params[:orchestra],
      year: params[:year],
      genre: params[:genre],
      orchestra_period: params[:orchestra_period],
      singer: params[:singer],
      items: params[:items]
    )
  end

  test "should return all recordings when no filters are applied" do
    query = initialize_query
    results = query.results

    assert_includes results, @la_cumparsita
    assert_includes results, @el_choclo
    assert_includes results, @desde_alma
    assert_includes results, @tierrita
  end

  test "should filter recordings by orchestra" do
    query = initialize_query(orchestra: @juan_darienzo.slug)
    results = query.results

    assert_includes results, @la_cumparsita
    assert_includes results, @tierrita
    assert_includes results, @el_choclo
    refute_includes results, @desde_alma
  end

  test "should filter recordings by year" do
    query = initialize_query(year: "1941")
    results = query.results

    assert_includes results, @tierrita
    refute_includes results, @la_cumparsita
    refute_includes results, @desde_alma
  end

  test "should filter recordings by genre" do
    query = initialize_query(genre: @tango.slug)
    results = query.results

    assert_includes results, @la_cumparsita
    assert_includes results, @tierrita
    refute_includes results, @desde_alma
  end

  test "should filter recordings by orchestra_period" do
    query = initialize_query(orchestra_period: @slowing_down.slug.parameterize)
    results = query.results

    assert_includes results, @la_cumparsita
    assert_includes results, @tierrita
  end

  test "should filter recordings by singer" do
    query = initialize_query(singer: @alberto_echague.slug)
    results = query.results

    assert results.any? { _1.singers.include?(@alberto_echague) }
  end

  test "should filter recordings with no singers when singer is instrumental" do
    query = initialize_query(singer: "instrumental")
    results = query.results

    assert results.all? { _1.singers.empty? }
  end

  test "should filter recordings by orchestra and genre" do
    query = initialize_query(orchestra: @juan_darienzo.slug, genre: @tango.slug)
    results = query.results

    assert_includes results, @tierrita
    refute_includes results, @desde_alma
  end

  test "should filter recordings by genre and instrumental singer" do
    query = initialize_query(genre: @milonga.slug, singer: "instrumental")
    results = query.results

    assert results.all? { _1.genre == @milonga && _1.singers.empty? }
  end

  test "should return no recordings when filters do not match any records" do
    query = initialize_query(year: "1800")
    results = query.results

    assert_empty results
  end

  test "singers method should include all singers and instrumental sorted by recording_count" do
    query = initialize_query
    singers = query.singers

    assert_includes singers.map(&:name), "Hector Maure"
    assert_includes singers.map(&:name), "Alberto Echagüe"
    assert_includes singers.map(&:name), "Instrumental"
  end

  test "singers method should return only the specified singer" do
    query = initialize_query(singer: @hector_maure.slug)
    singers = query.singers

    assert_equal 1, singers.count
    assert_equal @hector_maure.slug, singers.first.slug
  end

  test "should respect the items limit" do
    query = initialize_query(items: 2)
    results = query.results

    assert_equal 2, results.count
  end
end
