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
                  edges {
                    node {
                      album {
                        albumArt {
                          url
                        }
                      }
                      audioVariants {
                        edges {
                          node {
                            id
                            duration
                            audioFile {
                              url
                            }
                          }
                        }
                      }
                    }
                  }
                }
                orchestra {
                  name
                }
                singers {
                  edges {
                      node {
                        name
                    }
                  }
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

      recordings_data = result.dig("data", "recordings", "edges").map { _1["node"] }
      found_recording = recordings_data.find { _1["title"].include?("Volver a sonar") }

      expect(found_recording).not_to be_nil
      expect(found_recording["id"]).to eq(recording.id.to_s)
      expect(found_recording["title"]).to eq("Volver a sonar")
      expect(found_recording["recordedDate"]).to eq("1940-10-08")
      expect(found_recording["orchestra"]["name"]).to eq(recording.orchestra.name)

      expect(found_recording["singers"]["edges"].first["node"]["name"]).to eq("Roberto Rufino")
      expect(found_recording["genre"]["name"]).to eq("tango")

      expect(found_recording["audioTransfers"]["edges"].first["node"]["album"]["albumArt"]["url"]).not_to be_nil
      expect(found_recording["audioTransfers"]["edges"].first["node"]["audioVariants"]["edges"].first["node"]["audioFile"]["url"]).not_to be_empty
    end
  end
end
