require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::Auth do
  describe "#cookies" do
    it "returns the cookies for the given email and password" do
      stub_request(:post, "https://www.el-recodo.com/connect?lang=en")
        .to_return(status: 302, headers: {"Set-Cookie" => "some_cookie"})

      cookies = ExternalCatalog::ElRecodo::Auth.new(email: "email", password: "password").cookies

      expect(cookies).to eq("some_cookie")
    end
  end
end
