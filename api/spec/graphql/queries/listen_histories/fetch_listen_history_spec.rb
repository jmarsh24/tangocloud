require "rails_helper"

RSpec.describe "fetch listen history", type: :graph do
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
      gql(query, user:)

      listen_edges = data.fetch_listen_history.listens.edges
      expect(listen_edges.size).to eq(1)
      expect(listen_edges.first.node.id).to eq(listen.id.to_s)
      expect(listen_edges.first.node.created_at).to eq(listen.created_at.iso8601)
      expect(listen_edges.first.node.recording.id).to eq(listen.recording.id.to_s)
      expect(listen_edges.first.node.recording.title).to eq(listen.recording.title)
      expect(listen_edges.first.node.user.id).to eq(listen.user.id.to_s)
    end
  end
end
