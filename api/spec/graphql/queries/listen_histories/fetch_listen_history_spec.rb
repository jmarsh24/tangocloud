require "rails_helper"

RSpec.describe "fetch listen history" do
  describe "Querying for listen_history" do
    let!(:user) { users(:normal) }
    let!(:listen) { listens(:volver_a_sonar_normal_listen) }
    let(:query) do
      <<~GQL
        query FetchListenHistory {
          fetchListenHistory {
            listens {
              edges {
                node {
                  id
                  createdAt
                  recording {
                    id
                    title
                  }
                  user {
                    id
                  }
                }
              }
            }
          }
        }
      GQL
    end

    it "returns the correct el_recodo_song details" do
      result = TangocloudSchema.execute(query, context: {current_user: user})

      json = JSON.parse(result.to_json)

      expect(json.dig("data", "fetchListenHistory", "listens", "edges").length).to eq(1)
      expect(json.dig("data", "fetchListenHistory", "listens", "edges", 0, "node", "id")).to eq(listen.id.to_s)
      expect(json.dig("data", "fetchListenHistory", "listens", "edges", 0, "node", "createdAt")).to eq(listen.created_at.iso8601)
      expect(json.dig("data", "fetchListenHistory", "listens", "edges", 0, "node", "recording", "id")).to eq(listen.recording.id.to_s)
      expect(json.dig("data", "fetchListenHistory", "listens", "edges", 0, "node", "recording", "title")).to eq(listen.recording.title)
      expect(json.dig("data", "fetchListenHistory", "listens", "edges", 0, "node", "user", "id")).to eq(listen.user.id.to_s)
    end
  end
end
