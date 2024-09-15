require "rails_helper"

RSpec.describe "Orchestras", type: :graph do
  describe "Querying for orchestras with aggregations" do
    let!(:user) { create(:user, :approved) }
    let!(:orchestra) { create(:orchestra, name: "Carlos Di Sarli") }
    let!(:singer) { create(:person, name: "Alberto Podesta") }
    let!(:orchestra_period) { create(:orchestra_period, name: "42-44", orchestra:) }
    let!(:genre) { create(:genre, name: "Tango") }
    let!(:time_period) { create(:time_period, name: "Golden Age") }
    let!(:recording) { create(:recording, orchestra:, singers: [singer], genre:, time_period:) }

    let(:query) do
      <<~GQL
        query searchRecordings($query: String, $filters: RecordingFilterInput, $order_by: RecordingOrderByInput, $aggs: [RecordingAggregationInput!]) {
          searchRecordings(query: $query, filters: $filters, orderBy: $order_by, aggs: $aggs) {
            recordings {
              edges {
                node {
                  id
                  composition {
                    title
                  }
                  orchestra {
                    name
                  }
                }
              }
            }
            aggregations {
              orchestraPeriods {
                key
                docCount
              }
              timePeriod {
                key
                docCount
              }
              singers {
                key
                docCount
              }
              genre {
                key
                docCount
              }
            }
          }
        }
      GQL
    end

    it "returns the correct orchestra details with aggregations" do
      Recording.reindex

      gql(query,
        variables: {
          filters: {orchestra: "Carlos Di Sarli"},
          aggs: [
            {field: "orchestraPeriods"},
            {field: "timePeriod"},
            {field: "singers"},
            {field: "genre"}
          ]
        },
        user:)
      response_data = data.search_recordings

      recordings = response_data.recordings
      aggregations = response_data.aggregations

      expect(recordings.edges.size).to eq(1)
      expect(recordings.edges.first.node.id).to eq(recording.id)
      expect(recordings.edges.first.node.composition.title).to eq(recording.composition.title)

      expect(aggregations.orchestra_periods.first.key).to eq("42-44")
      expect(aggregations.orchestra_periods.first.doc_count).to eq(1)

      expect(aggregations.time_period.first.key).to eq("Golden Age")
      expect(aggregations.time_period.first.doc_count).to eq(1)

      expect(aggregations.singers.first.key).to eq("Alberto Podesta")
      expect(aggregations.singers.first.doc_count).to eq(1)

      expect(aggregations.genre.first.key).to eq("Tango")
      expect(aggregations.genre.first.doc_count).to eq(1)
    end
  end
end
