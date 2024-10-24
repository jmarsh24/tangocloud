# app/models/recording/query.rb
class Recording::Query
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :orchestra
  attribute :year, :integer
  attribute :genre, :string
  attribute :orchestra_period, :string
  attribute :singer, :string
  attribute :items, :integer, default: 100

  validates :year, numericality: {only_integer: true}, allow_nil: true

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
    results
      .where.not(recorded_date: nil)
      .distinct
      .pluck(Arel.sql("EXTRACT(YEAR FROM recorded_date)"))
      .map(&:to_i)
      .sort
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

  def singers
    Person.with_attached_image
      .joins(:recording_singers)
      .where(recording_singers: {recording_id: recording_ids})
      .group("people.id")
      .select("people.*, COUNT(recording_singers.recording_id) AS recording_count")
      .order("recording_count DESC")
  end

  private

  def filter_by_year(scope)
    year.present? ? scope.where("EXTRACT(YEAR FROM recorded_date) = ?", year) : scope
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
    singer.present? ? scope.joins(recording_singers: :person).where(people: {name: singer}) : scope
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
