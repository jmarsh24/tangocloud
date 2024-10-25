# app/models/recording/query.rb
class Recording::Query
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :orchestra
  attribute :year, :string
  attribute :genre, :string
  attribute :orchestra_period, :string
  attribute :singer, :string
  attribute :items, :integer, default: 100

  def results
    return Recording.none unless valid?

    scope = Recording.with_associations
    scope = scope.where(orchestra: orchestra) if orchestra.present?
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
      .distinct
      .pluck(Arel.sql("EXTRACT(YEAR FROM recorded_date)"))
      .map(&:to_i)
      .sort
    return years_array if years_array.length == 1

    years_array.in_groups(5).map do
      _1.compact.minmax.compact.join("-")
    end.compact_blank!
  end

  def genres
    Genre
      .joins(:recordings)
      .where(recordings: {id: recording_ids})
      .group("genres.id")
      .order(Arel.sql(order_genres_sql))
  end

  def orchestra_periods
    return OrchestraPeriod.none unless orchestra.present?

    if orchestra_period.present?
      period = orchestra.orchestra_periods.find_by(name: orchestra_period)
      period ? OrchestraPeriod.where(id: period.id) : OrchestraPeriod.none
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
      if singer.downcase == "instrumental"
        instrumental_count = Recording
          .where(id: recording_ids)
          .left_outer_joins(:recording_singers)
          .where(recording_singers: {recording_id: nil})
          .count
        [OpenStruct.new(id: "instrumental", name: "Instrumental", recording_count: instrumental_count)]
      else
        Person.where(name: singer)
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
        instrumental = OpenStruct.new(id: "instrumental", name: "Instrumental", recording_count: instrumental_count)
        singers = singers.to_a + [instrumental]
      else
        singers = singers.to_a
      end

      singers.sort_by { |s| -s.recording_count }
    end
  end

  private

  def filter_by_year(scope)
    return scope unless year.present?

    if year.include?("-")
      min_year, max_year = year.split("-")
      min_date = Date.new(min_year.to_i)
      max_date = Date.new(max_year.to_i).end_of_year
      scope.where(recorded_date: min_date..max_date)
    elsif year.present?
      min_date = Date.new(year.to_i)
      max_date = Date.new(year.to_i).end_of_year
      scope.where(recorded_date: min_date..max_date)
    end
  end

  def filter_by_genre(scope)
    genre.present? ? scope.joins(:genre).where(genres: {name: genre}) : scope
  end

  def filter_by_orchestra_period(scope)
    return scope unless orchestra_period.present? && orchestra.present?

    period = orchestra.orchestra_periods.find_by(name: orchestra_period)
    period ? scope.where(recorded_date: period.start_date..period.end_date) : scope.none
  end

  def filter_by_singer(scope)
    if singer.present?
      if singer.downcase == "instrumental"
        scope.left_outer_joins(:recording_singers).where(recording_singers: {recording_id: nil})
      else
        scope.joins(recording_singers: :person).where(people: {name: singer})
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
