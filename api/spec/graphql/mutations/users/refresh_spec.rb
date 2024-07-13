require "rails_helper"

RSpec.describe "Users::Refresh", type: :graph do
  let(:user) { create(:user) }
  let(:session) { JWTSessions::Session.new(payload: {user_id: user.id}, refresh_by_access_allowed: true) }
  let(:tokens) { session.login }

  let(:mutation) do
    <<~GQL
      mutation refresh($refreshToken: String!) {
        refresh(input: { refreshToken: $refreshToken }) {
          ... on Session {
            access
            accessExpiresAt
            refresh
            refreshExpiresAt
          }
          ... on FailedRefresh {
            error
          }
        }
      }
    GQL
  end

  it "refreshes the tokens successfully" do
    freeze_time

    original_access_token = tokens[:access]
    original_refresh_token = tokens[:refresh]

    travel_to(2.hours.from_now) do
      variables = {refreshToken: original_refresh_token}
      gql(mutation, variables:, user:)

      new_access_expires_at = Time.parse(data.refresh.access_expires_at).utc
      new_refresh_expires_at = Time.parse(data.refresh.refresh_expires_at).utc

      expect(data["access"]).not_to eq(original_access_token)
      expect(data["refresh"]).not_to eq(original_refresh_token)

      expect(new_access_expires_at).to eq(1.hour.from_now.utc)
      expect(new_refresh_expires_at).to eq(7.days.from_now.utc)
    end
  end

  it "fails with an invalid refresh token" do
    variables = {refreshToken: "invalid_token"}

    gql(mutation, variables:, user:)

    expect(result.refresh.errors).not_to be_empty
    expect(data.refresh.error).to eq("Invalid refresh token")
  end

  it "fails with an expired refresh token" do
    freeze_time

    original_refresh_token = tokens[:refresh]

    travel_to(8.days.from_now) do
      variables = {refreshToken: original_refresh_token}
      gql(mutation, variables:, user:)

      expect(data.refresh.error).to eq("Invalid refresh token")
    end
  end

  context "when the user is not authenticated" do
    it "returns an error" do
      variables = {refreshToken: "invalid"}

      gql(mutation, variables:, user: nil)

      expect(data.refresh.error).not_to be_empty
      expect(data.refresh.error).to eq("Not authorized")
    end
  end
end
