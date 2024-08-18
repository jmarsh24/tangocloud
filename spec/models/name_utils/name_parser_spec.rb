require "rails_helper"

RSpec.describe NameUtils::NameParser, type: :model do
  it "parses a name with a pseudonym" do
    parser = NameUtils::NameParser.new("F.Lila (Juan Polito)")

    result = parser.parse

    expect(result.formatted_name).to eq("F.Lila")
    expect(result.pseudonym).to eq("Juan Polito")
  end

  it "parses a name without a pseudonym" do
    parser = NameUtils::NameParser.new("Juan D'Arienzo")

    result = parser.parse

    expect(result.formatted_name).to eq("Juan D'Arienzo")
    expect(result.pseudonym).to be_nil
  end
end
