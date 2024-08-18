require "rails_helper"

RSpec.describe NameUtils::NameParser, type: :model do
  it "parses a name with a pseudonym" do
    parsed_name = NameUtils::NameParser.parse("F.Lila (Juan Polito)")

    expect(parsed_name.formatted_name).to eq("F.Lila")
    expect(parsed_name.pseudonym).to eq("Juan Polito")
  end

  it "parses a name without a pseudonym" do
    parsed_name = NameUtils::NameParser.new("Juan D'Arienzo")

    expect(parsed_name.formatted_name).to eq("Juan D'Arienzo")
    expect(parsed_name.pseudonym).to be_nil
  end
end
