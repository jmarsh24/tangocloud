class UserLibrariesController < ApplicationController
  def show
    filter_type = params[:type]

    authorize @user_library

    @library_items = case filter_type
    when "playlists"
      @user_library.library_items.joins(:item).where(items: {type: "Playlist"})
    when "tandas"
      @user_library.library_items.joins(:item).where(items: {type: "Tanda"})
    else
      @user_library.library_items
    end

    respond_to do |format|
      format.turbo_stream.update("user-library", partial: "user_library/show", locals: {library_items: @library_items})
    end
  end

  def add_playlist
    playlist = Playlist.friendly.find(params[:id])
    authorize playlist, :add_to_library?

    library_item = current_user.user_library.library_items.create!(item: playlist)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("library-items", partial: "library_items/library_item", locals: {library_item:})
      end
    end
  end

  def add_tanda
    tanda = Tanda.friendly.find(params[:id])
    authorize tanda, :add_to_library?

    library_item = current_user.user_library.library_items.create!(item: tanda)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("library-items", partial: "library_items/library_item", locals: {library_item:})
      end
    end
  end
end
