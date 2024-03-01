require "rails_helper"

RSpec.describe "recordings" do
  describe "Querying for recordings" do
    let!(:user) { users(:admin) }
    let!(:recording) { recordings(:volver_a_sonar) }
    let(:query) do
      <<~GQL
        query Recordings($query: String) {
          recordings(query: $query) {
            edges {
              node {
                id
                title
                recordedDate
                audioTransfers {
                  album {
                    albumArtUrl
                  }
                  audioVariants {
                    id
                    duration
                    audioFileUrl
                  }
                }
                orchestra {
                  name
                }
                singers {
                  name
                }
                genre {
                  name
                }
              }
            }
          }
        }
      GQL
    end

    it "returns comprehensive details for recordings including orchestra and singers" do
      result = TangocloudSchema.execute(query, variables: {query: "Volver a"}, context: {current_user: user})

      recordings_data = result.dig("data", "recordings", "edges").map { |edge| edge["node"] }
      found_recording = recordings_data.first

      expect(found_recording).not_to be_nil
      expect(found_recording["id"]).to eq(recording.id.to_s)
      expect(found_recording["title"]).to eq("Volver a sonar")
      expect(found_recording["recordedDate"]).to eq(recording.recorded_date.iso8601)
      expect(found_recording["orchestra"]["name"]).to eq("Carlos Di Sarli")
      expect(found_recording["singers"][0]["name"]).to eq("Roberto Rufino")
      expect(found_recording["genre"]["name"]).to eq("tango")
      expect(found_recording["audioTransfers"].first["album"]["albumArtUrl"]).not_to be_nil
      expect(found_recording["audioTransfers"].first["audioVariants"].first["audioFileUrl"]).not_to be_empty
    end
  end
end
