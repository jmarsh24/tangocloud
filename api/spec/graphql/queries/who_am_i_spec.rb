require "rails_helper"

RSpec.describe "who_am_i" do
  describe "Querying for who_am_i" do
    let!(:user) { users(:admin) }
    let(:query) do
      <<~GQL
        query who_am_i {
          whoAmI {
          }
        }
      GQL
    end

    it "returns the correct user details" do
      result = TangocloudSchema.execute(query, context: {current_user: user})

      expect(result.dig("data", "whoAmI")).to eq("You've authenticated as Admin User.")
    end
  end
end
