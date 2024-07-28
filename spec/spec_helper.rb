RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.order = :random

  config.before(:suite) do
    # reindex models
    ExternalCatalog::ElRecodo::Song.reindex
    Recording.reindex
    Playlist.reindex
    Person.reindex
    Genre.reindex
    Orchestra.reindex
    TimePeriod.reindex
    User.reindex

    # and disable callbacks
    Searchkick.disable_callbacks
  end

  config.around(:each, search: true) do |example|
    Searchkick.callbacks(nil) do
      example.run
    end
  end
end
