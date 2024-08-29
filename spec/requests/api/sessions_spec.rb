require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:password) { "password123" }
  let!(:user) { create(:user, password:) }

  describe "POST #create" do
    context "success" do
      before { post api_login_path, params: {login: user.email, password:} }

      it "is successful and returns tokens" do
        expect(response).to be_successful
        expect(json_response.keys.sort).to eq ["access", "access_expires_at", "csrf", "refresh", "refresh_expires_at"]
      end
    end
  end

  describe "DELETE #destroy" do
    context "success" do
      before do
        payload = {user_id: user.id}
        session = JWTSessions::Session.new(payload:, refresh_by_access_allowed: true)
        tokens = session.login

        delete api_logout_path, headers: {
          JWTSessions.access_header => "Bearer #{tokens[:access]}"
        }
      end

      it "is successful and returns ok" do
        expect(response).to be_successful
        expect(json_response).to eq "ok"
      end
    end

    context "success after refresh" do
      before do
        payload = {user_id: user.id}
        session = JWTSessions::Session.new(payload:, refresh_by_access_allowed: true)
        session.login

        session2 = JWTSessions::Session.new(payload: session.payload, refresh_by_access_allowed: true)
        tokens = session2.refresh_by_access_payload

        delete api_logout_path, headers: {
          JWTSessions.access_header => "Bearer #{tokens[:access]}"
        }
      end

      it "is successful and returns ok" do
        expect(response).to be_successful
        expect(json_response).to eq "ok"
      end
    end
  end

  # Helper method to parse JSON response
  def json_response
    JSON.parse(response.body)
  end
end
