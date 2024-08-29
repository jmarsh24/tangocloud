require "rails_helper"

RSpec.describe "Create User", type: :request do
  let(:password) { "password123" }
  let!(:user) { create(:user, password:) }
  let(:payload) { {user_id: user.id} }
  let(:session) { JWTSessions::Session.new(payload:) }
  let(:tokens) { session.login }
  let(:access_token) { "Bearer #{tokens[:access]}" }

  describe "GET #show" do
    context "success" do
      it "returns the user when the access token is valid" do
        get api_user_path(user.id), headers: {JWTSessions.access_header => access_token}
        expect(response).to be_successful
        expect(json_response).to eq({"current_user" => user.to_json, "user" => user.to_json})
      end
    end

    context "failure" do
      it "returns 401 when no access token is provided" do
        get api_user_path(user.id)
        expect(response.code).to eq "401"
      end

      it "returns 401 when an incorrect access token is provided" do
        get api_user_path(user.id), headers: {JWTSessions.access_header => "Bearer invalid_token"}
        expect(response.code).to eq "401"
      end

      it "returns 401 when tokens are flushed" do
        session.flush_by_token(tokens[:refresh])
        get api_user_path(user.id), headers: {JWTSessions.access_header => access_token}
        expect(response.code).to eq "401"
      end
    end
  end

  describe "POST #create" do
    let(:email) { "new@test.com" }
    let(:user_params) { {user: {email:, password:}} }

    context "success" do
      it "creates a new user when the access token is valid" do
        post api_users_path, headers: {JWTSessions.access_header => access_token}, params: user_params
        expect(response).to be_successful
        expect(json_response["current_user"]).to eq user.to_json
        expect(JSON.parse(json_response["user"])["email"]).to eq email
      end
    end

    context "failure" do
      it "returns 401 when no access token is provided" do
        post api_users_path, params: user_params
        expect(response.code).to eq "401"
      end

      it "allows request when using headers without CSRF token" do
        post api_users_path, headers: {JWTSessions.access_header => access_token}, params: user_params
        expect(response.code).to eq "200"
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
