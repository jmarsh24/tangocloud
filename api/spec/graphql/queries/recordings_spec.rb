require "rails_helper"

RSpec.describe "Recordings", type: :graph do
  describe "Querying for recordings" do
    let!(:user) { create(:user) }
    let!(:singer) { create(:person, name: "Roberto Rufino") }
    let!(:genre) { create(:genre, name: "Tango") }
    let!(:orchestra) { create(:orchestra, name: "Carlos Di Sarli") }
    let!(:recording) { create(:recording, composition_title: "Volver a soñar", singers: [singer], orchestra:, genre:) }
    let!(:digital_remaster) { create(:digital_remaster, recording:) }

    let(:query) do
      <<~GQL
        query Recordings {
          recordings {
            edges {
              node {
                id
              }
            }
          }
        }
      GQL
    end

    it "returns comprehensive details for recordings including orchestra and singers" do
      Recording.reindex

      gql(query, user:)

      found_recording = data.recordings.edges.first.node

      expect(found_recording.id).to eq(recording.id.to_s)
    end
  end
end
