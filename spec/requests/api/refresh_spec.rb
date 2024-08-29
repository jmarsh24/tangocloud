require "rails_helper"

RSpec.describe "Api::RefreshController", type: :request do
  let(:password) { "password123" }
  let!(:user) { create(:user, password:) }

  describe "POST #create" do
    let(:payload) { {user_id: user.id} }
    let(:session) { JWTSessions::Session.new(payload:, refresh_payload: payload) }
    let(:tokens) { session.login }

    context "success" do
      let(:refresh_token) { "Bearer #{tokens[:refresh]}" }

      it "succeeds with refresh token in Authorization header" do
        post api_refresh_path, headers: {JWTSessions.refresh_header => refresh_token}
        expect(response).to be_successful
        expect(json_response.keys.sort).to eq ["access", "access_expires_at", "csrf"]
      end

      it "succeeds with refresh token in lowercase Authorization header" do
        post api_refresh_path, headers: {JWTSessions.refresh_header.downcase => refresh_token}
        expect(response).to be_successful
        expect(json_response.keys.sort).to eq ["access", "access_expires_at", "csrf"]
      end
    end

    context "failure" do
      it "fails when tokens are absent" do
        post api_refresh_path
        expect(response.code).to eq "401"
      end

      it "fails with invalid refresh token in header" do
        post api_refresh_path, headers: {JWTSessions.refresh_header => "123abc"}
        expect(response.code).to eq "401"
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
