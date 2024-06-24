require "rails_helper"

RSpec.describe "period", type: :graph do
  describe "Querying for period" do
    let!(:user) { users(:admin) }
    let!(:period) { periods(:golden_age) }
    let(:query) do
      <<~GQL
        query Period($id: ID!) {
          period(id: $id) {
            id
            name
            image {
              blob {
                url
              }
            }
          }
        }
      GQL
    end

    it "returns the correct period details" do
      gql(query, variables: {id: period.id.to_s}, user:)

      expect(data.period.id).to eq(period.id)
      expect(data.period.name).to eq("Golden Age")
      expect(data.period.image.blob.url).to include("http://localhost:3000/files/")
    end
  end
end
