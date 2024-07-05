require "rails_helper"

RSpec.describe "period", type: :graph do
  describe "Querying for period" do
    let!(:user) { create(:admin_user) }
    let!(:time_period) { create(:time_period) }
    let(:query) do
      <<~GQL
        query TimePeriod($id: ID!) {
          timePeriod(id: $id) {
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
      gql(query, variables: {id: time_period.id.to_s}, user:)

      expect(data.time_period.id).to eq(time_period.id)
      expect(data.time_period.name).to eq("Golden Age")
      expect(data.time_period.image.blob.url).to be_present
    end
  end
end
