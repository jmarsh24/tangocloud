# app/models/recording/query.rb
class Recording::Query
  include ActiveModel::Model
  include ActiveModel::Attributes

  PRE_1935 = "<1935"
  POST_1960 = "1960-present"

  attribute :orchestra, :string
  attribute :year, :string
  attribute :genre, :string
  attribute :orchestra_period, :string
  attribute :singer, :string
  attribute :items, :integer, default: 200

  def results
    return Recording.none unless valid?

    scope = Recording.with_associations
    scope = filter_by_orchestra(scope)
    scope = filter_by_year(scope)
    scope = filter_by_genre(scope)
    scope = filter_by_orchestra_period(scope)
    scope = filter_by_singer(scope)
    scope.limit(items)
  end

  def recording_ids
    results.select(:id)
  end

  def years
    return [year] if year.present?

    years_array = results
      .where.not(recorded_date: nil)
      .pluck(:year)
      .map(&:to_i)
      .sort

    year_ranges = []
    year_ranges << PRE_1935 if years_array.any? { |y| y < 1935 }
    year_ranges << "1935-1939" if years_array.any? { |y| (1935..1939).cover?(y) }
    year_ranges << "1940-1944" if years_array.any? { |y| (1940..1944).cover?(y) }
    year_ranges << "1945-1949" if years_array.any? { |y| (1945..1949).cover?(y) }
    year_ranges << "1950-1954" if years_array.any? { |y| (1950..1954).cover?(y) }
    year_ranges << "1955-1959" if years_array.any? { |y| (1955..1959).cover?(y) }
    year_ranges << POST_1960 if years_array.any? { |y| y >= 1960 }

    year_ranges
  end

  def genres
    Genre
      .joins(:recordings)
      .where(recordings: {id: recording_ids})
      .group("genres.id")
      .order(Arel.sql(order_genres_sql))
  end

  def orchestra_periods
    if orchestra_period.present?
      period = OrchestraPeriod.find_by(slug: orchestra_period)
      if period.present?
        OrchestraPeriod.where(id: period.id)
      else
        OrchestraPeriod.none
      end
    else
      min_date, max_date = results.pluck(Arel.sql("MIN(recorded_date), MAX(recorded_date)")).first
      if min_date && max_date
        OrchestraPeriod
          .joins(orchestra: :recordings)
          .where(recordings: {id: recording_ids})
          .where(start_date: ..max_date, end_date: min_date..)
          .group("orchestra_periods.id")
          .order("orchestra_periods.start_date ASC, orchestra_periods.end_date ASC")
      else
        OrchestraPeriod.none
      end
    end
  end

  def singers
    if singer.present?
      if singer.casecmp("instrumental").zero?
        instrumental_count = Recording
          .where(id: recording_ids)
          .left_outer_joins(:recording_singers)
          .where(recording_singers: {recording_id: nil})
          .count
        [OpenStruct.new(id: "instrumental", display_name: "Instrumental", slug: "instrumental", recording_count: instrumental_count)]
      else
        Person.where(slug: singer)
      end
    else
      singers = Person
        .joins(:recording_singers)
        .where(recording_singers: {recording_id: recording_ids})
        .group("people.id")
        .select("people.*, COUNT(recording_singers.recording_id) AS recording_count")
        .order("recording_count DESC")

      instrumental_count = Recording
        .where(id: recording_ids)
        .left_outer_joins(:recording_singers)
        .where(recording_singers: {recording_id: nil})
        .count

      if instrumental_count > 0
        instrumental = OpenStruct.new(id: "instrumental", display_name: "Instrumental", slug: "instrumental", recording_count: instrumental_count)
        singers = singers.to_a + [instrumental]
      else
        singers = singers.to_a
      end

      singers.sort_by { |s| -s.recording_count }
    end
  end

  private

  def filter_by_orchestra(scope)
    return scope unless orchestra.present?

    scope.joins(:orchestra).where(orchestra: {slug: orchestra})
  end

  def filter_by_year(scope)
    return scope unless year.present?

    case year
    when PRE_1935
      scope.where("year< ?", 1935)
    when POST_1960
      scope.where("year >= ?", 1960)
    when /-/
      min_year, max_year = year.split("-").map(&:to_i)
      min_date = Date.new(min_year)
      max_date = Date.new(max_year).end_of_year
      scope.where(recorded_date: min_date..max_date)
    else
      min_date = Date.new(year.to_i)
      max_date = Date.new(year.to_i).end_of_year
      scope.where(recorded_date: min_date..max_date)
    end
  end

  def filter_by_genre(scope)
    return scope unless genre.present?

    scope.joins(:genre).where(genres: {slug: genre})
  end

  def filter_by_orchestra_period(scope)
    return scope unless orchestra_period.present?

    period = OrchestraPeriod.friendly.find(orchestra_period)

    if period
      scope.where(recorded_date: period.start_date..period.end_date)
    else
      scope.none
    end
  end

  def filter_by_singer(scope)
    return scope unless singer.present?

    if singer.present?
      if singer.casecmp("instrumental").zero?
        scope.left_outer_joins(:recording_singers).where(recording_singers: {recording_id: nil})
      else
        scope.joins(recording_singers: :person).where(people: {slug: singer})
      end
    else
      scope
    end
  end

  def order_genres_sql
    <<-SQL
      CASE
        WHEN genres.name = 'Tango' THEN 1
        WHEN genres.name = 'Milonga' THEN 2
        WHEN genres.name = 'Vals' THEN 3
        WHEN genres.name = 'Candombe' THEN 4
        ELSE 5
      END, genres.name ASC
    SQL
  end
end
