# app/models/recordings_query.rb
class Recording::Query
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :orchestra
  attribute :year, :integer
  attribute :genre, :string
  attribute :orchestra_period, :string
  attribute :singer, :string

  validates :year, numericality: {only_integer: true}, allow_nil: true

  def initialize(attributes = {})
    super
  end

  def results
    return Recording.none unless valid?

    scope = Recording.with_associations
    scope = scope.where(orchestra: orchestra) if orchestra.present?
    scope = filter_by_year(scope)
    scope = filter_by_genre(scope)
    scope = filter_by_orchestra_period(scope)
    scope = filter_by_singer(scope)
    scope.limit(100)
  end

  def recording_ids
    results.select(:id)
  end

  def years
    Recording
      .where(id: recording_ids)
      .where.not(recorded_date: nil)
      .distinct
      .pluck(Arel.sql("EXTRACT(YEAR FROM recorded_date)"))
      .map(&:to_i)
      .sort
  end

  def genres
    Genre
      .joins(compositions: :recordings)
      .where(recordings: {id: recording_ids})
      .group("genres.id")
      .order(Arel.sql(order_genres_sql))
  end

  def orchestra_periods
    return OrchestraPeriod.none unless orchestra.present?

    OrchestraPeriod
      .joins(orchestra: :recordings)
      .where(recordings: {id: recording_ids})
      .group("orchestra_periods.id")
      .order("orchestra_periods.start_date ASC, orchestra_periods.end_date ASC")
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
    if year.present?
      scope.where("EXTRACT(YEAR FROM recorded_date) = ?", year)
    else
      scope
    end
  end

  def filter_by_genre(scope)
    if genre.present?
      scope.joins(composition: :genre).where(genres: {name: genre})
    else
      scope
    end
  end

  def filter_by_orchestra_period(scope)
    if orchestra_period.present? && orchestra.present?
      period = orchestra.orchestra_periods.find_by(name: orchestra_period)
      if period.present?
        date_range = period.start_date..period.end_date
        scope.where(recorded_date: date_range)
      else
        scope.none
      end
    else
      scope
    end
  end

  def filter_by_singer(scope)
    if singer.present?
      scope
        .joins(recording_singers: :person)
        .where(people: {name: singer})
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
