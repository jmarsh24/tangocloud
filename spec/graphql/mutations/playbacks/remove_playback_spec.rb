require "rails_helper"

RSpec.describe "RemovePlayback", type: :graph do
  let!(:mutation) do
    <<~GQL
      mutation RemovePlayback($id: ID!) {
        removePlayback(input: {id: $id}) {
          success
          errors
        }
      }
    GQL
  end

  describe "removePlayback" do
    it "removes a playback" do
      user = create(:user)
      recording = create(:recording)
      playback = create(:playback, user:, recording:)

      variables = {id: playback.id}

      gql(mutation, variables:, user:)

      expect(Playback.find_by(id: playback.id)).to be_nil
      expect(data.remove_playback.success).to be(true)
    end
  end
end
