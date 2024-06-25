require "rails_helper"

RSpec.describe "Orchestras", type: :graph do
  describe "Querying for orchestras" do
    let!(:user) { users(:normal) }
    let!(:orchestra) { orchestras(:carlos_di_sarli) }
    let(:query) do
      <<~GQL
        query Orchestra($id: ID!) {
          orchestra(id: $id) {
            id
            name
            photo {
              blob {
                url
              }
            }
          }
        }
      GQL
    end

    it "returns the correct orchestra details" do
      gql(query, variables: {id: orchestra.id}, user:)
      first_orchestra = data.orchestra

      expect(first_orchestra.id).to eq(orchestra.id)
      expect(first_orchestra.name).to eq("Carlos Di Sarli")
      expect(first_orchestra.photo.blob.url).to be_present
    end
  end
end
