require "rails_helper"

RSpec.describe "removeListen", type: :graph do
  let(:user) { users(:normal) }
  let(:listen) { listens(:volver_a_sonar_normal_listen) }
  let(:recording) { listen.recording }
  let(:mutation) do
    <<~GQL
      mutation removeListen($id: ID!) {
        removeListen(input: {
          id: $id
        }) {
          success
          errors
        }
      }
    GQL
  end

  it "removes a listen" do
    gql(mutation, variables: {id: listen.id}, user:)

    expect(data.remove_listen.success).to be true
    expect(Listen.exists?(listen.id)).to be false
  end

  it "returns an error if the listen does not exist" do
    gql(mutation, variables: {id: 0}, user:)

    expect(data.remove_listen.errors.first).to eq("Couldn't find Listen with 'id'=0")
    expect(data.remove_listen.success).to be false
    expect(Listen.exists?(listen.id)).to be true
  end
end
