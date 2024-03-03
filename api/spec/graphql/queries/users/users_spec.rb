require "rails_helper"

RSpec.describe "users", type: :graph do
  describe "Querying for users" do
    let!(:user) { users(:admin) }
    let(:query) do
      <<~GQL
        query searchUsers($query: String!) {
          searchUsers(query: $query) {
            edges {
              node {
                id
                name
              }
            }
          }
        }
      GQL
    end

    it "returns the correct el_recodo_song details" do
      gql(query, variables: {query: "admin"}, user:)

      found_user = data.search_users.edges.first.node

      expect(found_user).not_to be_nil
      expect(found_user["id"]).to eq(user.id.to_s)
      expect(found_user["name"]).to eq("Admin User")
    end
  end
end
