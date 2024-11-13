class UserLibrariesController < ApplicationController
  def add_playlist
    playlist = Playlist.friendly.find(params[:id])
    authorize playlist, :add_to_library?

    library_item = current_user.user_library.library_items.create!(item: playlist)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append('library-items', partial: 'library_items/library_item', locals: { library_item: })
      end
    end

  end

  def add_tanda
    tanda = Tanda.friendly.find(params[:id])
    authorize tanda, :add_to_library?

    library_item = current_user.user_library.library_items.create!(item: tanda)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append('library-items', partial: 'library_items/library_item', locals: { library_item: })
      end
    end
  end
end