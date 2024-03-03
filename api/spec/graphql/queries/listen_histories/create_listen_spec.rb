require "rails_helper"

RSpec.describe "createListen", type: :graph do
  describe "mutation" do
    it "creates a listen history for the user and recording" do
      user = users(:normal)
      recording = recordings(:volver_a_sonar)

      query = <<~GQL
        mutation {
          createListen(input: {recordingId: "#{recording.id}"}) {
            listen {
              id
              recording {
                id
              }
            }
          }
        }
      GQL

      gql(query, variables: {recording_id: recording.id}, user:)

      listen = data.create_listen.listen

      expect(listen.recording.id).to eq(recording.id.to_s)
      expect(user.listen_history.listens.find(listen.id)).to be_present
      expect(user.listen_history.listens.find(listen.id).recording).to eq(recording)
      expect(user.listen_history.listens.find(listen.id).user).to eq(user)
      expect(user.listen_history.listens.find(listen.id).created_at).to be_present
    end
  end
end
