# test/models/recording/query_test.rb
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

    @desde_alma = Recording.create!(composition: Composition.create!(title: "Desde Alma"), genre: @vals, recorded_date: "1979-12-27")
    @tierrita = Recording.create!(composition: Composition.create!(title: "Tierrita"), genre: @tango, recorded_date: "1941-06-09")

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

    expected_recordings = Recording.all.limit(100)
    assert_equal expected_recordings.count, results.count
    assert_equal expected_recordings.pluck(:id).sort, results.pluck(:id).sort
  end

  test "should filter recordings by orchestra" do
    query = initialize_query(orchestra: @juan_darienzo)
    results = query.results

    expected_recordings = Recording.where(orchestra: @juan_darienzo).limit(100)
    assert_equal expected_recordings.count, results.count
    assert results.all? { |rec| rec.orchestra == @juan_darienzo }
  end

  test "should filter recordings by year" do
    query = initialize_query(year: 1960)
    results = query.results

    expected_recordings = Recording.where("EXTRACT(YEAR FROM recorded_date) = ?", 1960).limit(100)
    assert_equal expected_recordings.count, results.count
    assert results.all? { |rec| rec.recorded_date.year == 1960 }
  end

  test "should filter recordings by genre" do
    query = initialize_query(genre: @tango.name)
    results = query.results

    expected_recordings = Recording.joins(:genre).where(genres: {name: @tango.name}).limit(100)
    assert_equal expected_recordings.count, results.count
    assert results.all? { |rec| rec.genre == @tango }
  end

  test "should filter recordings by orchestra_period" do
    query = initialize_query(orchestra_period: @slowing_down.name.parameterize)
    results = query.results

    assert_equal 2, results.count

    assert_includes results, @la_cumparsita
    assert_includes results, @tierrita
  end

  test "should filter recordings by singer" do
    query = initialize_query(singer: @alberto_echague.name)
    results = query.results

    expected_recordings = Recording.joins(recording_singers: :person)
      .where(people: {name: @alberto_echague.name})
    assert_equal expected_recordings.count, results.count
    assert results.all? { |rec| rec.singers.include?(@alberto_echague) }
  end

  test "should filter recordings with no singers when singer is instrumental" do
    query = initialize_query(singer: "instrumental")
    results = query.results

    expected_recordings = Recording.left_outer_joins(:recording_singers)
      .where(recording_singers: {recording_id: nil})
      .limit(100)
    assert_equal expected_recordings.count, results.count
    assert results.all? { |rec| rec.singers.empty? }
  end

  test "should filter recordings by orchestra and genre" do
    query = initialize_query(orchestra: @juan_darienzo, genre: @tango.name)
    results = query.results

    expected_recordings = Recording.joins(:genre)
      .where(orchestra: @juan_darienzo)
      .where(genres: {name: @tango.name})
      .limit(100)
    assert_equal expected_recordings.count, results.count
    assert results.all? { |rec| rec.orchestra == @juan_darienzo && rec.genre == @tango }
  end

  test "should filter recordings by genre and instrumental singer" do
    query = initialize_query(genre: @milonga.name, singer: "Instrumental")
    results = query.results

    expected_recordings = Recording.joins(:genre)
      .left_outer_joins(:recording_singers)
      .where(genres: {name: @milonga.name})
      .where(recording_singers: {recording_id: nil})
      .limit(100)
    assert_equal expected_recordings.count, results.count
    assert results.all? { |rec| rec.genre == @milonga && rec.singers.empty? }
  end

  test "should return no recordings when filters do not match any records" do
    query = initialize_query(year: 1800)
    results = query.results

    assert_equal 0, results.count
  end

  test "singers method should include all singers and instrumental sorted by recording_count" do
    query = initialize_query
    singers = query.singers

    assert_includes singers.map(&:name), "Hector Maure"
    assert_includes singers.map(&:name), "Alberto Echagüe"
    assert_includes singers.map(&:name), "Instrumental"

    # Ensure sorting by recording_count descending
    sorted = singers.sort_by { |s| -s.recording_count }
    assert_equal sorted, singers
  end

  test "singers method should return only the specified singer" do
    query = initialize_query(singer: @hector_maure.slug)
    singers = query.singers

    assert_equal 1, singers.count
    assert_equal @hector_maure.name, singers.first.name
  end

  test "singers method should return instrumental with correct recording_count" do
    query = initialize_query
    singers = query.singers

    instrumental = singers.find { |s| s.name == "Instrumental" }
    expected_count = Recording.left_outer_joins(:recording_singers)
      .where(recording_singers: {recording_id: nil})
      .count
    if expected_count > 0
      assert_not_nil instrumental
      assert_equal "instrumental", instrumental.id
      assert_equal expected_count, instrumental.recording_count
    else
      assert_nil instrumental
    end
  end

  test "should respect the items limit" do
    query = initialize_query(items: 2)
    results = query.results

    assert_equal 2, results.count
  end
end
