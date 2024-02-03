require "rails_helper"

RSpec.describe "GraphQL schema" do
  it "must be reflected in the .graphql file" do
    current_defn = TangocloudSchema.to_definition
    printout_defn = File.read(Rails.root.join("app/graphql/schema.graphql"))
    assert_equal(current_defn, printout_defn, "Update the printed schema with `bundle exec rake dump_schema`")
  end
end
