require "rails_helper"

RSpec.describe "StringExtensions" do
  describe "#titleize_name" do
    it "capitalizes the first letter of each word in a name" do
      expect("john doe".titleize_name).to eq("John Doe")
    end

    it "handles uppercase names correctly" do
      expect("JOHN DOE".titleize_name).to eq("John Doe")
    end

    it "handles mixed-case names correctly" do
      expect("jOhN dOe".titleize_name).to eq("John Doe")
    end

    it "does not alter the casing of letters following an apostrophe" do
      expect("juan d'arienzo".titleize_name).to eq("Juan D'Arienzo")
    end

    it "handles names with multiple parts correctly" do
      expect("jean-claude van damme".titleize_name).to eq("Jean-Claude Van Damme")
    end
  end
end
