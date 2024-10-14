require "rails_helper"

RSpec.describe "GraphQL Introspection", type: :request do
  let(:introspection_query) do
    <<~GQL
      query {
        __schema {
          types {
            name
          }
        }
      }
    GQL
  end

  context "in development environment" do
    before do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("development"))
    end

    it "allows introspection in development" do
      post "/api/graphql", params: {query: introspection_query}

      json_response = JSON.parse(response.body)

      expect(json_response["data"]["__schema"]).not_to be_nil
    end
  end
end
