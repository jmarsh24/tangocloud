# This controller has been generated to enable Rails' resource routes.
# More information on https://docs.avohq.io/2.0/controllers.html
class Avo::PlaylistsController < Avo::ResourcesController
  def create_success_action
    @record.playlist_file.blob.open do |file|
      Import::Playlist::PlaylistImporter.new(@record).import
    end
    @record.attach_default_image if @record.image.blank?
    super
  end
end
