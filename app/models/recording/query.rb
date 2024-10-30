# app/models/recording/query.rb
class Recording::Query
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :orchestra, :string
  attribute :year, :string
  attribute :genre, :string
  attribute :orchestra_period, :string
  attribute :singer, :string
  attribute :items, :integer, default: 100

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
      .pluck(Arel.sql("DISTINCT EXTRACT(YEAR FROM recorded_date)"))
      .map(&:to_i)
      .sort

    return years_array.map(&:to_s) if years_array.size <= 4

    periods = []
    current_range_start = years_array.first

    years_array.each_cons(2) do |prev_year, next_year|
      if next_year - current_range_start > 4 || next_year - prev_year > 1
        periods << if current_range_start == prev_year
          current_range_start.to_s
        else
          "#{current_range_start}-#{prev_year}"
        end
        current_range_start = next_year
      end
    end

    last_year = years_array.last
    if last_year - current_range_start < 4
      periods[-1] = "#{current_range_start}-#{last_year}"
    else
      periods << last_year.to_s
    end

    periods
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
      if singer.downcase == "instrumental"
        instrumental_count = Recording
          .where(id: recording_ids)
          .left_outer_joins(:recording_singers)
          .where(recording_singers: {recording_id: nil})
          .count
        [OpenStruct.new(id: "instrumental", name: "Instrumental", slug: "instrumental", recording_count: instrumental_count)]
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
        instrumental = OpenStruct.new(id: "instrumental", name: "Instrumental", slug: "instrumental", recording_count: instrumental_count)
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
    genre.present? ? scope.joins(:genre).where(genres: {slug: genre}) : scope
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
    if singer.present?
      if singer.downcase == "instrumental"
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
