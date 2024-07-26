require "rails_helper"

RSpec.describe "Orchestras", type: :graph do
  describe "Querying for orchestras with aggregations" do
    let!(:user) { create(:user) }
    let!(:orchestra) { create(:orchestra, name: "Carlos Di Sarli") }
    let!(:orchestra_period) { create(:orchestra_period, name: "42-44", orchestra:) }
    let!(:orchestra_role) { create(:orchestra_role, name: "Pianist", orchestra:) }
    let!(:singer) { create(:person, name: "Alberto Podesta") }
    let!(:genre) { create(:genre, name: "Tango") }
    let!(:time_period) { create(:time_period, name: "Golden Age") }
    let!(:recording) { create(:recording, orchestra:, singers: [singer], genre:, time_period:) }

    let(:query) do
      <<~GQL
        query searchRecordings($query: String, $filters: RecordingFilterInput, $order_by: RecordingOrderByInput) {
          searchRecordings(query: $query, filters: $filters, orderBy: $order_by) {
            recordings {
              edges {
                node {
                  id
                  composition {
                    title
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

      gql(query, variables: {filters: {}}, user:)
      response_data = data.search_recordings

      recordings = response_data.recordings
      aggregations = response_data.aggregations

      expect(recordings.edges.size).to eq(1)
      expect(recordings.edges.first.node.id).to eq(recording.id)
      expect(recordings.edges.first.node.composition.title).to eq(recording.title)

      expect(aggregations.orchestra_periods[0].key).to eq("42-44")
      expect(aggregations.orchestra_periods[0].doc_count).to eq(1)

      expect(aggregations.time_period[0].key).to eq("Golden Age")
      expect(aggregations.time_period[0].doc_count).to eq(1)

      expect(aggregations.singers[0].key).to eq("Alberto Podesta")
      expect(aggregations.singers[0].doc_count).to eq(1)

      expect(aggregations.genre[0].key).to eq("Tango")
      expect(aggregations.genre[0].doc_count).to eq(1)
    end
  end
end
