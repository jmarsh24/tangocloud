require "rails_helper"

RSpec.describe ExternalCatalog::ElRecodo::RoleManager do
  describe "#sync_people" do
    before do
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
        url: "music?O=Juan%20D'ARIENZO&lang=en"
      )

      person_scraper = ExternalCatalog::ElRecodo::PersonScraper.new(cookies: "some_cookie")
      allow(person_scraper).to receive(:fetch).and_return(
        ExternalCatalog::ElRecodo::PersonScraper::Person.new(
          name: "Juan D'Arienzo",
          birth_date: Date.new(1900, 12, 14),
          death_date: Date.new(1976, 1, 14),
          real_name: "D'Arienzo, Juan",
          nicknames: ["El Rey del compás"],
          place_of_birth: "Buenos Aires Argentina",
          path: "music?O=Juan%20D'ARIENZO&lang=en",
          image_path: "w_pict/maestros/juan%20d'arienzo"
        )
      )

      role_manager = ExternalCatalog::ElRecodo::RoleManager.new(
        cookies: "some_cookie",
        person_scraper:
      )

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
      expect(el_recodo_song.people_roles.first.person.path).to eq("music?O=Juan%20D'ARIENZO&lang=en")
      expect(el_recodo_song.people_roles.first.person.image.attached?).to be(true)
    end
  end
end
