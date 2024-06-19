require "rails_helper"

RSpec.describe "Auth", type: :request do
  fixtures :all

  describe "Post /auth/facebook/data_deletion" do
    let(:user) { users(:normal) }

    before do
      user.update!(provider: "facebook", uid: "facebook-uid")
    end

    it "deletes the user" do
      post "/auth/facebook/data-deletion", params: {id: "facebook-uid"}

      expect(response).to have_http_status(200)
      expect(User.find_by(id: user.id)).to be_nil
    end

    it "returns a 404 if the user is not found" do
      post "/auth/facebook/data-deletion", params: {id: "unknown"}

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)).to eq({"success" => false, "message" => "User not found."})
    end
  end
end
