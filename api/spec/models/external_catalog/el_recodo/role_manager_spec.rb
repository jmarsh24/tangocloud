require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::RoleManager do
  describe "#sync_people" do
    before do
      stub_request(:get, "https://www.el-recodo.com/music?O=Juan%20D'ARIENZO&lang=en")
        .to_return(
          status: 200,
          body: File.read(Rails.root.join("spec/fixtures/html/el_recodo_person_juan_darienzo.html"))
        )
      stub_request(:get, "https://www.el-recodo.com/w_pict/maestros/juan%20d'arienzo")
        .to_return(
          status: 200,
          body: File.read(Rails.root.join("spec/fixtures/files/di_sarli.jpg")),
          headers: {"Content-Type" => "image/jpeg"}
        )
    end

    it "creates the roles for the given people" do
      el_recodo_song = create(:el_recodo_song)
      person = ExternalCatalog::ElRecodo::SongScraper::Person.new(
        name: "Juan D'Arienzo",
        role: "orchestra",
        url: "music?O=Juan D'ARIENZO&lang=en"
      )

      role_manager = ExternalCatalog::ElRecodo::RoleManager.new(cookies: "some_cookie")
      role_manager.sync_people(
        el_recodo_song:,
        people: [person]
      )

      expect(el_recodo_song.orchestra.name).to eq("Juan D'Arienzo")
      expect(el_recodo_song.people_roles.count).to eq(1)
      expect(el_recodo_song.people_roles.first.person.name).to eq("Juan D'Arienzo")
      expect(el_recodo_song.people_roles.first.person.birth_date).to eq(Date.new(1900, 12, 14))
      expect(el_recodo_song.people_roles.first.person.death_date).to eq(Date.new(1976, 1, 14))
      expect(el_recodo_song.people_roles.first.person.real_name).to eq("D'Arienzo, Juan")
      expect(el_recodo_song.people_roles.first.person.nicknames).to eq(["El Rey del compás"])
      expect(el_recodo_song.people_roles.first.person.place_of_birth).to eq("Buenos Aires Argentina")
      expect(el_recodo_song.people_roles.first.person.path).to eq("music?O=Juan D'ARIENZO&lang=en")
      expect(el_recodo_song.people_roles.first.person.image.attached?).to be(true)
    end
  end
end
