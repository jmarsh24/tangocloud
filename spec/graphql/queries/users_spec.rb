require "rails_helper"

RSpec.describe "users", type: :graph do
  describe "Querying for users" do
    let!(:user) { create(:user, :approved) }
    let(:query) do
      <<~GQL
        query Users($query: String!) {
          users(query: $query) {
            edges {
              node {
                id
                username
              }
            }
          }
        }
      GQL
    end

    it "returns the correct el_recodo_song details" do
      User.reindex

      gql(query, variables: {query: user.first_name}, user:)

      found_user = data.users.edges.first.node

      expect(found_user).not_to be_nil
      expect(found_user["id"]).to eq(user.id)
    end
  end
end
