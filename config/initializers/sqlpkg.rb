# frozen_string_literal: true

module SqlpkgLoader
  def configure_connection
    super

    @raw_connection.enable_load_extension(true)
    Dir.glob(".sqlpkg/**/*.{dll,so,dylib}") do |extension_path|
      @raw_connection.load_extension(extension_path)
    end
    @raw_connection.enable_load_extension(false)
  end
end

ActiveSupport.on_load(:active_record_sqlite3adapter) do
  prepend SqlpkgLoader
end
