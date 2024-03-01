require "rails_helper"

RSpec.describe "recording" do
  describe "Querying for recording" do
    let!(:user) { users(:admin) }
    let!(:recording) { recordings(:volver_a_sonar) }
    let(:query) do
      <<~GQL
        query recording($id: ID!) {
          recording(id: $id) {
            id
            title
            singers {
              edges {
                node {
                  name
                }
              }
            }
            orchestra {
              name
            }
            genre {
              name
            }
            audioTransfers {
              edges {
                node {
                  album {
                    albumArt {
                      url
                    }
                  }
                  waveform {
                    image {
                      url
                    }
                    data
                  }
                }
              }
            }
          }
        }
      GQL
    end

    it "returns the correct recording details" do
      result = TangocloudSchema.execute(query, variables: {id: recording.id.to_s}, context: {current_user: user})
      recording_data = result.dig("data", "recording")

      expect(recording_data["id"]).to eq(recording.id.to_s)
      expect(recording_data["title"]).to eq("Volver a sonar")
      expect(recording_data["singers"]["edges"].map { |edge| edge["node"]["name"] }).to include("Roberto Rufino")
      expect(recording_data["orchestra"]["name"]).to eq("Carlos Di Sarli")
      expect(recording_data["genre"]["name"]).to eq("tango")

      expect(recording_data["audioTransfers"]["edges"]).not_to be_empty
      audio_transfer = recording_data["audioTransfers"]["edges"].first["node"]
      expect(audio_transfer["album"]["albumArt"]["url"]).not_to be_nil
      expect(audio_transfer["waveform"]["image"]["url"]).not_to be_nil
      expect(audio_transfer["waveform"]["data"]).not_to be_empty
    end
  end
end
